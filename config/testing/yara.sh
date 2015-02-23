#!/bin/bash
###
#
#		this script installs yara and yara-python
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
    if [ -f /usr/local/bin/yara ]; then
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
}

#Installing yara-python
install_yara_python(){
    if [ -f /usr/local/lib/python2.7/dist-packages/yara_python-3.3.0.egg-info ]; then
        echo yara-python already installed
    else
        if [ -f $MAIN_PATH/dev/yara/yara-python/setup.py ]; then
            echo installing yara-python
            cd $MAIN_PATH/dev/yara/yara-python/
            python setup.py build
            python setup.py install
        else
            pip install yara-python
        fi
        if [ -f /usr/local/lib/python2.7/dist-packages/yara_python-3.3.0.egg-info ]; then
            echo yara-python is already installed
        else
            cd $MAIN_PATH/dev/yara/
            rm -rf yara-python
            pip install yara-python
            ls /usr/local/lib/python2.7/dist-packages/yara_python-3.3.0.egg-info;
            if [ $? -ne 0 ]; then
                echo -e "yara-python failed to install. manually try installing it.\nfollow instructions at http://yara.readthedocs.org/en/v3.3.0/gettingstarted.html\n -or- remove the yara-python dir and $ sudo pip install yara-python"
            fi
        fi
    fi

    cat /etc/ld.so.conf | grep -q "/usr/local/lib"
    if [ $? -ne 0 ]; then
        echo "/usr/local/lib/" | sudo tee -a /etc/ld.so.conf
        ldconfig
    fi
}

install_yara
install_yara_python