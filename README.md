# MWBox
designed for Vagrant, but more flexible than that... maybe. Analyze malware

# Requirements
Virtualbox

https://www.virtualbox.org/

Vagrant

https://www.vagrantup.com/

# Build it
download the MWBox package, use the icon at the side of the page or 

$ git clone https://github.com/nkleck/MWBox.git
- if you dont have git: $ sudo apt-get install git


in terminal drive to the MWBox directory

$ vagrant up

- a long script runs, sets up the box


ssh into the box

$ vagrant ssh


if you have already created the box, the second time you bring up the box, it will not go through the long setup script. So if you want to check for updates to the box and tools, after you did 'vagrant up' run:

$ vagrant provision


to close the session

$ exit


to stop the vm

$ vagrant halt


to destroy the vm

$ vagrant destroy

- at this point, you can delete the directory if you as well

# In the box
there are a number of toolsets for file analysis in the box. All of the tools are open source. majority of them are in the toolbox directory. more are linked to your PATH. for a quick reference on using each tool, see the README in the toolbox directory. for a more detailed instructions on using them, see the specific pages related to each tool. Some are linked below:

See /toolbox/README.md for details on tool usage, GUI, anonymous queries, etc

https://www.torproject.org/

http://yara.readthedocs.org/en/v3.2.0/index.html

http://www.clamav.net/index.html

https://github.com/9b/pdfxray_lite


# Installing without Vagrant
if you are going to run this without using Vagrantbox, you will need to change a couple lines in the install.sh script and the tools.sh script. You will not run the bootstrap.sh script

In install.sh
- change:
at to bottom there is 4 instances of  /home/vagrant/.bashrc
- change this to $HOME/.bashrc


In tools.sh
-change:
/home/vagrant/.bashrc
to 
$HOME/.bashrc

now you can run each scrips in the following sequence
sudo ./install.sh
sudo ./tools.sh


