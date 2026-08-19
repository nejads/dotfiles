export ZSH=~/.oh-my-zsh

# Path to your dotfiles.
export DOTFILES=$HOME/dotfiles

ZSH_THEME="spaceship"

plugins=(aws docker fzf git github jsontools node npm python ssh-agent)
fpath+=${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions/src

source $ZSH/oh-my-zsh.sh
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Make it possible to autocomplete cd .. to cd ../
zstyle ':completion:*' special-dirs true

# language environment
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

#AWS default region
export AWS_REGION=eu-west-1

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion"

# Disable the use of a pager
export AWS_PAGER=""

#############################
# aliases
#############################
# Shortcuts
alias c="clear"
alias reload="source $HOME/.zshrc"
alias ll="ls -ahlF --color --group-directories-first"
alias shrug="echo '¯\_(ツ)_/¯' | xclip -selection clipboard"
alias bat="batcat"

# Pipe public key to clipboard
alias copyssh="cat ~/.ssh/id_rsa.pub | xclip -selection clipboard && echo '=> Public key copied to clipboard.'"

# Directories
alias dotfiles="cd $DOTFILES"
alias workspace="cd ~/workspace"
alias w="cd ~/workspace"
alias sc="less $DOTFILES/shortcuts.md"
alias be="cd ~/workspace/vgcs/build-engineering"

# Maven
alias mci='mvn clean install'

# Java aliases
alias java_versions='update-java-alternatives --list'
jdk() {
  if [ -z "$1" ]; then
    java -version
  else
    version=$1
    export JAVA_HOME="/usr/lib/jvm/java-${version}-amazon-corretto"
    export PATH="$JAVA_HOME/bin:$PATH"
    java -version
  fi
}

# JS
alias nfresh="rm -rf node_modules/ package-lock.json && npm install"
alias watch="npm run watch"

# Docker
dbuild() { docker build -t=$1 .; }
dbash() { docker exec -it $(docker ps -aqf "name=$1") bash; }

# Git
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
alias gpa="find . -type d -depth 1 -exec git --git-dir={}/.git --work-tree=$PWD/{}ull origin master \;"
alias gplrq="gh pr create --fill"
alias gprev="git checkout -"
alias gs='git status'

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

# Remove local branches that does not have remote any longer.
alias gbpurge="git fetch -p && git branch -vv | grep ': gone]' | awk '{print \$1}' | xargs git branch -D"

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
    gob
    gbpurge
    echo "Merged pull request ID: $1"
  fi
}

# trigger build for current path
function trigger() {
  TRIGGER_URL="https://CHANGE_IT/api/initializer/trigger"
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
    return 1
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

# Python
alias python=python3

# Functions
function weather() { curl -4 wttr.in/${1:-gothenburg} }

function myip() {
    echo 'Your local ip: '
    hostname -I | awk '{print $1}'
    echo "Your public ip: "
    curl -s ipinfo.io
}

function json2yaml() {
  cat $1 | yq e -P -
}

function yaml2json() {
  yq e -j $1
}

# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"
