#!/bin/bash
###
#
#		this script installs clamav
#		checks to see if it is installed first, and runs update if true
#


#define global variables
MAIN_PATH=`pwd`
LOG_PATH=$MAIN_PATH/logs
UB_PATH=/usr/bin
INST="apt-get install -y"

exec > >(tee -a $LOG_PATH/install.log)
exec 2> >(tee -a $LOG_PATH/install-errors.log)

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

install_clamav
