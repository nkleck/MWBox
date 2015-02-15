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
    fi
    if [ -f /usr/local/lib/python2.7/dist-packages/yara_python-3.3.0.egg-info ]; then
        echo yara-python already installed
    else
        cd $MAIN_PATH/dev/yara/yara-python/
        python setup.py build
        python setup.py install
        if [ -f /usr/local/lib/python2.7/dist-packages/yara_python-3.3.0.egg-info ]; then
            continue
        else
            cd $MAIN_PATH/dev/yara/
            rm -rf yara-python
            pip install yara-python
            ls /usr/local/lib/python2.7/dist-packages/yara_python-3.3.0.egg-info;
            if [ $? == 0 ]; then
                echo -e "yara-python failed to install. manually try installing it.\nfollow instructions at http://yara.readthedocs.org/en/v3.3.0/gettingstarted.html\n -or- remove the yara-python dir and $ sudo pip install yara-python"
            fi
        fi
    fi
    cd
    echo ——————————————————————————————————————————————— >> $LOG_PATH/install.log
    echo   >> $LOG_PATH/install.log
    echo yara installation complete
}

install_yara