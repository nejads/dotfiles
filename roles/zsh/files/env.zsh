export EDITOR='vim'

####################
# Path
####################
export PATH="/bin:$PATH"
export PATH="/sbin:$PATH"
export PATH="/usr/bin:$PATH"
export PATH="/usr/sbin:$PATH"

# brew symlinks most executables it installs
export PATH="/opt/homebrew/bin:$PATH"
export PATH="/usr/local/bin:$PATH"

# brew symlinks some of its executables
export PATH="/usr/local/sbin:$PATH"

# the symlinked brew Ruby executable
export PATH="/opt/homebrew/opt/ruby/bin:$PATH"

# ruby gems
export PATH="~/.gem/ruby/2.7.0/bin:$PATH"

# node global packages
export PATH="/usr/local/lib/node_modules/bin/:$PATH"

# GNU coreutils
export PATH="/opt/homebrew/opt/coreutils/libexec/gnubin:${PATH}"
export MANPATH="/opt/homebrew/opt/coreutils/libexec/gnuman:${MANPATH}"

# Sonarqube Scanner
export PATH="~/sonar-scanner/bin/:$PATH"

# Sonic
PYTHON_LOCAL_BIN=${HOME}/.local/bin
export PATH=${PYTHON_LOCAL_BIN}:${PATH}

# Java
export JAVA_8_HOME=$(/usr/libexec/java_home -v1.8)
export JAVA_11_HOME=$(/usr/libexec/java_home -v11)
export JAVA_15_HOME=$(/usr/libexec/java_home -v15)

# homebrew
export HOMEBREW_CASK_OPTS="--no-quarantine"
export HOMEBREW_NO_ANALYTICS=true
export HOMEBREW_NO_AUTO_UPDATE=true
export HOMEBREW_NO_INSTALL_CLEANUP=true
export HOMEBREW_NO_INSTALLED_DEPENDENTS_CHECK=true

# Volvo certs
export NODE_EXTRA_CA_CERTS=~/workspace/vgcs/other/common-certs/volvo_certs.crt
#export AWS_CA_BUNDLE=~/workspace/vgcs/other/common-certs/volvo_certs.crt
export AWS_CA_BUNDLE=~/.aws/aws-cert.pem
