#!/bin/bash
###
#

INST="apt-get install -y"


echo -n "Would you like to turn the GUI ON or OFF:  "
read input

if [ "$input" = "OFF" ] || [ "$input" = "off" ] || [ "$input" = "Off" ]; then
    cat /vagrant/Vagrantfile | grep -q "v.gui = false"
    if [ $? = 0 ]; then
        echo GUI is already off
    else
        echo turning GUI off
        sed -i -e "s:v.gui = true:v.gui = false:g" /vagrant/Vagrantfile
    fi
elif [ "$input" = "ON" ] || [ "$input" = "on" ] || [ "$input" = "On" ]; then
    cat /vagrant/Vagrantfile | grep -q "v.gui = true"
    if [ $? = 0 ]; then
        echo GUI is already on
    else
        echo turning GUI on
        sed -i -e "s:v.gui = false:v.gui = true:g" /vagrant/Vagrantfile
    fi
else
    echo You did not type OFF or ON. Please type OFF or ON.
fi

# Install GUI
install_gui() {
    echo Checking to see if GUI is installed...
    if [ -f /usr/bin/startxfce4 ]; then
        echo GUI is already installed
    else
        echo installing gui...
        apt-get update
        $INST xfce4 virtualbox-guest-dkms virtualbox-guest-utils virtualbox-guest-x11
        echo GUI installed
    fi
}

install_gui