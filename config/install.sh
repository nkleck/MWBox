#!/bin/bash
###
#
# This script will install a number of programs into a fresh build of vagrant
# 
# RUN AS sudo
# 
# This script is tested on Linux (Ubuntu/Trusty) in a Vagrantbox
#
#
#----------------------------------------------------------------------------


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



# Install clamav and create clam signature db
install_clamav() {
    if [ -f $UB_PATH/clamscan ]; then
        echo clamav is already installed
        echo Updating clamav
        $INST clamav-freshclam
    else
        echo Installing clamav and its files. . .
        cd $MAIN_PATH/dbfiles
        mkdir clamdb
        $INST clamav clamav-freshclam clamav-testfiles
        cd $MAIN_PATH/samples/
        mkdir clamav
        mv /usr/share/clamav-testfiles $MAIN_PATH/samples/clamav
        cd
        echo ——————————————————————————————————————————————— >> $LOG_PATH/install.log
        echo   >> $LOG_PATH/install.log
        echo clamav installation and setup complete
    fi
}


# Install Tor
install_tor() {
    if [ -f $UB_PATH/tor ]; then
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
            apt-get update
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





# Install ssdeep and things
install_ssdeep() {
    if [ -f $UB_PATH/ssdeep ]; then
        echo ssdeep is already installed
    else
        echo Installing ssdeep and python-ssdeep
        aptitude install ssdeep cython
        pip install ssdeep
        $INST subversion
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


# unpack clamav signatures
unpack_clamav() {
    echo Checking for clamav signatures. . .

    #define local variables
    CLAMDB_PATH=$MAIN_PATH/dbfiles/clamdb
    CLSIG_PATH=/var/lib/clamav
    SIGT="sigtool -u /var/lib/clamav"
    EMAIN="Unpacking clamav main.cvd signatures failed\nYou will need to run sudo apt-get install clamav-freshclam again\nAnd run sigtool -u /var/lib/clamav/main.cvd OR daily.cld"
    EDAILY="Unpacking clamav daily.cvd signatures failed\nYou will need to run sudo apt-get install clamav-freshclam again\nAnd run sigtool -u /var/lib/clamav/daily.cvd OR daily.cld"


    if [ -f $CLAMDB_PATH/main.ndb ]; then
        echo clamav signatures already unpacked
        echo Removing old clamav signatures
        rm -r -f $MAIN_PATH/dbfiles/clamdb
        mkdir -p $MAIN_PATH/dbfiles/clamdb
        cd $CLAMDB_PATH
        if [ -f $CLSIG_PATH/main.cvd ]; then
            $SIGT/main.cvd
            echo Unpacking new clamav main.cvd sigantures
        elif [ -f $CLSIG_PATH/main.cld ]; then
            $SIGT/main.cld
            echo Unpacking new clamav main.cld sigantures
        else
            echo -e $EMAIN
        fi
        if [ -f $CLSIG_PATH/daily.cvd ]; then
            $SIGT/daily.cvd
            echo Unpacking new clamav daily.cvd signatures
        elif [ -f $CLSIG_PATH/daily.cld ]; then
            $SIGT/daily.cld
            echo Unpacking new clamav daily.cld signatures
        else
            echo -e $EDAILY
        fi
    else
        cd $CLAMDB_PATH
        echo No clamav signatures present
        echo Unpacking clamav signatures
        if [ -f $CLSIG_PATH/main.cvd ]; then
            $SIGT/main.cvd
        elif [ -f $CLSIG_PATH/main.cld ]; then
            $SIGT/main.cld
        else
            echo -e $EMAIN
        fi
        if [ -f $CLSIG_PATH/daily.cvd ]; then
            $SIGT/daily.cvd
        elif [ -f $CLSIG_PATH/daily.cld ]; then
            $SIGT/daily.cld
        else
            echo -e $EDAILY
        fi
    fi
    cd
    echo ——————————————————————————————————————————————— >> $LOG_PATH/install.log
    echo   >> $LOG_PATH/install.log
    echo Unpacking clamav signatures complete
}


# this section executes the above written stuff

initial_setup
install_python
install_clamav
install_tor
install_yara
install_ssdeep
unpack_clamav


echo -e "Your setup is complete.\nSee the install.log file in logs for details\nand check the install-errors.log for information \non any errors during installation."
