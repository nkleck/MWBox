# MWBox
Designed for Vagrant, but more flexible than that... maybe. Analyze malware

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


# Tools in this box
The following tools are available in this configuration, see toolbox/README.md for usage details
- Python and some of its dev’s, most of the tools have python dependencies
- clamscan
- Tor
- yara and yara-python
- ssdeep
- wine
- a GUI, see the gui.sh script and frontpage README for information on usage 
- wget aliases
- av_multiscan.py
- pescanner.py
- capabilities.yara
- clamav_to_yara.py
- magic.yara
- packer.yara
- peid_to_yara.py
- artifactscanner.py
- avsubmit.py
- dbmgr.py
- jsunpack-n
- libemu
- stream
- strings
- pdftotext
- pdfxray_lite
- diderstevens tool suite
- pdfid
- AnalyzePDF
- pdf-parser
- Origami tool suite
    - pdfextract
    - pdfwalker - requires a GUI, see below 
    - pdfcop
    - pdfdecrypt
    - pdfencrypt
    - pdfdecompress 
    - pdfcocoon
    - pdfmetadata
    - pdf2graph 
    - pdf2ruby 
    - pdfsh
    - pdfexplode 
    - pdf2ps
    - pdf2pdfa 
    - pdf2dsc
- peepdf
- officeparser.py
- officemalscanner - requires wine for use, see below
- totalhash.py
- XORStrings
- XORSearch
- exescan
- pyew
- dnsmap
- html2text
- whois
- dnsutils
- pdftk
- netcat
- tshark
- tcpdump
- nmap
- proxychains

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


# Questions, Comments, or whatever
Everything contained in this box is from open source. If you would like to see somehting added to the box, send me a note on github. As others update their tools, this box may break. If that is the case, send a note or file an issue on github and I'll do what I can to correct the issue. 

