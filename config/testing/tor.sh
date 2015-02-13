#!/bin/bash
###
#
#
#       this script installs tor
#
#

#define global variables
MAIN_PATH=`pwd`
LOG_PATH=$MAIN_PATH/logs
UB_PATH=/usr/bin
INST="apt-get install -y"

exec > >(tee -a $LOG_PATH/install.log)
exec 2> >(tee -a $LOG_PATH/install-errors.log)

# Install Tor
install_tor() {
    if [ -f /usr/bin/tor ]; then
        echo Tor is already installed
    else
        echo Installing Tor. . .
        chmod 666 /etc/apt/sources.list
        echo deb http://deb.torproject.org/torproject.org trusty main >> /etc/apt/sources.list
        chmod 644 /etc/apt/sources.list
        echo added deb http://deb.torproject.org/torproject.org trusty main to source.list

        apt-key list | grep -q "deb.torproject.org archive signing key";
        if [ $? -ne 0 ]; then
            gpg --keyserver hkp://keys.gnupg.net:80 --recv 886DDD89
            if [ $? -ne 0 ]; then
                gpg --keyserver keys.gnupg.net --recv 886DDD89
                if [ $? -ne 0 ]; then
                    gpg --keyserver pool.sks-keyservers.net --recv 886dDD89
                fi
            fi
        fi

        apt-key list | grep -q "deb.torproject.org archive signing key";
        if [ $? == 0 ]; then
            gpg --export A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89 | sudo apt-key add -
            apt-get updatesu
            apt-get install deb.torproject.org-keyring
            apt-get install -y tor

            echo ——————————————————————————————————————————————— >> $LOG_PATH/install.log
            echo   >> $LOG_PATH/install.log
            echo Tor installation complete.
        else
            echo Tor is unable to install, see: https://www.torproject.org/docs/debian
        fi
    fi
}

install_tor
