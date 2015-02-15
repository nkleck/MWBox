#!/bin/bash
#
#	just the initial stuff

#define global variables
MAIN_PATH=`pwd`
LOG_PATH=$MAIN_PATH/logs
UB_PATH=/usr/bin
INST="apt-get install -y"

# setup the vagrant directory
initial_setup() {

    apt-get update
    apt-get -y upgrade
    $INST git libtool automake unzip

}


# Install python
install_python() {

    $INST python3-all-dev build-essential libffi-dev python-dev libfuzzy-dev python-pip python-magic python-pefile
}


initial_setup
install_python
