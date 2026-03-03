export PATH=$PATH:$HOME/bin:$HOME/scripts

# Java (JDK 21)
export JAVA_HOME=$(/usr/libexec/java_home -v 21)
export PATH="$JAVA_HOME/bin:$PATH"

# Go
export PATH=$PATH:$(go env GOPATH)/bin

# VS Code
export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"

# Google Antigravity
export PATH="$PATH:/Applications/Antigravity.app/Contents/Resources/app/bin"