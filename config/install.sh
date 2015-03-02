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

cd /home/vagrant    #remove this line if you are not using vagrant

#define global variables
SHARE_PATH=/vagrant         #remove this line if you are not using vagrant
MAIN_PATH=`pwd`
LOG_PATH=$MAIN_PATH/logs
UB_PATH=/usr/bin
INST="apt-get install -y"
TOOL_PATH=$MAIN_PATH/toolbox

if [ -d $MAIN_PATH/dev ]; then
    echo initial config already ran, check for updates instead...
else
    for d in 'dbfiles dev logs samples signatures'; do
        mkdir -p $MAIN_PATH/$d
        if [ -d $SHARE_PATH/config/toolbox ]; then
            mv $SHARE_PATH/config/toolbox $TOOL_PATH
        fi
        if [ -d $TOOL_PATH/recon ]; then
            echo recon dir already exists
        else
            mkdir $TOOL_PATH/recon
        fi
        if [ -d $TOOL_PATH/file_analysis ]; then
            echo file_analysis dir already exists
        else
            mkdir $TOOL_PATH/file_analysis
        fi
        if [ -d $TOOL_PATH/office_analysis ]; then
            echo office_analysis dir already exists
        else
            mkdir $TOOL_PATH/office_analysis
        fi
        if [ -d $TOOL_PATH/pe_analysis ]; then
            echo pe_analysis dir already exists
        else
            mkdir $TOOL_PATH/pe_analysis
        fi
        if [ -d $TOOL_PATH/pdf_analysis ]; then
            echo pdf_analysis dir already exists
        else
            mkdir $TOOL_PATH/pdf_analysis
        fi
        if [ -d $TOOL_PATH/av_scanners ]; then
            echo av_scanners dir already exists
        else
            mkdir $TOOL_PATH/av_scanners
        fi
        if [ -d $TOOL_PATH/yara_scripts ]; then
            echo yara_scripts dir already exists
        else
            mkdir $TOOL_PATH/yara_scripts
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
    $INST git libtool autoconf automake unzip subversion
    echo Initial setup complete. . . lots more to go!
}


# Install python
install_python() {
    echo Installing python packages. . .
    $INST python3-all-dev build-essential libffi-dev libfuzzy-dev python-pip python-magic python-pefile python-lxml libpcap-dev pkg-config python-dev libgtk2.0-dev libnet1-dev python-beautifulsoup python-crypto libpcre3 libpcre3-dev
    echo Python packages installation complete.
}



# Install clamav and create clam signature db
install_clamav() {
    if [ -f $UB_PATH/clamscan ]; then
        echo clamav is already installed
        echo Updating clamav
        $INST clamav-freshclam
        wait
    else
        echo Installing clamav and its files. . .
        cd $MAIN_PATH/dbfiles
        mkdir clamdb
        $INST clamav clamav-freshclam clamav-testfiles
        wait
        cd $MAIN_PATH/samples/
        mkdir clamav
        mv /usr/share/clamav-testfiles $MAIN_PATH/samples/clamav
        echo clamav installation and setup complete
    fi
}


# Install Tor
install_tor() {
    if [ -f /usr/bin/tor ]; then
        echo Tor is already installed
    else
        cat /etc/apt/sources.list | grep -q "deb.torproject.org"
        if [ $? -ne 0 ]; then
            echo "deb http://deb.torproject.org/torproject.org trusty main" | sudo tee -a /etc/apt/sources.list
            echo "deb-src http://deb.torproject.org/torproject.org trusty main" | sudo tee -a /etc/apt/sources.list
            echo added deb http://deb.torproject.org/torproject.org trusty main to source.list
        fi

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
        if [ $? -ne 0 ]; then
            gpg --export A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89 | sudo apt-key add -
        fi

        apt-key list | grep -q "deb.torproject.org archive signing key";
        if [ $? == 0 ]; then
            apt-get update
            $INST deb.torproject.org-keyring
            echo installing tor
            $INST tor
        fi

        if [ -f /usr/bin/tor ]; then
            echo Tor is installed
        else
            echo Tor is unable to install, see: https://www.torproject.org/docs/debian
        fi
    fi
}


# Installing Yara
install_yara() {
    if [ -f /usr/local/bin/yara ]; then
        echo yara is already installed
    else
        echo Installing yara. . .
        cd $MAIN_PATH/dev/
        git clone https://github.com/plusvic/yara.git yara
        cd $MAIN_PATH/dev/yara
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
            echo yara-python successfully installed
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


# Install ssdeep and things
install_ssdeep() {
    if [ -f $UB_PATH/ssdeep ]; then
        echo ssdeep is already installed
    else
        echo Installing ssdeep and python-ssdeep
        aptitude install ssdeep cython
        pip install ssdeep
        echo ssdeep installation complete
    fi
}


#install wine
install_wine(){
    if [ -f /usr/bin/wine ]; then
        echo wine is already installed
    else
        dpkg --add-architecture i386
        apt-get update
        $INST wine1.6
    fi
}


# this section executes the above written stuff

initial_setup
install_python
install_clamav
install_tor
install_yara
install_yara_python
install_ssdeep
install_wine


#shorten the working path, long paths are annoying
#IF YOU ARE NOT USING VAGRANT, REPLACE THE /home/vagrant/.bashrc with $HOME/.bashrc in lines below
cat $MAIN_PATH/.bashrc | fgrep -q "PS1='\[\033[01;32m\]\u\[\033[00m\]:\[\033[01;34m\]\W\[\033[00m\]$ '"
    if [ $? -ne 0 ]; then
        echo -e "\n" >> $MAIN_PATH/.bashrc
        echo "PS1='\[\033[01;32m\]\u\[\033[00m\]:\[\033[01;34m\]\W\[\033[00m\]$ '" >> $MAIN_PATH/.bashrc
        echo "PS1='\u:\W$ '" >> $MAIN_PATH/.bashrc
    fi

echo -e "Your setup is complete.\nSee the install.log file in logs for details\nand check the install-errors.log for information \non any errors during installation."
