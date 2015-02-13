#!/bin/bash
#
#
#		this script installs  proxychains
#

#define global variables
MAIN_PATH=`pwd`
LOG_PATH=$MAIN_PATH/logs
UB_PATH=/usr/bin
INST="apt-get install -y"

exec > >(tee -a $LOG_PATH/install.log)
exec 2> >(tee -a $LOG_PATH/install-errors.log)

#Install proxychains
install_proxychains() {
    if [ -f $UB_PATH/proxychains ]; then
        echo proxychains is already installed.
    else
        echo Installing proxychains. . .
        $INST proxychains
        echo ——————————————————————————————————————————————— >> $LOG_PATH/install.log
        echo   >> $LOG_PATH/install.log
        echo proxychains installation complete
    fi
}

install_proxychains
