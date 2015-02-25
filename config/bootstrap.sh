#!/usr/bin/env bash
###
#
#
#	This is the bootstrap file, that will customize most of the vagrant build 
#
#

cd /vagrant #change this to whatever dir you are going to install if not using vagrant

MAIN_PATH=`pwd`

bash $MAIN_PATH/config/install.sh
#bash $MAIN_PATH/config/tools.sh    #working on this script remove # when done
