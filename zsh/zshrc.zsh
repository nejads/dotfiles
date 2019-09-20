export ZSH=/Users/soroush/.oh-my-zsh

# Path to your dotfiles.
export DOTFILES=$HOME/dotfiles

ZSH_THEME="robbyrussell"

ZSH_CUSTOM=$DOTFILES

plugins=(git)

source $ZSH/oh-my-zsh.sh

# Make it possible to autocomplete cd .. to cd ../
zstyle ':completion:*' special-dirs true

# language environment
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8


#############################
# aliases
#############################
# Shortcuts
alias c="clear"
alias copyssh="pbcopy < $HOME/.ssh/id_rsa.pub"
alias reload="source $HOME/.zshrc"
alias reloaddns="dscacheutil -flushcache && sudo killall -HUP mDNSResponder"
alias ll="/usr/local/opt/coreutils/libexec/gnubin/ls -ahlF --color --group-directories-first"
alias lock='/System/Library/CoreServices/"Menu Extras"/User.menu/Contents/Resources/CGSession -suspend'
alias shrug="echo '¯\_(ツ)_/¯' | pbcopy"
alias turtle_wallet='cd /Users/soroush/Coin/turtlecoin/build/src && ./zedwallet --wallet-file MyTurtleWallet.wallet --remote-daemon 192.168.1.100:11898'
alias zbundle="antibody bundle < $DOTFILES/zsh_plugins.txt > $DOTFILES/zsh_plugins.sh"

# Pipe public key to my clipboard.
alias pubkey="more ~/.ssh/id_rsa.pub | pbcopy | echo '=> Public key copied to pasteboard.'"

# Directories
alias dotfiles="cd $DOTFILES"
alias library="cd $HOME/Library"
alias www="cd ~/workspace"

# Postgres
alias pstart='pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start'
alias pstop='pg_ctl -D /usr/local/var/postgres stop -s -m fast'
alias pcheck="egrep 'listen|port' /usr/local/var/postgres/postgresql.conf"

# Maven
alias mci='mvn clean install'

# Java aliases
export JAVA_HOME=$(/usr/libexec/java_home)
alias java_versions='/usr/libexec/java_home -V'
alias 8='export JAVA_HOME=`/usr/libexec/java_home -v 1.8`'
alias 11='export JAVA_HOME=`/usr/libexec/java_home -v 11`'

# JS
alias nfresh="rm -rf node_modules/ package-lock.json && npm install"
alias watch="npm run watch"

# Vagrant
alias v="vagrant global-status"
alias vup="vagrant up"
alias vhalt="vagrant halt"
alias vssh="vagrant ssh"
alias vreload="vagrant reload"
alias vrebuild="vagrant destroy --force && vagrant up"

# Docker
#alias docker-composer="docker-compose"
#alias dstop="docker stop $(docker ps -a -q)"
#alias dpurgecontainers="dstop && docker rm $(docker ps -a -q)"
#alias dpurgeimages="docker rmi $(docker images -q)"
#dbuild() { docker build -t=$1 .; }
#dbash() { docker exec -it $(docker ps -aqf "name=$1") bash; }

# Git
alias gb="git branch"
alias gba='git branch -a'
alias gs='git status'
alias gd='git diff'
alias ga='git add'
alias gaa='git add .'
alias gl='git pull'
alias commit="git add . && git commit -m"
alias gcommit="git add . && git commit"
alias gp='git push'
alias wip="commit wip"
alias resolve="git add . && git commit --no-edit"
alias glog="git log --oneline --decorate --color"
alias gnuke="git clean -df && git reset --hard"

function go {
  if [ -z "$1" ]; then
    git checkout master
  else
    git checkout $1
  fi
}

function gi() { curl -L -s https://www.gitignore.io/api/$@ ;}

# Pip update
alias pupdate='pip freeze --local | grep -v '^\-e' | cut -d = -f 1  | xargs -n1 pip install -U'

# Functions
function weather() { curl -4 wttr.in/${1:-antwerp} }

function wordcount() {
    echo -n 'Word count:'
    pdftotext $1 - | wc -w
}

function port() {
    open http://localhost:$1
}

function site() {
    open http://$1
}

function myip() {
    echo 'Your local ip: '
    echo '{'
    echo '  "ip":"'$(ipconfig getifaddr en0)'"'
    echo '}'
    echo "Your public ip: "
    curl ipinfo.io
}