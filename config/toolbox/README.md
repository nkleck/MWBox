
This installation of vagrantbox should be useful for malware analysis. Everything in here was made from free software. Do with it what you will, make it better.

#TODO
ADD
- https://github.com/goulu/pdfminer.git
- https://github.com/mozilla/masche.git
- http://eternal-todo.com/var/scripts/xorbruteforcer
- https://github.com/hiddenillusion/NoMoreXOR

# Tools in this box
The following tools are available in this configuration, see below for usage
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


# Initializing the GUI

Some tools like pdfwalker require the use of a GUI. see below for GUI initialization

To turn the GUI feature on/off, install the GUI, and check if it is installed
go to the config dir and run the gui.sh script

- $ cd /vagrant/config
- $ sudo ./gui.sh
- this script will ask you if you want to turn On or Off the GUI feature, 
and then install the GUI software if it is not already installed
- after running this script, you will need to log out of vagrant, and restart it
- $ exit
- $ vagrant halt
- $ vagrant up
- $ vagrant ssh
- ignore the GUI box that opens at this point, you need to initiate one from within vagrant

initializing the GUI
- $ sudo startxfce4&

logout of GUI but keep vagrant session open
- in the GUI, open XTerm
- $ xfce4-session-logout
- this still leaves you logged into your vagrant session
- if you close the xfce4 via Virtualbox, it will halt the vagrant box

# Tool Usage
- Anonymous web
- PDF Analysis
- Office doc analysis
- File analysis
- Executable (pe) analysis
- Shellcode analysis

# Anonymous web
Tor
- $ usewithtor <fuction>

wget
- check your wget aliases by typing:
    - $ alias
- to use wget, use one of your aliases:
    - $ wgie7 www.google.com
- test your anonymity:
    - $ wgie7 www.ipchicken.com
    - check the return index.html for an ip addy, its not same as your public ip!

proxychains
    - $ 

# PDF Analysis

pdftk
- uncompress pdf streams for viewing in texteditor
- $ pdftk file.pdf output file.unc.pdf uncompress

AnalyzePDF
- 
- $ python AnalyzePDF.py <test>.pdf

pdfxray_lite
- 
- $ python pdfxray_lite -f <file> -r report
- drive to the report.html file and open it (a browser will open it)
- or use html2text to convert it and read
    - html2text report >> output.txt

pdf-parser.py
- follow tags or objects in pdf's
- Usage: pdf-parser.py [options] <file.pdf>
- pdf-parser.py -h --help for options

pdfwalker
- analyze objects and streams in pdf
- requires the gui tool
    - $ startxfce4&
    - in GUI: Applications>System>XTerm
    - within XTerm the following usage:
        - $ pdfwakder file.pdf

pdf.py
- extract javasripts from pdf files


# Office Analysis

OfficeMalScanner
- requires wine to run, its an .exe, wine is installed in the install.sh script
- usage: wine OfficeMalScanner <PPT, DOC or XLS file> <scan | info> <brute> <debug>
- help: wine OfficeMalScanner
- typical usage: 
    -  $ wine OfficeMalScanner <file> info
    -  $ wine OfficeMalScanner <file> scan brute debug
-  find the start of shellcode in doc file
    -  $ wine DisView.exe <file> 0xa00
-  Wrap shellcode in executable
    -  $ wine MalHost-Setup.exe <file> out.exe 0xa04 //start of shellcode found in DisView search
    -  send out.ext to a debugger

Officeparser
- 


# File Obfuscation

- Good read on XOR malware
- http://digital-forensics.sans.org/blog/2013/05/14/tools-for-examining-xor-obfuscation-for-malware-analysis

XORBruteForcer
- $ xorBruteForcer -k xor_key file [search_pattern]
- k and key xor_key optional. will run all possibilities if not specified

XORStrings
- use the output into a file, because wine dickers up a bit and can be difficult to read
- $ wine xorstrings.exe -m <path to file> >> output.txt

XORSearch
- does not require wine, but can run with wine --not recommended
- $ xorsearch [-option] <file> string|hex|rule
- can output to results by adding to the end  >> output.txt

NoMoreXOR
- $  NoMoreXOR.py -a -o output.hex inputfile

# File Analysis

objdump 
- examines .o and a.out(files without extensions) and executable file(s)
- already installed in ubuntu
- useage:
    - archive headers: $ objdump -a <file>
    - file headers: $ objdump -f <file>
    - disassemble-all: $ objdump -D <file> >> output.txt
    - display full contents: $ objdump -s <file> >> output.txt


# Executable analysis

exeScan
- usage: $ exescan -a <path to exe file>
    - a advanced scan with anomaly detection
    - b display basic information
    - m scan for commonly known malware APIs
    - i display import/export table
    - p display PE header


pyew
- usage:


# Shellcode analysis

libemu usage:
- sctest
- $ sctest -Ss 10000000000 -vvv < shelcodeFile
- $ sctest -Ss 10000000000 -G graph.dot < shelcodeFile
- $ dot -T png -o graph.png graph.dot

# Jsunpack-n usage
- extract HTTP files from pcap
    - $ ./jsunpackn.py ./file.pcap -s -J -v
- run against malicious pdf
    - $ ./jsunpackn.py -V <pdf>
- evaluate javascript
    - $ ./jsunpackn.py -f -V <pdf>









