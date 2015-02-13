#!/bin/bash
###
#
#	this script installs nmap
#

#define global variables
MAIN_PATH=`pwd`
LOG_PATH=$MAIN_PATH/logs
UB_PATH=/usr/bin
INST="apt-get install -y"

exec > >(tee -a $LOG_PATH/install.log)
exec 2> >(tee -a $LOG_PATH/install-errors.log)

# Installing nmap, proxychains can use nmap
install_nmap() {
    if [ -f $UB_PATH/nmap ]; then
        echo nmap is already installed.
    else
        echo Installing nmap. . .
        $INST nmap
        echo ——————————————————————————————————————————————— >> $LOG_PATH/install.log
        echo   >> $LOG_PATH/install.log
        echo nmap installation complete
fi
}

install_nmap
