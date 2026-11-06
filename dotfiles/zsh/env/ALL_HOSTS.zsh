[[ -f $HOME/.cargo/env ]] && . "$HOME/.cargo/env"
[[ -f $HOME/.engine_room_env ]] && . "$HOME/.engine_room_env"
export DOT=$HOME/engine-room/dotfiles
export EDITOR=nvim
export ENV GPG_TTY=$TTY # see: https://unix.stackexchange.com/a/608921
export ER=$HOME/engine-room
export FZF_CTRL_T_OPTS='--color="fg+:#ffffff,fg:#608b4e,hl:#ff0000,hl+:#ff0000" --history-size=10000 --preview="bat --style=changes,header,numbers --color=always {}"'
export FZF_DEFAULT_OPTS='--color="fg+:#ffffff,fg:#608b4e,hl:#ff0000,hl+:#ff0000" --history-size=10000'
[[ -d /mnt/volume ]] && export HISTFILE=/mnt/volume/zsh_history || export HISTFILE=$HOME/.zsh_history
export ARTIFACTORY_PAT="$(cat $HOME/engine-room/secrets/artifactory.pat)"
export DB_GENAIHUB_API_KEY="$(cat $HOME/engine-room/secrets/genai-aws-bedrock.pat)"
export DB_GENAIHUB_API_KEY_OPEN_AI="$(cat $HOME/engine-room/secrets/genai-openai.pat)"
export CONFLUENCE_PAT="$(cat $HOME/engine-room/secrets/confluence.pat)"
export CONFLUENCE_URL="https://dsd-confluence.jaas.service.deutschebahn.com"
export GITLAB_PAT="$(cat $HOME/engine-room/secrets/gitlab.pat)"
export GITLAB_READ_PAT="$(cat $HOME/engine-room/secrets/gitlab-read.pat)"
export JAVA_HOME=/usr/lib/jvm/jdk
export JIRA_PAT="$(cat $HOME/engine-room/secrets/jira.token)"
export JIRA_URL="https://dsd-jira.jaas.service.deutschebahn.com"
export JQ_COLORS="1;36:0;39:0;39:0;39:0;32:1;39:1;39"
export LANG=en_US.UTF-8
export LANGUAGE=en_US:en:C
export MANPAGER="nvim +Man! "
export MYNAME="jamilraichouni"
export NVIM_DOCS="/opt/nvim/share/nvim/runtime/doc"
export NVM_DIR="$HOME/.nvm"
export NVM_BIN="$(realpath $NVM_DIR/versions/node/v*/bin)"
export OPENCODE_CONFIG_DIR="$HOME/.config/opencode"
export OPENCODE_ENABLE_EXA=1
export POLARION_PAT_PU="$(cat $HOME/engine-room/secrets/polarion-pu.pat)"
export POLARION_PAT_TU="$(cat $HOME/engine-room/secrets/polarion-tu.pat)"
export POLARION_PAT=${POLARION_PAT_PU}
export POLARION_URL_PU="https://awspoldsdpu.polarion.comp.db.de/polarion"
export POLARION_URL_TU="https://awspoldsdtu.polarion-iat.comp.db.de/polarion"
export POLARION_URL=${POLARION_URL_PU}
export PYTHON_COLORS=1
export SHELL=/bin/zsh
if [[ "$HOST" == "engine-room-"* ]]; then
  export PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser
  export SSH_AUTH_SOCK=/run/host-services/ssh-auth.sock
fi
if [[ "$(uname -o)" != *"Darwin"* ]]; then
  export DISPLAY="host.docker.internal:0.0"
  export KUBECONFIG=$HOME/dev/dbgitlab/gitops/access/ardks-iat-nzfcw.kubeconfig
  export TERM=xterm-kitty
  export TERMINFO=/usr/share/terminfo
  export VOL=/mnt/volume
  sudo chmod 666 /run/secrets/GITLAB_PAT
fi
export TZ=":/usr/share/zoneinfo/Europe/Berlin"
export VISUAL=nvim

# Source zsh functions
source $HOME/engine-room/dotfiles/zsh/funcs.zsh

# Add paths without duplication
pathprepend $HOME/.cargo/bin
pathprepend $HOME/.krew/bin
pathprepend $HOME/.local/bin
pathprepend $HOME/engine-room/dotfiles/zsh/bin
pathprepend $JAVA_HOME/bin
pathprepend $HOME/.local/share/nvim/mason/bin
NVM_NODE_BIN=$(realpath $HOME/.nvm/versions/node/v*/bin 2> /dev/null | head -1)
[[ -n "$NVM_NODE_BIN" ]] && pathprepend $NVM_NODE_BIN
export REQUESTS_CA_BUNDLE=$HOME/engine-room/secrets/ssl_certificates.pem
export SSL_CERT_FILE=$REQUESTS_CA_BUNDLE
export UV_CACHE_DIR=/mnt/volume/cache/uv
export UV_CONFIG_FILE=$HOME/engine-room/dotfiles/uv.toml
export UV_DEFAULT_INDEX=https://bahnhub.tech.rz.db.de/artifactory/api/pypi/pypi-remote/simple
export UV_INDEX=https://bahnhub.tech.rz.db.de/artifactory/api/pypi/pypi-remote/pypi
export UV_PYTHON_DOWNLOADS=auto
export UV_PYTHON_INSTALL_DIR=/opt/python
export UV_UNMANAGED_INSTALL=/usr/bin/

[[ -f /etc/zshenv.secrets ]] && . /etc/zshenv.secrets

# Properly activate /opt/.venv if it exists and not already in a venv
if [[ -f /opt/.venv/bin/activate ]] && [[ -z "$VIRTUAL_ENV" ]]; then
  . /opt/.venv/bin/activate
fi
