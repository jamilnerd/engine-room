#!/usr/bin/env zsh

backup() {
  [[ -f /mnt/volume/zsh_history ]] && cp /mnt/volume/zsh_history ~/googledrive/engine-room/zsh_history
  rsync -avh --delete --progress --exclude-from="$HOME/engine-room/dotfiles/backup_volume_rsync_exclude.list" ~/engine-room/secrets/ ~/googledrive/engine-room/secrets
  rsync -avh --delete --progress --exclude-from="$HOME/engine-room/dotfiles/backup_volume_rsync_exclude.list" /mnt/volume/dev/ ~/googledrive/engine-room/dev
}
bak() {
  # Check if the argument is provided
  if [ -z "$1" ]; then
    echo "Usage: bak <file_or_folder_path>"
    return 1
  fi

  # Convert the provided path to an absolute path
  local input_path="$1"
  local abs_path=$(realpath "$input_path")

  # Check if the path exists
  if [ ! -e "$abs_path" ]; then
    echo "Error: The path '$abs_path' does not exist."
    return 1
  fi

  # Create the backup path
  local backup_path="${abs_path}.bak"

  # Copy the file or folder to the backup path
  if [ -d "$abs_path" ]; then
    cp -r "$abs_path" "$backup_path"
  else
    cp "$abs_path" "$backup_path"
  fi

  echo "Backup created at '$backup_path'"
}
cd() {
  if [[ "$1" == "-" && "$#" -eq 1 ]]; then
    local target_dir
    target_dir=$("$DOT/zsh/bin/cd.py" "-")
    if [[ $? -eq 0 && -n "$target_dir" ]]; then
      builtin cd "$target_dir"
    fi
  else
    if [[ -z "$1" ]]; then
      builtin cd
    else
      local resolved_path
      resolved_path=$("$DOT/zsh/bin/cd.py" "$1")
      if [[ -n "$resolved_path" ]]; then
        builtin cd "$resolved_path" "${@:2}"
      else
        builtin cd "$@"
      fi
    fi
  fi
}
cleanpy_func() {
  find $PWD -depth -type d -name '__pycache__' -exec rm -Rf {} \;
  find $PWD -depth -type f -name '*.pyc' -exec rm -f {} \;
}
deactivate-venv() {
  unset -f pydoc > /dev/null 2>&1 || true
  if ! [ -z "${_OLD_VIRTUAL_PATH:+_}" ]; then
    PATH="$_OLD_VIRTUAL_PATH"
    export PATH
    unset _OLD_VIRTUAL_PATH
  fi
  if ! [ -z "${_OLD_VIRTUAL_PYTHONHOME+_}" ]; then
    PYTHONHOME="$_OLD_VIRTUAL_PYTHONHOME"
    export PYTHONHOME
    unset _OLD_VIRTUAL_PYTHONHOME
  fi
  hash -r 2> /dev/null
  if ! [ -z "${_OLD_VIRTUAL_PS1+_}" ]; then
    PS1="$_OLD_VIRTUAL_PS1"
    export PS1
    unset _OLD_VIRTUAL_PS1
  fi
  unset VIRTUAL_ENV
  unset VIRTUAL_ENV_PROMPT
  unset STARSHIP_PYTHON_VENV_PARENT
}
__load_nvm() {
  unfunction nvm node npm npx __load_nvm 2> /dev/null
  [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"
}
h2() {
  echo "$1;" | java -cp ./h2/bin/h2-1.3.169.jar org.h2.tools.Shell -user wsa -url jdbc:h2:tcp://172.17.0.3:5234/automated-train
}
json() {
  curl $@ -s | bat -l JSON --paging=auto
}
nvm() {
  __load_nvm
  nvm "$@"
}
node() {
  __load_nvm
  node "$@"
}
npm() {
  __load_nvm
  npm "$@"
}
npx() {
  __load_nvm
  npx "$@"
}
pathprepend() {
  if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
    export PATH="$1:${PATH:+"$PATH"}"
  fi
}
source_file() {
  file="${1:-.env}"
  if [ -f "$file" ]; then
    set -a
    source "$file"
    set +a
  else
    echo "$file file not found"
  fi
}
ssh() {
  if [[ -n $KITTY_PID && $TERM == xterm-kitty ]]; then
    kitty +kitten ssh "$@"
  else
    /usr/bin/ssh "$@"
  fi
}
urlencode() {
  if [ -n "$1" ]; then
    python -c "from urllib.parse import quote; print(quote('$1'))"
  fi
}
venv() {
  deactivate
  [[ -f .python-version ]] && rm .python-version
  [[ -d .venv ]] && rm -rf .venv
  VERSION=${1:-3.15.2}
  uv venv --python=$VERSION .venv
  source .venv/bin/activate
  uv pip install --upgrade pip
  uv pip install -r $DOT/requirements.txt
  if [[ -f pyproject.toml ]]; then
    if [[ -f uv.lock ]]; then
      uv sync --frozen --inexact
    else
      uv sync --inexact
    fi
  fi
  cd .
}
