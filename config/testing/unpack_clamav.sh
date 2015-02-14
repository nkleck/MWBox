#!/bin/bash
###
#
#
#	testing the clamav signature unpacking script
#
#   so what we are doing here, we are checking the clamdb file for the clam signature db's
#       - if they are already there, then we remove the directory and contents, and re-create the dir
#       - then we re-unpack the signatures back into the directory
#       - the reason for this is that when the vagrant up is given, it will refresh the signature files
#       - so we are refreshing our own signature db file with those up-to-date signatures
#       - if the signatures are not there, then we go ahead and put them there
#
#
#

#define global variables
MAIN_PATH=`pwd`
LOG_PATH=$MAIN_PATH/logs
UB_PATH=/usr/bin
INST="apt-get install -y"

exec > >(tee -a $LOG_PATH/install.log)
exec 2> >(tee -a $LOG_PATH/install-errors.log)


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

unpack_clamav
