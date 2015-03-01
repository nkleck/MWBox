# MWBox
designed for Vagrant, but more flexible than that... maybe. Analyze malware

# Requirements
Virtualbox: download the latest version of Virtualbox

https://www.virtualbox.org/

Vagrant: download latest version of Vagrant

https://www.vagrantup.com/

# Download it
Download the MWBox package, use the icon at the side of the page or the following command

- $ git clone https://github.com/nkleck/MWBox.git
- if you dont have git: $ sudo apt-get install git

# Build it
In terminal drive to the MWBox directory and execute the following command

- $ vagrant up
- a long script runs, sets up the box


ssh into the box
- $ vagrant ssh


If you have already created the box, the second time you bring up the box, it will not go through the long setup script. So if you want to check for updates to the box and tools, after you did 'vagrant up' run:
- $ vagrant provision


To close the session
- $ exit


To stop the vm
- $ vagrant halt


To destroy the vm
- $ vagrant destroy
- at this point, you can delete the directory if you as well

# In the box
There are a number of toolsets for file analysis in the box. All of the tools are open source. majority of them are in the toolbox directory. more are linked to your PATH. for a quick reference on using each tool, see the README in the toolbox directory. for a more detailed instructions on using them, see the specific pages related to each tool. Some are linked below:

See /toolbox/README.md for details on tool usage, GUI, anonymous queries, etc

For a more detailed explanation of tool usage, see the following sites:

https://www.torproject.org/

http://yara.readthedocs.org/en/v3.2.0/index.html

http://www.clamav.net/index.html

https://github.com/9b/pdfxray_lite

MORE SITES TO COME...


# Installing without Vagrant
If you are going to run this without using Vagrantbox, you will need to change a couple lines in the install.sh script and the tools.sh script. You will not run the bootstrap.sh script

In the install.sh script at to bottom there is 4 instances of $MAIN_PATH
- changefrom: $MAIN_PATH/.bashrc
- changeto: $HOME/.bashrc

In tools.sh, make the same change
- changefrom: $MAIN_PATH/.bashrc
- changeto: $HOME/.bashrc

now you can run each scrips in the following sequence
- sudo ./install.sh
- sudo ./tools.sh


