export ZSH=~/.oh-my-zsh

# Path to your dotfiles.
export DOTFILES=$HOME/dotfiles

ZSH_THEME="robbyrussell"

ZSH_CUSTOM=$DOTFILES

plugins=(aws docker fzf git github jsontools node npm python ssh-agent)
fpath+=${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions/src

source $ZSH/oh-my-zsh.sh
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

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
export JAVA_HOME=$(/usr/libexec/java_home -v 17);
#echo -e " * Java version: $(java --version | grep '^openjdk') \U2615"

#AWS default region
export AWS_REGION=eu-west-1
#echo " * AWS region: $(echo $AWS_REGION)"

#AWS default node version
source ~/.nvm/nvm.sh

# Disable the use of a pager
export AWS_PAGER=""

# nvm config
export NVM_DIR=~/.nvm
source $(brew --prefix nvm)/nvm.sh

# needed for SAM --use-container finds the docker
#ln -s "$HOME/.docker/run/docker.sock" /var/run/docker.sock
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
alias be="cd ~/workspace/vgcs/build-engineering"

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
#alias dstop="docker stop $(docker ps -a -q)"
#alias dpurgecontainers="dstop && docker rm $(docker ps -a -q)"
#alias dpurgeimages="docker image prune -f"
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
function gpfr() {
    #slack_hook_url="https://hooks.slack.com/"
    git pull --rebase
    if [[ $? == 0 ]]; then
      CURRENT_BRANCH="$(git rev-parse --abbrev-ref HEAD)"
      if [ "$CURRENT_BRANCH" = "master" ]; then
          git push origin HEAD:refs/for/master
      else
          git push origin HEAD:refs/for/main
      fi
    fi
}

function gob() {
  if [ -z "$1" ]; then
    DEFAULT_BRANCH="$(git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@')"
    git checkout $DEFAULT_BRANCH && git pull --rebase && git fetch --prune
  else
    branches=$(git branch)
    if [[ $branches =~ $1 ]]; then
      echo "Branch $1 already exists"
      git checkout $1
    else
      echo "Branch $1 does not exist, creating it"
      git pull --rebase && git checkout -b $1
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
alias gbpurge="git fetch -p && git branch -vv | grep ': gone]' | awk '{print $1}' | xargs git branch -D"

# AWS VALT
alias aw="aws-vault"
alias awe="aw exec"

# clear session of AWS
function awc() {
  unset AWS_VAULT
  aw clear
}

# AWS CLI
function aws_pr() {
  if [ -z "$1" ]; then
    echo "Please provide the message of the PR"
  else
    pull_request_id=$(aws codecommit create-pull-request \
      --title "$1" \
      --description "$1" \
      --targets repositoryName=$(basename "$PWD"),sourceReference=$(git rev-parse --abbrev-ref HEAD),destinationReference=$(git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@') \
      --query 'pullRequest.pullRequestId' \
      --output text)

    echo "Pull Request ID: $pull_request_id"
  fi
}

function aws_merge () {
  if [ -z "$1" ]; then
    echo "Please provide the pull request ID"
  else
    aws codecommit merge-pull-request-by-fast-forward \
      --pull-request-id "$1" \
      --repository-name $(basename "$PWD")
    aws codecommit delete-branch \
      --repository-name $(basename "$PWD") \
      --branch-name $(git rev-parse --abbrev-ref HEAD)
    go
    gbpurge
    echo "Merged pull request ID: $1"
  fi
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

# trigger build for current path
function trigger() {
  TRIGGER_URL="https://pipelines.sharedservices.prod.euw1.vg-cs.net/api/initializer/trigger"
  REPO_NAME=$(git remote -v | awk -F/ '/origin.*\(fetch\)/ {gsub(/ \(fetch\)/, ""); path=$(NF-2) "/" $(NF-1) "/" $NF; gsub(/^[ \t]+|[ \t]+$/, "", path); print path}')
  if [ ! -z $REPO_NAME ]; then
    curl --location $TRIGGER_URL --header 'Content-Type: application/json' --data "{\"repository\": \"$REPO_NAME\"}"
  fi
}

# EESSH
function eessh_by_id() {
  instance_id=$1
  if [ -z $instance_id ]; then
    echo "Couldnt find instance id"
  else
    echo "Connecting to instance with instance id: $instance_id"
    if [[ "$AWS_REGION" == "ap-northeast-1" ]]; then
      echo "the region is ap-northeast-1, doesnt need vpce endpoint..."
      aws ssm start-session --target $instance_id
    else
      vpce=https://vpce-0a3315ed8d354c9c3-isa9qun7.ssm.eu-west-1.vpce.amazonaws.com
      if [[ "$AWS_REGION" == "us-east-1" ]]; then
        echo "the region is us-east-1, changing the vpce to us-east-1 vpce..."
        vpce=https://vpce-05bb753ebd972227e-l8t95svv.ssm.us-east-1.vpce.amazonaws.com/
      fi
      aws ssm start-session --target $instance_id --endpoint-url $vpce
    fi
  fi
}

function eessh_by_ip() {
  ip=$1
  result=$(aws ec2 describe-instances --filters Name=private-ip-address,Values=$ip --query 'Reservations[*].Instances[*].[InstanceId]')
  instance_id=$(echo "$result" | sed -n 's/.*"\(i-[a-f0-9]\{8,17\}\)".*/\1/p')
  eessh_by_id $instance_id
}

function eessh_by_name() {
  name=$1
  flavor=$2
  if [ -z $flavor ]; then
    echo "Connecting to $name without flavor"
    result=$(aws ec2 describe-instances --filters "Name=tag:Name,Values=$name" --query 'Reservations[*].Instances[?!not_null(Tags[?Key == `Flavor`].Value)].[InstanceId]')
  else
    echo "Connecting to $name with flavor $flavor..."
    result=$(aws ec2 describe-instances --filters "Name=tag:Name,Values=$name" "Name=tag:Flavor,Values=$flavor" --query 'Reservations[*].Instances[*].[InstanceId]')
  fi
  instance_id=$(echo "$result" | sed -n 's/.*"\(i-[a-f0-9]\{8,17\}\)".*/\1/p')
  eessh_by_id $instance_id
}

function eessh() {
  if [ $# -eq 0 ] || [ $# -ge 3 ]; then
    echo "You have provided zero or more than two input parameters."
    echo "Usage:  1.eessh ip, 2.eessh instance_id, 3.eessh name <flavor>"
    exit 1
  fi
  input=$1
  flavor=$2
  id_regex='^i-[a-f0-9]{17}$'
  ip_regex='^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$'
  if [[ $input =~ $id_regex ]]; then
    echo "The input parameter is an instance id."
    eessh_by_id $input
  elif [[ $input =~ $ip_regex ]]; then
    echo "The input parameter is a valid IP address."
    eessh_by_ip $input
  else
    echo "The input is not an IP and not a Instance id. eessh it as a instance name"
    eessh_by_name $input $flavor
  fi
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

# Update and upgrade brew
function update_homebrew() {
    brew update 2>/dev/null | grep --invert-match --regexp "Already up-to-date." --regexp "Updating Homebrew..."
    brew upgrade --formulae
    brew outdated --cask --greedy --verbose | grep --invert-match latest | awk '{print $1;}' | xargs brew upgrade --cask
    brew cleanup
    brew doctor | grep --invert-match "Your system is ready to brew."
}

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

function reset_hosts() {
    sudo cp ~/dotfiles/roles/hosts/files/base_hosts /private/etc/hosts
    echo "Hosts file has been reset to default."
}

function myip() {
    echo 'Your local ip: '
    echo '{'
    echo '  "ip":"'$(ipconfig getifaddr en0)'"'
    echo '}'
    echo "Your public ip: "
    curl ipinfo.io
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
  java -DZONE=de -Dhttp.nonProxyHosts="*.aws.vgthosting.net" -Dconfigendpoints=https://1obxl8dgf7.execute-api.eu-west-1.amazonaws.com/deprod/config/ -Dconfigrolearns=arn:aws:iam::488300216743:role/CentralConfigGet -DVGTZONE=de -DVGTSOLUTION=de -DVGTENVIRONMENT=prod -Xms64m -Xmx512m -DVGTCOMPSHORTNAME=overseer -DVGTSITE=eu-west-1 -DVGTLOGDIR=web/config/logs/overseer -Dlog4j.configurationFile=web/config/log4j2.xml -Dhttp.proxyHost=httppxgot-gssd.srv.volvo.com -Dhttp.proxyPort=8080 -Dhttps.proxyHost=httppxgot-gssd.srv.volvo.com -Dhttps.proxyPort=8080 -Djavax.net.ssl.trustStore=changeit -jar ~/workspace/vgcs/build-engineering/overseer/web/target/overseer-web-0-SNAPSHOT.jar
}
export NVM_DIR=~/.nvm

# pnpm
export PNPM_HOME="/Users/sorosh/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
export NVM_DIR=/Users/sorosh/.nvm

# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"
