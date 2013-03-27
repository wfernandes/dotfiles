source ~/.ps1colors
source ~/.aliases
source ~/.git-completion.sh
source ~/.git-flow-completion.sh
source ~/.bash_prompt

export SONAR_RUNNER_HOME=/Applications/sonar-runner-2.0

PATH=$PATH:/usr/local/bin:/Users/mgile/bin:/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/Applications:/Applications/Xcode.app/Contents/Developer/usr/bin:/usr/local/mysql/bin:/Applications/Postgres.app/Contents/MacOS/bin:/opt/local/bin:/Applications/sonar-runner-2.0/bin
export PATH

export ARCHFLAGS="-arch x86_64"
#export DYLD_LIBRARY_PATH=/usr/local/cuda/lib:$DYLD_LIBRARY_PATH

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # This loads RVM into a shell session

export GRADLE_HOME=/usr/local/gradle
export GRAILS_HOME=/usr/local/grails
export GROOVY_HOME=/usr/local/groovy
export EDITOR=/Applications/Emacs.app/Contents/MacOS/bin/emacsclient
export JAVA_HOME=/Library/Java/Home
export TERM=xterm-256color

export JAVA_OPTS="-Xms512m -Xmx768m -XX:MaxPermSize=512m"
export MAVEN_HOME=/usr/share/maven

export DISPLAY=:0

function symb
{
/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/Library/PrivateFrameworks/DTDeviceKit.framework/Versions/A/Resources/symbolicatecrash -v $1 | more
}

##
# Your previous /Users/mgile/.bash_profile file was backed up as /Users/mgile/.bash_profile.macports-saved_2013-02-27_at_09:16:06
##

# MacPorts Installer addition on 2013-02-27_at_09:16:06: adding an appropriate PATH variable for use with MacPorts.
export PATH=/opt/local/bin:/opt/local/sbin:$PATH
# Finished adapting your PATH environment variable for use with MacPorts.

export ARCH_FLAGS="-arch x86_64"
