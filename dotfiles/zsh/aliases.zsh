unalias -a

# core:
alias :q='exit'
alias :qa='exit'
alias venv-deactivate='deactivate-venv'
if [[ "$(uname -o)" == *"Darwin"* ]]; then
  alias ls='ls --color'
  alias dbmac='/usr/bin/ssh -q -o StrictHostKeyChecking=false dbmac'
  alias dbmacrestart='docker compose down dbmac; rm -f ~/.ssh/known_hosts && docker compose up -d dbmac'
else
  alias ls='ls --color --time-style=+"%Y-%m-%d|%H:%M:%S"'
  alias ua-tools='docker run --platform linux/amd64 -p 6080:6080 -v uaexpert-config:/root/.config/unifiedautomation -v /opt/bind:/opt/bind --rm --name ua-tools ua-tools'
fi
alias l='ls -lh'   # h makes sizes human-readable
alias ll='ls -lha' # a shows dot files
alias src='. ~/.zshrc'
alias watch='watch --color'

# dirs:
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'

alias starsatoc-7331='cd ~/dev/dbgitlab/ivv-test-case-auditor-spec'
alias starsatoc-7352='cd ~/dev/dbgitlab/ivv-deprecated-test-case-reporter-spec'
alias 3rd='cd ~/dev/3rdparty'
alias ardks='cd ~/dev/dbgitlab/ar-dks'
alias atr='cd /opt/bind/dev/dbgitlab/atoc-test-runner'
alias bind='cd /mnt/bind'
alias ck='cd ~/.config/kitty'
alias cn='cd ~/.config/nvim'
alias co='cd ~/.config/opencode'
alias d='cd ~/dev'
alias dev='cd ~/dev'
alias dbgl='cd ~/dev/dbgitlab'
alias dot='cd ~/engine-room/dotfiles'
alias er='cd ~/engine-room'
alias gh='cd ~/dev/github'
alias gl='cd ~/dev/gitlab'
alias ivv='cd ~/dev/dbgitlab/ivv'
alias loc='cd ~/dev/local'
alias mbse='cd ~/dev/github/capellambse'
alias mdd='cd ~/dev/dbgitlab/mddocgen'
alias o='cd ~/.config/opencode'
alias oddp='cd ~/dev/dbgitlab/oddp'
alias osc='cd ~/dev/dbgitlab/obu-sim-client'
alias rev='cd ~/dev/dbgitlab/review-test-artifacts'
alias sdd='cd /home/nerd/dev/dbgitlab/cookiecutter-agent-spec-template/{{cookiecutter.project_directory_name}}-spec'
alias tmp='cd /tmp'
alias ws='cd /opt/bind/workspaces'
alias x='cd /opt/bind/x'

# edit specific files
alias Ali='$EDITOR $DOT/zsh/aliases.zsh'
alias Auto='$EDITOR ~/.config/nvim/lua/init/autocmd.lua'
alias Doc='$EDITOR $DOT/nvim-config/docs/JARDOC.md'
alias Ewt='$EDITOR ~/dev/github/working-times/data/working_times.csv'
alias Init='$EDITOR ~/.config/nvim/init.lua'
alias Key='$EDITOR ~/.config/nvim/lua/init/keymap.lua'
alias Lsp='$EDITOR ~/engine-room/dotfiles/nvim-config/lua/init/lsp.lua'
alias Plug='$EDITOR ~/.config/nvim/lua/plugins'
alias Zsh='$EDITOR -c"tcd $DOT/zsh" $DOT/zsh'

# tools:
alias cov='coverage run; coverage report'
alias ff='(firefox &> /dev/null & disown &> /dev/null)'
alias fonts='kitty +list-fonts'
alias grep='grep --color --exclude-dir={.git,.mypy_cache,.pytest_cache,.ruff_cache,.venv,__pycache__,node_modules}'
alias icat='kitty +kitten icat --align left --background=white'
alias mmdc='docker run --rm -u `id -u`:`id -g` -v /opt/bind:/data minlag/mermaid-cli' # mermaid-cli with docker
alias prettifyhtml='prettier --parser html --tab-width 2 --print-width 79 --single-attribute-per-line'
alias prettifyjinja='prettier --parser jinja-template --tab-width 2 --print-width 79 --single-attribute-per-line --plugin "$NVM_BIN/../lib/node_modules/prettier-plugin-jinja-template/lib/index.js"'
alias prettifyall='prettier --parser jinja-template --tab-width 2 --print-width 79 --single-attribute-per-line --plugin "$NVM_BIN/../lib/node_modules/prettier-plugin-tailwindcss/dist/index.mjs" --plugin "$NVM_BIN/../lib/node_modules/prettier-plugin-jinja-template/lib/index.js"'
alias prettifytailwind='prettier --parser html --tab-width 2 --print-width 79 --single-attribute-per-line --plugin "$$NVM_BIN/../lib/node_modules/prettier-plugin-tailwindcss/dist/index.mjs"'
alias pygrep='grep --include="*.py"'
alias rpdb='nc localhost 4444'
alias termcolors='for i in {0..255}; do print -Pn "%K{$i}  %k%F{$i}${(l:3::0:)i}%f " ${${(M)$((i%6)):#3}:+"\n"}; done'
alias tree='tree -C'
alias vi='$EDITOR'
alias via='[[ -d .git ]] && $EDITOR -c"G" -c"TabooRename Git" -c"tabnew" -c"TabooRename TEMPLATE" -c"Oil /home/nerd/dev/dbgitlab/cookiecutter-agent-spec-template/{{cookiecutter.project_directory_name}}" -c"tabnew" -c"tabmove-2" -c"TabooRename dev" -c"lua vim.g.opencode(true)" -c"file term://opencode"|| $EDITOR -c"lua vim.g.opencode(true)" -c"TabooRename dev"'
alias vib="vi -c'AIC /b'"
alias vic="$EDITOR -c'terminal claude' -c'startinsert'"
alias vid='$EDITOR -c"TabooRename dev" -c"tabe +G" -c"TabooRename Git" -c"2tabnew" -c"TabooRename opencode" -c"lua vim.g.opencode(true)" -c"normal 1tabnext" -c"stopinsert" -c"file term://opencode" -c"1tabnext"'
alias vig='$EDITOR -c"G"'
alias vil='$EDITOR -c"Gclog"'
alias vio='$EDITOR -c"Oil"'
alias vis='([[ -f Session.vim ]] && $EDITOR -S) || $EDITOR'
alias vit='$EDITOR -c"lua vim.g.terminal()"'
alias xmlgrep='grep --include="*.xml"'

# git:
alias add='git add'
alias branch='git branch'
alias checkout='git checkout'
alias commit='git commit'
alias fetch='git fetch'
alias gitdiff='git difftool --no-symlinks'
alias gitdiffdir='git difftool --no-symlinks --dir-diff'
alias gitreset='git checkout -- .; git reset --hard HEAD; git clean -d --force'
alias gudbgl='git config user.name "Jamil RAICHOUNI"; git config user.email jamil.raichouni@deutschebahn.com'
alias gugh='git config user.name "Jamil RAICHOUNI"; git config user.email jamilraichouni@users.noreply.github.com'
alias gugl='git config user.name "Jamil RAICHOUNI"; git config user.email 3147782-jamilraichouni@users.noreply.gitlab.com'
alias merge='git merge'
alias pull='git pull'
alias push='git push'
alias st='git status'
alias stash='git stash'
alias switch='git switch'
alias up='git add .; git commit -m "WIP"; git push'

# misc:
alias nvimversions='dnf list --showduplicates neovim'
alias source-file='source_file'

# if uname == Darwin, add macOS specific aliases
if [[ "$(uname -o)" == *"Darwin"* ]]; then
  alias kittyupdate='curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin dest=/Users/jamilraichouni/Applications'
fi
