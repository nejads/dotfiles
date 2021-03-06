export ZSH=~/.oh-my-zsh

# Path to your dotfiles.
export DOTFILES=$HOME/dotfiles

ZSH_THEME="robbyrussell"

ZSH_CUSTOM=$DOTFILES

plugins=(git jsontools aws)

source $ZSH/oh-my-zsh.sh

# Make it possible to autocomplete cd .. to cd ../
zstyle ':completion:*' special-dirs true

# language environment
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Enale cmd+back to delete a row
bindkey "^X\\x7f" backward-kill-line

#Aws vault
export AWS_VAULT_KEYCHAIN_NAME=login
export AWS_VAULT_BACKEND=keychain

#############################
# aliases
#############################
# Shortcuts
alias c="clear"
alias reload="source $HOME/.zshrc"
alias reloaddns="dscacheutil -flushcache && sudo killall -HUP mDNSResponder"
alias ll="/usr/local/opt/coreutils/libexec/gnubin/ls -ahlF --color --group-directories-first"
alias lock='/System/Library/CoreServices/"Menu Extras"/User.menu/Contents/Resources/CGSession -suspend'
alias shrug="echo '¯\_(ツ)_/¯' | pbcopy"
# alias turtle_wallet='cd /Users/soroush/Coin/turtlecoin/build/src && ./zedwallet --wallet-file MyTurtleWallet.wallet --remote-daemon 192.168.1.100:11898'
alias totp="sh ~/dotfiles/scripts/totp.sh"
alias totp-add-token="sh ~/dotfiles/scripts/totp-add-token.sh"
alias zbundle="antibody bundle < $DOTFILES/zsh_plugins.txt > $DOTFILES/zsh_plugins.sh"

# Pipe public key to my clipboard.
alias copyssh="more ~/.ssh/id_rsa.pub | pbcopy | echo '=> Public key copied to pasteboard.'"

# Directories
alias dotfiles="cd $DOTFILES"
alias library="cd $HOME/Library"
alias workspace="cd ~/workspace"
alias w="cd ~/workspace"
alias sc="less $DOTFILES/shortcuts.md"

# Postgres
alias pstart='pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start'
alias pstop='pg_ctl -D /usr/local/var/postgres stop -s -m fast'
alias pcheck="egrep 'listen|port' /usr/local/var/postgres/postgresql.conf"

# Maven
alias mci='mvn clean install'

# Java aliases
alias java_versions='/usr/libexec/java_home -V'
alias 8='jdk 1.8'
jdk() {
    if [ -z "$1" ]; then
      java -version
    else
      version=$1
      unset JAVA_HOME;
      export JAVA_HOME=$(/usr/libexec/java_home -v"$version");
      java -version
    fi
}

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

# AWS
alias kits="unset AWS_VAULT && export AWS_PROFILE=kits"

# Git
alias commit="git add . && git commit -m"
alias ga='git add'
alias gaa='git add .'
alias gb="git branch"
alias gba='git branch -a'
alias gd='git diff'
alias gl='git pull'
alias glog="git log --oneline --decorate --color --graph"
alias gnuke="git clean -df && git reset --hard"
alias gp='git push'
alias gpa="find . -type d -depth 1 -exec git --git-dir={}/.git --work-tree=$PWD/{}ull origin master \;"
alias gplrq="gh pr create --fill"
alias gprev="git checkout -"
alias gs='git status'
alias resolve="git add . && git commit --no-edit"
alias wip="commit wip"

# Remove local branches that does not have remote any longer.
alias gbpurge="git fetch -p && git branch -vv | awk '/: gone]/{print $1}' | xargs -n 1 git branch -d"

# useful for daily stand-up
function git-standup() {
    AUTHOR=${AUTHOR:="`git config user.name`"}

    since=yesterday
    if [[ $(date +%u) == 1 ]] ; then
        since="2 days ago"
    fi

    git log --all --since "$since" --oneline --author="$AUTHOR"
}

function gm() {
  if [ -z "$1" ]; then
    git checkout master
  else
    git checkout $1
  fi
}

function gi() { curl -L -s https://www.gitignore.io/api/$@ ;}

# Python
alias python=/usr/local/bin/python3
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

  # Set Spaceship ZSH as a prompt
  autoload -U promptinit; promptinit
  prompt spaceship
