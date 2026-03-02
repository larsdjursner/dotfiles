export PATH=$PATH:$HOME/bin:$HOME/scripts

# Java (JDK 21)
export JAVA_HOME=$(/usr/libexec/java_home -v 21)
export PATH="$JAVA_HOME/bin:$PATH"

# Go
export PATH=$PATH:$(go env GOPATH)/bin