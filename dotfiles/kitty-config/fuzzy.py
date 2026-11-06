"""Kitten that fuzzy finds any information from KeePassXC."""

import json
import os
import pathlib
import re
import subprocess
import sys
import typing as t
import webbrowser

sys.path.insert(
    0,
    str(
        pathlib.Path.home()
        / (
            ".local/share/uv/python/cpython-3.12.8-macos-aarch64-none"
            "/lib/python3.12/site-packages"
        )
    ),
)
try:
    from pyfzf.pyfzf import FzfPrompt  # type: ignore[import]
except Exception as exp:
    msg = (
        "Cannot find 'pyfzf' module."
        " Check the sys.path extension in 'fuzzy.py'."
        f" Its first entry is '{sys.path[0]}' and must belong"
        " to the active Python interpreter."
        " If this is correct, the module 'pyfzf' seems to be missing."
        " and shall be installed with"
        " '$(which python3) -m pip install pyfzf'."
    )
    raise RuntimeError(msg) from exp

from kitty.boss import Boss, which  # type: ignore[import]

GOOGLE_DRIVE_PATH = (
    pathlib.Path.home()
    / "Library/CloudStorage/GoogleDrive-jamil.elkhadra@gmail.com/My Drive"
)
ASSETS_PATH = GOOGLE_DRIVE_PATH / "assets"
DB_PATH = GOOGLE_DRIVE_PATH / "jamil.kdbx"
FZF_EXE = "/usr/local/bin/fzf"
if not pathlib.Path(FZF_EXE).is_file():
    FZF_EXE = "/usr/sbin/fzf"
KEEPASSXC_EXE = (
    pathlib.Path.home()
    / "Applications/KeePassXC.app/Contents/MacOS/keepassxc-cli"
)
if not KEEPASSXC_EXE.is_file():
    KEEPASSXC_EXE = pathlib.Path("keepassxc-cli")
MASTER_SECRET = (
    (pathlib.Path.home() / "engine-room/secrets/keepass_jamil")
    .read_text(encoding="utf8")
    .replace("\n", "")
)
SOFTWARE_VERSION_PATTERN = r"^(\d+|\d+\.\d+|\d+\.\d+\.\d+)$"
"""Define a RegEx for typical software version strings."""


def _attr_value_of_secret(
    secret: str, option: str, errmsg: bool = True
) -> t.Optional[str]:
    if option in (
        "bookmark",
        "file",
        "url",
    ):
        attr_name = "URL"
    elif option == "Notes":
        attr_name = "Notes"
    elif option == "user":
        attr_name = "UserName"
    elif option == "password":
        attr_name = "Password"
    else:
        attr_name = option
    val = None
    cmd = [
        str(KEEPASSXC_EXE),
        "show",
        "--quiet",
    ]
    if option == "password":
        cmd.append("--show-protected")
    cmd += [str(DB_PATH), secret]
    stdout, stderr = subprocess.Popen(
        cmd,
        stdin=subprocess.PIPE,
        stdout=subprocess.PIPE,
    ).communicate(MASTER_SECRET.encode())
    if stderr:
        _error(stderr.decode())
        return None
    key = f"{attr_name}:"
    attrs = [
        attr.split(key)[1]
        for attr in stdout.decode().splitlines()
        if attr.startswith(key)
    ]
    if attrs and attrs[0].strip():
        val = attrs[0]
        if attr_name == "URL" and "Python packages" in secret:
            title = str(_attr_value_of_secret(secret, "Title")).strip()
            notes = str(
                _attr_value_of_secret(secret, "Notes", errmsg=False)
            ).strip()
            val = _python_pkg_url(title=title, backup_url=val, notes=notes)
    elif errmsg:
        _error(f"The entry '{secret}' has no filled attribute '{attr_name}'!")
    return val


def _decompose_version(version: str) -> dict[str, t.Optional[str]]:
    r"""Parse major, minor, patch from a version string.

    The string *version* will be stripped before it gets processed.

    Parameters
    ----------
    version
        A version string (e. g. ``"1.2.3"`` or ``"3.5"``) to parse.

    Returns
    -------
    dict[str, t.Optional[str]]
        A dict with keys ``"major"``, ``"minor"``, and ``"patch"``.
        If *version* is not providing a minor or patch version
        information the according key values will be None.

    Raises
    ------
    TypeError
        If *version* is not a string.

    ValueError
        If *version* does not match the regular expression
        ``r"^(\d+|\d+\.\d+|\d+\.\d+\.\d+)$"``.

    Examples
    --------
    >>> decompose_version(version="1.2.3")
    {'major': '1', 'minor': '2', 'patch': '3'}

    >>> decompose_version(version="1.2")
    {'major': '1', 'minor': '2', 'patch': None}

    >>> decompose_version(version="1")
    {'major': '1', 'minor': None, 'patch': None}

    .. index::
        single: Version (decompose)

    """
    if not isinstance(version, str):  # type: ignore
        raise TypeError("The argument 'version' must be a string.")
    version = version.strip()
    if re.match(SOFTWARE_VERSION_PATTERN, version) is None:
        raise ValueError(
            f"Cannot decompose software version information from '{version}'!"
        )
    _version: dict[str, t.Optional[str]] = {
        "major": None,
        "minor": None,
        "patch": None,
    }
    if "." in version:
        version_splitted = version.split(".")
        _version["major"] = version_splitted[0]
        _version["minor"] = version_splitted[1]
        if version.count(".") == 2:
            _version["patch"] = version_splitted[2]
    else:
        _version["major"] = version
    return _version


def _error(msg: str) -> None:
    input(f"{msg}\nPress Enter to quit...")


def _fill_placeholders(subject: str, **kwargs: str) -> str:
    """Populate placeholders of format ``$[NAME]`` in a template string.

    Parameters
    ----------
    subject
        String with named (keys of *kwargs*) placeholders to be filled.

    kwargs
        Key/ value pairs with:

        * key: placeholder name
        * val: value for the placeholder to be filled

    Returns
    -------
    str
        Populated string

    Raises
    ------
    TypeError
        If *subject* is not a string.

    Examples
    --------
    >>> fill_placeholders("Hello $[NAME]!", {"NAME": "my friend"})
    'Hello my friend!'

    >>> version = {"MAJOR": "1", "MINOR": "2", "PATCH": "3"}
    >>> fill_placeholders("V: $[MAJOR].$[MINOR].$[PATCH]", version)
    'V: 1.2.3'

    """
    if not isinstance(subject, str):
        raise TypeError("The argument 'subject' must be a string.")
    if "$[" not in subject:
        return subject
    for key, val in kwargs.items():
        place_holder = "$[" + key + "]"
        if val is not None:
            subject = subject.replace(place_holder, val)
        # else:
        #     subject = subject.replace(place_holder, "")
    return subject


def _python_pkg_url(title: str, backup_url: str, notes: str) -> str:
    """"""
    url = backup_url
    pkgname = ""
    if " " in title:
        pkgname = title.split(" ")[0]
    if not pkgname or not notes.startswith("http"):
        return url
    version = _python_pkg_version(pkgname)
    if version is None:
        return url
    elif "\n" in notes:
        url = notes.split("\n")[0].rstrip()
    else:
        url = notes.rstrip()
    versionparts = _decompose_version(version)
    url = _fill_placeholders(
        url,
        MAJOR=versionparts["major"],  # type: ignore
        MINOR=versionparts["minor"],  # type: ignore
        PATCH=versionparts["patch"],  # type: ignore
    )
    return url


def _python_pkg_version(name: str) -> t.Optional[str]:
    """Return Python pkg version for current active Python interpreter.

    Parameters
    ----------
    name
        Name of an installed Python package or ``python``.

    Returns
    -------
    t.Optional[str]
        Version returned by pip or None, when pkg is not installed

    """
    if name.lower().strip() == "python":
        python: t.Optional[str] = which("python")
        if python is None:
            return None
        python_interpreter: str = str(pathlib.Path(python).resolve())
        output = subprocess.check_output(
            [
                python_interpreter,
                "-c",
                "import sys;"
                "v = '.'.join([str(i) for i in tuple(sys.version_info)[:3]]);"
                "print(v)",
            ],
            encoding="utf8",
        )
        python_version = output.replace("\r\n", "").replace("\n", "")
        return python_version
    pip: t.Optional[str] = which("pip")
    if pip is None:
        return None
    cmd: list[str] = [
        pip,
        "list",
    ]
    try:
        _ = os.environ["VIRTUAL_ENV"]
        cmd.append("--require-virtualenv")
    except KeyError:
        pass
    cmd += [
        "--format",
        "json",
    ]
    output = subprocess.check_output(cmd, encoding="utf8")
    pkgs: list[dict[str, str]] = json.loads(output)
    found_version = [pkg["version"] for pkg in pkgs if pkg["name"] == name]
    if found_version:
        version = found_version[0]
        return version
    else:
        return None


def _select_keepass_secret(option: str) -> t.Optional[str]:
    """Select secret from KeePassXC entries that have a user name."""
    secret: t.Optional[str] = None
    stdout, stderr = subprocess.Popen(
        [
            str(KEEPASSXC_EXE),
            "ls",
            "--quiet",
            "--recursive",
            "--flatten",
            str(DB_PATH),
        ],
        stdin=subprocess.PIPE,
        stdout=subprocess.PIPE,
    ).communicate(MASTER_SECRET.encode())
    if stderr:
        _error(stderr.decode())
        return None
    items = [i for i in stdout.decode().splitlines() if not i.endswith("/")]
    if items and option in (
        "bookmark",
        "file",
    ):
        items = [
            item.replace(f"Assets/{option.capitalize()}s/", "")
            for item in items
            if item.startswith(f"Assets/{option.capitalize()}s/")
            and not item.endswith("[empty]")
        ]
    items = [item for item in items if not item.startswith("Recycle Bin")]
    fzf = FzfPrompt(FZF_EXE)
    secret = fzf.prompt(
        items,
        fzf_options="--color='fg+:#ffffff,fg:#608b4e,hl:#ff0000,hl+:#ff0000'",
    )
    if secret:
        secret = secret[0]
        if option in (
            "bookmark",
            "file",
        ):
            secret = f"Assets/{option.capitalize()}s/{secret}"
    else:
        secret = None
    return secret


def main(args: list[str]) -> t.Optional[str]:
    """Entrypoint called when kitten is being executed.

    Parameters
    ----------
    args : optional
        Arguments passed to this kitten

    """
    if len(args) != 2:
        _error("Invalid number of arguments passed to kitten!")
        return None
    if (option := args[1].lower().strip()) not in (
        "bookmark",
        "file",
        "password",
        "url",
        "user",
    ):
        _error(
            f"Invalid argument '{args[1]}' passed to kitten. Expecting one "
            "out of 'bookmark', 'file', 'password', 'url', 'user'."
        )
        return None
    if not pathlib.Path(FZF_EXE).exists():
        _error(f"Cannot find FZF at '{FZF_EXE}'!")
        return None
    if (secret := _select_keepass_secret(option)) is None:
        return None
    answer = _attr_value_of_secret(secret, option)
    if answer is not None:
        answer = answer.strip()  # answer is an URL
    return answer


def handle_result(
    args: list[str],
    answer: str,
    target_window_id: int,
    boss: t.Optional[Boss] = None,
) -> None:
    """Handle return value from ``main``."""
    option = args[1].lower().strip()
    if option == "bookmark":
        webbrowser.open(answer, autoraise=True)
    elif option == "file":
        subprocess.check_call(
            [
                "open",
                "-a",
                "Preview.app",
                f"{ASSETS_PATH}/{answer}",
            ]
        )
    else:
        if boss is None:
            return
        w = boss.window_id_map.get(target_window_id)
        if w is not None:
            w.paste(answer.strip())
