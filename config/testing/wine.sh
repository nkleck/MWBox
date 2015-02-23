#!/bin/sh

#  wine.sh
#  
#
#  Created by Remis on 2/20/15.
#


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

install_wine