#!/usr/bin/env bash
###
#
#
#	This is the bootstrap file, that will customize most of the vagrant build 
#
#

cd /vagrant #change this to whatever dir you are going to install if not using vagrant

SHARE_PATH=`pwd`

bash $SHARE_PATH/config/install.sh
bash $SHARE_PATH/config/tools.sh
