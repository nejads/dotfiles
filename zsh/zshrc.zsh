export ZSH=~/.oh-my-zsh

# Path to your dotfiles.
export DOTFILES=$HOME/dotfiles

ZSH_THEME="robbyrussell"

ZSH_CUSTOM=$DOTFILES

plugins=(git jsontools aws fzf ssh-agent zsh-completions)

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

#Java default version
export JAVA_HOME=$(/usr/libexec/java_home -v 11);
echo " * You are using Java version: $(java --version | grep '^openjdk')"

#AWS default region
export AWS_REGION=eu-west-1
echo " * Your AWS region is set to $(echo $AWS_REGION)"

# Disable the use of a pager
export AWS_PAGER=""

# nvm config
export NVM_DIR=~/.nvm
source $(brew --prefix nvm)/nvm.sh
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
alias tf="terraform"
alias sed=gsed

# Pipe public key to my clipboard.
alias copyssh="more ~/.ssh/id_rsa.pub | pbcopy | echo '=> Public key copied to pasteboard.'"

# Directories
alias dotfiles="cd $DOTFILES"
alias library="cd $HOME/Library"
alias workspace="cd ~/workspace"
alias w="cd ~/workspace"
alias sc="less $DOTFILES/shortcuts.md"
alias be="cd /Users/sorosh/workspace/vgcs/build-engineering"

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
alias dstop="docker stop $(docker ps -a -q)"
alias dpurgecontainers="dstop && docker rm $(docker ps -a -q)"
alias dpurgeimages="docker image prune -f"
dbuild() { docker build -t=$1 .; }
dbash() { docker exec -it $(docker ps -aqf "name=$1") bash; }

# Git
# Gerrit workflows
# On first push: gcommit + gpfr
# On fixing broken pipe or code review: gresolve (with empty line of message)+ gpfr
alias gcommit="git add . && git commit -m"
alias gresolve="git add . && git commit --amend"
alias ga='git add'
alias gaa='git add .'
alias gb="git branch"
alias gba='git branch -a'
alias gd='git diff'
alias gl='git pull'
alias glog="git log --oneline --decorate --color --graph"
alias gnuke="git clean -df && git reset --hard"
#alias gp='git push'
alias gpa="find . -type d -depth 1 -exec git --git-dir={}/.git --work-tree=$PWD/{}ull origin master \;"
alias gplrq="gh pr create --fill"
alias gprev="git checkout -"
alias gs='git status'
function gitPush() {
  git pull --rebase
  if [[ $? == 0 ]]; then
    git push origin HEAD:refs/for/master
  fi
}
function gpfr() {
    #slack_hook_url="https://hooks.slack.com/"
    git pull --rebase
    if [[ $? == 0 ]]; then
      BRANCH="$(git rev-parse --abbrev-ref HEAD)"
      if [ "$BRANCH" = "master" ]; then
          git push origin HEAD:refs/for/master
          #url=$(git push origin HEAD:refs/for/master --progress 2>&1 | grep -Eo 'https://[^ >]+'\ | head -1)
          #echo $url
          #curl -X POST -H 'Content-type: application/json' --data '{"text":"'"$url"'"}' $slack_hook_url
      else
          git push origin HEAD:refs/for/main
          #url=$(git push origin HEAD:refs/for/main --progress 2>&1 | grep -Eo 'https://[^ >]+'\ | head -1)
          #echo $url
          #curl -X POST -H 'Content-type: application/json' --data '{"text":"'"Sorosh: Please review $url"'"}' $slack_hook_url
      fi
    fi
}

function grevert() {
    if [ -z "$1" ]; then
    echo "Please provide hash of commit currently running in prod"
  else
    COMMIT_BEFORE_REVERT=$(git rev-parse HEAD)
    OLD_COMMIT=$1
    git reset --hard "$OLD_COMMIT"
    git reset --soft "$COMMIT_BEFORE_REVERT"
    git commit -m "Revert to commit: $OLD_COMMIT"
    echo "The repo has reverted to commit: $OLD_COMMIT"
  fi
}
# Remove local branches that does not have remote any longer.
alias gbpurge="git fetch -p && git branch -vv | awk '/: gone]/{print $1}' | xargs -n 1 git branch -d"

# AWS VALT
alias aw="aws-vault"
alias awe="aw exec"

# clear session of AWS
function awc() {
  unset AWS_VAULT
  aw clear
}

# setup profile for AWS toolkit in IntelliJ
function aws_temp_profile() {
  # Check if environment variables are set
  if [[ -z "${AWS_ACCESS_KEY_ID}" || -z "${AWS_SECRET_ACCESS_KEY}" || -z "${AWS_SESSION_TOKEN}" ]]; then
    echo "Please set the AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, and AWS_SESSION_TOKEN environment variables."
    return 1
  fi

  # Remove existing AWS config block
  sed -i '' '/^\[profile temp\]/,+3d' ~/.aws/config

  # Append AWS config block to ~/.aws/config
  echo "[profile temp]" >> ~/.aws/config
  echo "aws_access_key_id = ${AWS_ACCESS_KEY_ID}" >> ~/.aws/config
  echo "aws_secret_access_key = ${AWS_SECRET_ACCESS_KEY}" >> ~/.aws/config
  echo "aws_session_token = ${AWS_SESSION_TOKEN}" >> ~/.aws/config

  echo "AWS config has been updated."
}

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

# SSH
function personal-git() {
    ssh-add -D
    ssh-add ~/.ssh/personal-on-mac
    echo "You are using your PERSONAL ssh key"
}

function work-git() {
    ssh-add -D
    ssh-add ~/.ssh/work-on-mac
    echo "You are using your WORK key"
}

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

function lolbanner {
  figlet -c -f ~/.local/share/fonts/figlet-fonts/3d.flf $@ | lolcat
}

function unblockads() {
  sudo cp /etc/hosts.default /etc/hosts
}

function blockads() {
  sudo cp /etc/hosts.block /etc/hosts
}

function json2yaml() {
  cat $1 | yq e -P -
}

function yaml2json() {
  yq e -j $1
}

# Set Spaceship ZSH as a prompt
autoload -U promptinit; promptinit
prompt spaceship

function overstart {
  configbestbeforeseconds=120
  configendpoints=https://1obxl8dgf7.execute-api.eu-west-1.amazonaws.com/deprod/config/
  configrolearns=arn:aws:iam::488300216743:role/CentralConfigGet
  java -DZONE=de -Dhttp.nonProxyHosts="*.aws.vgthosting.net" -Dconfigendpoints=https://1obxl8dgf7.execute-api.eu-west-1.amazonaws.com/deprod/config/ -Dconfigrolearns=arn:aws:iam::488300216743:role/CentralConfigGet -DVGTZONE=de -DVGTSOLUTION=de -DVGTENVIRONMENT=prod -Xms64m -Xmx512m -DVGTCOMPSHORTNAME=overseer -DVGTSITE=eu-west-1 -DVGTLOGDIR=web/config/logs/overseer -Dlog4j.configurationFile=web/config/log4j2.xml -Dhttp.proxyHost=httppxgot-gssd.srv.volvo.com -Dhttp.proxyPort=8080 -Dhttps.proxyHost=httppxgot-gssd.srv.volvo.com -Dhttps.proxyPort=8080 -Djavax.net.ssl.trustStore=changeit -jar /Users/sorosh/workspace/vgcs/build-engineering/overseer/web/target/overseer-web-0-SNAPSHOT.jar
}
# BEGIN ESSH MANAGED BLOCK #
# Everything between these BEGIN and END markers will be replaced by essh on update

export ESSH_GIT_PATH="/Users/sorosh/workspace/vgcs/hybrid-infra/aws-ssh-tools"
if $(uname -r | grep -q WSL2 ) ; then
  export DISPLAY=192.168.67.2:0.0
else
  export DISPLAY=:0.0
fi
function essh() {
  python3 /Users/sorosh/.ssh/essh.py "$@" && \
  /Users/sorosh/.ssh/launchssh.sh /tmp/essh-result;
}
function messh() {
  python3 /Users/sorosh/.ssh/essh.py "--eic" "--mssh" "$@" && \
  /Users/sorosh/.ssh/essh/eic/launchmessh.sh /tmp/essh-result;
}

# Everything between these BEGIN and END markers will be replaced by essh on update
# END ESSH MANAGED BLOCK #
# BEGIN ESSH MANAGED BLOCK #
# Everything between these BEGIN and END markers will be replaced by essh on update

export ESSH_GIT_PATH="/Users/sorosh/workspace/vgcs/hybrid-infra/aws-ssh-tools"
if $(uname -r | grep -q WSL2 ) ; then
  export DISPLAY=192.168.67.2:0.0
else
  export DISPLAY=:0.0
fi
function essh() {
  python3 /Users/sorosh/.ssh/essh.py "$@" && \
  /Users/sorosh/.ssh/launchssh.sh /tmp/essh-result;
}
function messh() {
  python3 /Users/sorosh/.ssh/essh.py "--eic" "--mssh" "$@" && \
  /Users/sorosh/.ssh/essh/eic/launchmessh.sh /tmp/essh-result;
}

# Everything between these BEGIN and END markers will be replaced by essh on update
# END ESSH MANAGED BLOCK #
# BEGIN ESSH MANAGED BLOCK #
# Everything between these BEGIN and END markers will be replaced by essh on update

export ESSH_GIT_PATH="/Users/sorosh/workspace/vgcs/hybrid-infra/aws-ssh-tools"
if $(uname -r | grep -q WSL2 ) ; then
  export DISPLAY=192.168.67.2:0.0
else
  export DISPLAY=:0.0
fi
function essh() {
  python3 /Users/sorosh/.ssh/essh.py "$@" && \
  /Users/sorosh/.ssh/launchssh.sh /tmp/essh-result;
}
function messh() {
  python3 /Users/sorosh/.ssh/essh.py "--eic" "--mssh" "$@" && \
  /Users/sorosh/.ssh/essh/eic/launchmessh.sh /tmp/essh-result;
}

# Everything between these BEGIN and END markers will be replaced by essh on update
# END ESSH MANAGED BLOCK #
# BEGIN ESSH MANAGED BLOCK #
# Everything between these BEGIN and END markers will be replaced by essh on update

export ESSH_GIT_PATH="/Users/sorosh/.ssh/essh_tmp"
if $(uname -r | grep -q WSL2 ) ; then
  export DISPLAY=192.168.67.2:0.0
else
  export DISPLAY=:0.0
fi
function essh() {
  python3 /Users/sorosh/.ssh/essh.py "$@" && \
  /Users/sorosh/.ssh/launchssh.sh /tmp/essh-result;
}
function messh() {
  python3 /Users/sorosh/.ssh/essh.py "--eic" "--mssh" "$@" && \
  /Users/sorosh/.ssh/essh/eic/launchmessh.sh /tmp/essh-result;
}

# Everything between these BEGIN and END markers will be replaced by essh on update
# END ESSH MANAGED BLOCK #
# BEGIN ESSH MANAGED BLOCK #
# Everything between these BEGIN and END markers will be replaced by essh on update

export ESSH_GIT_PATH="/Users/sorosh/.ssh/essh_tmp"
if $(uname -r | grep -q WSL2 ) ; then
  export DISPLAY=192.168.67.2:0.0
else
  export DISPLAY=:0.0
fi
function essh() {
  python3 /Users/sorosh/.ssh/essh.py "$@" && \
  /Users/sorosh/.ssh/launchssh.sh /tmp/essh-result;
}
function messh() {
  python3 /Users/sorosh/.ssh/essh.py "--eic" "--mssh" "$@" && \
  /Users/sorosh/.ssh/essh/eic/launchmessh.sh /tmp/essh-result;
}

# Everything between these BEGIN and END markers will be replaced by essh on update
# END ESSH MANAGED BLOCK #

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/local/bin/terraform terraform
# BEGIN ESSH MANAGED BLOCK #
# Everything between these BEGIN and END markers will be replaced by essh on update

export ESSH_GIT_PATH="/Users/sorosh/.ssh/essh_tmp"
if $(uname -r | grep -q WSL2 ) ; then
  export DISPLAY=192.168.67.2:0.0
else
  export DISPLAY=:0.0
fi
function essh() {
  python3 /Users/sorosh/.ssh/essh.py "$@" && \
  /Users/sorosh/.ssh/launchssh.sh /tmp/essh-result;
}
function messh() {
  python3 /Users/sorosh/.ssh/essh.py "--eic" "--mssh" "$@" && \
  /Users/sorosh/.ssh/essh/eic/launchmessh.sh /tmp/essh-result;
}

# Everything between these BEGIN and END markers will be replaced by essh on update
# END ESSH MANAGED BLOCK #
# BEGIN ESSH MANAGED BLOCK #
# Everything between these BEGIN and END markers will be replaced by essh on update

export ESSH_GIT_PATH="/Users/sorosh/.ssh/essh_tmp"
if $(uname -r | grep -q WSL2 ) ; then
  export DISPLAY=192.168.67.2:0.0
else
  export DISPLAY=:0.0
fi
function essh() {
  python3 /Users/sorosh/.ssh/essh.py "$@" && \
  /Users/sorosh/.ssh/launchssh.sh /tmp/essh-result;
}
function messh() {
  python3 /Users/sorosh/.ssh/essh.py "--eic" "--mssh" "$@" && \
  /Users/sorosh/.ssh/essh/eic/launchmessh.sh /tmp/essh-result;
}

# Everything between these BEGIN and END markers will be replaced by essh on update
# END ESSH MANAGED BLOCK #
