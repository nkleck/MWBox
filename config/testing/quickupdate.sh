#!/bin/bash
#
#	just the initial stuff

#define global variables
MAIN_PATH=`pwd`
LOG_PATH=$MAIN_PATH/logs
UB_PATH=/usr/bin
INST="apt-get install -y"

# setup the vagrant directory
initial_setup() {

    apt-get update
    apt-get -y upgrade
    $INST git libtool automake unzip subversion

}


# Install python
install_python() {

    $INST python3-all-dev build-essential libffi-dev python-dev libfuzzy-dev python-pip python-magic python-pefile python-lxml
}

#install wine
install_wine() {
    if [ -f /usr/bin/wine ]; then
        echo wine is already installed
    else
        dpkg --add-architecture i386
        apt-get update
        $INST wine1.6
    fi
}


#shorten the working path, long paths are annoying
cd /home/vagrant/
cat .bashrc | fgrep -q "PS1='\[\033[01;32m\]\u\[\033[00m\]:\[\033[01;34m\]\W\[\033[00m\]$ '"
    if [ $? -ne 0 ]; then
        echo "PS1='\[\033[01;32m\]\u\[\033[00m\]:\[\033[01;34m\]\W\[\033[00m\]$ '" >> .bashrc
        echo "PS1='\u:\W$ '" >> .bashrc
    fi

initial_setup
install_python
install_wine