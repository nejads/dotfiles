export EDITOR='vim'

####################
# Path
####################
# Local binaries (pip, etc.)
export PATH="$HOME/.local/bin:$PATH"

# Standard paths
export PATH="/usr/local/bin:$PATH"
export PATH="/usr/local/sbin:$PATH"
export PATH="/usr/bin:$PATH"
export PATH="/usr/sbin:$PATH"
export PATH="/bin:$PATH"
export PATH="/sbin:$PATH"

# Snap
export PATH="/snap/bin:$PATH"

# Java (default to 21)
export JAVA_HOME="/usr/lib/jvm/java-21-amazon-corretto"
export PATH="$JAVA_HOME/bin:$PATH"

# Volvo certs
export NODE_EXTRA_CA_CERTS=~/workspace/vgcs/other/common-certs/volvo_certs.crt
export AWS_CA_BUNDLE=~/.aws/aws-cert.pem
