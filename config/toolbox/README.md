
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



pdfxray_lite

python pdfxray_lite -f <file> -r report

-drive to the report.html file and open it (a browser will open it)










