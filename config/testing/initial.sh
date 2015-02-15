#!/bin/bash
###
#
#	this is the initial install and update script
#

#define global variables
MAIN_PATH=`pwd`
LOG_PATH=$MAIN_PATH/logs
UB_PATH=/usr/bin
INST="apt-get install -y"

if [ -f $MAIN_PATH/dev ]; then
    continue
else
    for d in 'dbfiles dev logs notes samples signatures sandbox'; do
        mkdir -p $MAIN_PATH/$d
        if [ -f $MAIN_PATH/config/toolbox/README ]; then
            mv $MAIN_PATH/config/toolbox/ $MAIN_PATH/toolbox
        fi
    done
fi

exec > >(tee -a $LOG_PATH/install.log)
exec 2> >(tee -a $LOG_PATH/install-errors.log)


# setup the vagrant directory
initial_setup() {
    echo Initializing setup. . .
    echo Installation was ran on `date` >> $LOG_PATH/install-errors.log
    echo Installation was ran on `date` >> $LOG_PATH/install.log
    apt-get update
    apt-get -y upgrade
    $INST git libtool automake unzip
    echo ——————————————————————————————————————————————— >> $LOG_PATH/install.log
    echo   >> $LOG_PATH/install.log
    echo Initial setup complete. . . lots more to go!
}


# Install python
install_python() {
    echo Installing python packages. . .
    $INST python3-all-dev build-essential libffi-dev python-dev libfuzzy-dev python-pip python-magic python-pefile
    echo ——————————————————————————————————————————————— >> $LOG_PATH/install.log
    echo   >> $LOG_PATH/install.log
    echo Python packages installation complete.
}


initial_setup
install_python
