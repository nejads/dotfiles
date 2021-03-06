export EDITOR='vim'

####################
# Path
####################
export PATH="/bin:$PATH"
export PATH="/sbin:$PATH"
export PATH="/usr/bin:$PATH"
export PATH="/usr/sbin:$PATH"

# brew symlinks most executables it installs
export PATH="/usr/local/bin:$PATH"

# brew symlinks some of its executables
export PATH="/usr/local/sbin:$PATH"

# the symlinked brew Ruby executable
export PATH="/usr/local/opt/ruby/bin:$PATH"

# ruby gems
export PATH="~/.gem/ruby/2.7.0/bin:$PATH"

# node global packages
export PATH="/usr/local/lib/node_modules/bin/:$PATH"

# Sonic
PYTHON_LOCAL_BIN=${HOME}/.local/bin
export PATH=${PYTHON_LOCAL_BIN}:${PATH}

# Java
export JAVA_8_HOME=$(/usr/libexec/java_home -v1.8)
export JAVA_11_HOME=$(/usr/libexec/java_home -v11)
export JAVA_15_HOME=$(/usr/libexec/java_home -v15)

# Rust
# export PATH="${HOME}/.cargo/bin"
