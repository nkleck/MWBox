#!/bin/bash
###
#
#		this script installs yara
#


#define global variables
MAIN_PATH=`pwd`
LOG_PATH=$MAIN_PATH/logs
UB_PATH=/usr/bin
INST="apt-get install -y"

exec > >(tee -a $LOG_PATH/install.log)
exec 2> >(tee -a $LOG_PATH/install-errors.log)

# Installing Yara
install_yara() {
    if [ -f $UB_PATH/yara ]; then
        echo yara is already installed
    else
        echo Installing yara. . .
        cd $MAIN_PATH/dev/
        git clone https://github.com/plusvic/yara.git yara
        cd yara
        ./bootstrap.sh
        ./configure
        make
        make install
        cd $MAIN_PATH/dev/yara/yara-python/
        python setup.py build
        python setup.py install
        cd
        echo ——————————————————————————————————————————————— >> $LOG_PATH/install.log
        echo   >> $LOG_PATH/install.log
        echo yara installation complete
    fi
}

install_yara
