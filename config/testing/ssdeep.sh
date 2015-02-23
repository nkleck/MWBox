#!/bin/bash
###
#
#	this script installs ssdeep and stuff
#       requires the initial_setup and install_python scripts
#           be ran first
#
#

#define global variables
MAIN_PATH=`pwd`
LOG_PATH=$MAIN_PATH/logs
UB_PATH=/usr/bin
INST="apt-get install -y"

exec > >(tee -a $LOG_PATH/install.log)
exec 2> >(tee -a $LOG_PATH/install-errors.log)

# Install ssdeep and things
install_ssdeep() {
    if [ -f $UB_PATH/ssdeep ]; then
        echo ssdeep is already installed
    else
        echo Installing ssdeep and python-ssdeep
        aptitude install ssdeep cython
        pip install ssdeep
        cd $MAIN_PATH/dev/
        svn checkout http://pyssdeep.googlecode.com/svn/trunk/ pyssdeep-read-only
        chown -R vagrant:vagrant pyssdeep-read-only
        cd pyssdeep-read-only
        python setup.py build
        python setup.py install
        cd
        echo ——————————————————————————————————————————————— >> $LOG_PATH/install.log
        echo   >> $LOG_PATH/install.log
        echo ssdeep installation complete
    fi
}

install_ssdeep
