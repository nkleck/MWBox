
This installation of vagrantbox should be useful for malware analysis. Everything in here was made from free software. Do with it what you will, make it better.

[NOTES]----------------------------------------------------------------------------
The following programs were installed during the setup, hence the long installation.
- Python and some of its dev’s
- Tor
- Proxychains
- Yara
- ssdeep
- clamav

Scripts added (script folder) for analysis
- avsubmit.py
- av_multiscan.py
- pescanner.py
- clam_to_yara.py
- pied_to_yara.py
- dbmgr.py




Things being needed done:
- add a malware sandbox
- build in error handling, output to log file
	- tor installation needs a if then statement since there are different
		ways to install the keys from the keyserver
- build in error handling for some scripts, output to a log file
- install WINE?
- create a cleanup scrip that is last ran in bootstrap
	- cleans up file locations
	- moves setup scripts to config folder, hides config folder

----------------------------------------------------------------------------------
How To Do Stuff:

Install this vagrantbox
- copy the entire directory to the directory you wish to run vagrant from
- in terminal navigate to the directory containing Vagrantfile
- $ vagrant up
	- it will now install the vagrant package, this will take a couple minutes
- $ vagrant ssh
	- logs into the vagrantbox

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

To turn the GUI feature on/off, install the GUI, and check if it is installed
go to the config dir and run the gui.sh script

$ cd /vagrant/config
$ sudo ./gui.sh
- this script will ask you if you want to turn On or Off the GUI feature, 
and then install the GUI software if it is not already installed
- after running this script, you will need to log out of vagrant, and restart it
$ exit
$ vagrant halt
$ vagrant up
$ vagrant ssh
- ignore the GUI box that opens at this point, you need to initiate one from within vagrant


initializing the GUI, some tools require the GUI
$ sudo startxfce4&

logout
- in the GUI, open XTerm]
$ xfce4-session-logout
- this still leaves you logged into your vagrant session
- if you close the xfce4 via Virtualbox, it will end vagrant session

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Anonymous web
- Tor
- wget
- proxychains

wget
- check your wget aliases by typing:
	$ alias
- to use wget, use one of your aliases:
	$ wgie7 www.google.com
- test your anonymity:
	$ wgie7 www.ipchicken.com
	- check the return index.html for an ip addy, its not same as your public ip!


~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

PDF Analysis

pdftk
- uncompress pdf streams for viewing in texteditor
$ pdftk file.pdf output file.unc.pdf uncompress

AnalyzePDF
$ python AnalyzePDF.py <test>.pdf

pdfxray_lite
$ python pdfxray_lite -f <file> -r report
-drive to the report.html file and open it (a browser will open it)
-or use html2text to convert it and read
    - html2text report >> output.txt

pdf-parser.py
Usage: pdf-parser.py [options] pdf-file
- pdf-parser.py -h --help for options

pdfwalker
- requires the gui tool
$ startxfce4&
- in GUI: Applications>System>XTerm 
Usage: pdfwakder file.pdf



~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Office Analysis

OfficeMalScanner
-requires wine to run, its an .exe, wine is installed in the install.sh script
usage: wine OfficeMalScanner <PPT, DOC or XLS file> <scan | info> <brute> <debug>
help: wine OfficeMalScanner
typical usage: wine OfficeMalScanner <file> scan >> output.txt



~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Executable analysis

exeScan
usage: $ exescan -a <path to exe file>
-a advanced scan with anomaly detection
-b display basic information
-m scan for commonly known malware APIs
-i display import/export table
-p display PE header











