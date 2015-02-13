#!/bin/bash
###
#
#	this sets up the scripts, does their initial config and adds to $PATH
#
#   if i add /vagrant/scripts to path, am i good to execute a .py script within a folder in the path
#       or do i need to add that folder to path, or just move that .py script into scripts


#Add stuff to $PATH
PATH=$MAIN_PATH/toolbox:$PATH
PATH=$$MAIN_PATH/toolbox/pdf_tools:$PATH
PATH=$$MAIN_PATH/toolbox/pdf_tools/pdfxray_lite:$PATH


exec > >(tee -a $LOG_PATH/install.log)
exec 2> >(tee -a $LOG_PATH/install-errors.log)

# Modify wget alias
modify_wget() {
    echo Making wget aliases. . .
    if grep -q usewithtor /home/vagrant/.profile; then
        echo wget aliases already set
    else
        echo '# usewithtor wget aliases'
        echo 'alias wgffu='\''usewithtor wget -U "Mozilla/5.0 (X11\; U\; Linux i686\; en-US\; rv:1.9.0.4) Gecko/2008111318 Ubuntu/8.10 (intrepid) Firefox/3.0.4" '\'' '
        echo 'alias wgie='\''usewithtor wget -U "Mozilla/5.0 (Windows\; U\; Windows NT 5.1\; en-US\; rv:1.8.1.1)"  '\'' '
        echo 'alias wgie1='\''usewithtor wget -U "Mozilla/4.0 (compatible\; MSIE 6.0\; Windows NT 5.1\; SV1)" '\'' '
        echo 'alias wgie7='\''usewithtor wget -U "Mozilla/4.0 (compatible\; MSIE 7.0\; Windows NT 5.1\; .NET CLR 2.0.50727)" '\'' '
        echo 'alias wgie10='\''usewithtor wget -U "Mozilla/5.0 (compatible\; MSIE 10.0\; Windows NT 6.1\; WOW64; Trident/6.0)" '\'' '
        echo 'alias wgierss='\''usewithtor wget -U "Mozilla/4.0 (compatible\; MSIE 7.0\; Windows NT 5.1\; Trident/4.0\; InfoPath.2)" '\'' '
        echo wget aliases made
    fi
}


echo Installing scripts...

#Install Stream
install_stream() {
    if [ -f /usr/bin/stream ]; then
        continue
    else
        apt-get install imagemagick
        echo stream is installed
    fi
}

#Install PDF Stuff
install_pdf() {
    if [ -f /usr/bin/pdftk ]; then
        continue
    else
        apt-get install -y pdftk
    fi
    if [ -f /usr/bin/pdftotext ]; then
        continue
    else
        apt-get install -y poppler-utils
    fi
    if [ -f $MAIN_PATH/toolbox/pdfxray_lite/pdfxray_lite.py ]; then
        continue
    else
        cd $MAIN_PATH/toolbox/
        git clone https://github.com/9b/pdfxray_lite
    fi
}



#installing pdfextract
#this aint gonna work
#git clone https://github.com/CrossRef/pdfextract.git
#apt-get install -y ruby-full
#apt-get install ruby-dev
#apt-get install zlib1g-dev
#apt-get install libsqlite3-dev



#installing AnalyzePDF
#AnalyzePDF
# requires yara, pdfid , pdfinfo (installed by poppler-utils)
#pdfid
# wget http://didierstevens.com/files/software/pdfid_v0_2_1.zip
# sudo apt-get install unzip
# chmod +x pdfid.py
# do this in its own file and then path the script
# ADD PDFID.PY TO PATH
# usage: python pdfid.py <file>
# git clone https://github.com/hiddenillusion/AnalyzePDF.git

# will need to correct the path to yara rules at beg of script
# can make it the pdf_rules.yara or the capabilities.yara
#       see if it is possible to automaote this, otherwise, leave instructions to user to do it

#usage
#
# ADD AnalyzePDF to PATH, but cant test until yara-python is unjacked by the developers












# Installing nmap, proxychains can use nmap
install_nmap() {
  if [ -f $UB_PATH/nmap ]; then
    echo nmap is already installed.
  else
    echo Installing nmap. . .
    $INST nmap
    echo ——————————————————————————————————————————————— >> $LOG_PATH/install.log
    echo   >> $LOG_PATH/install.log
    echo nmap installation complete
  fi
}


#Install proxychains
install_proxychains() {
  if [ -f $UB_PATH/proxychains ]; then
    echo proxychains is already installed.
  else
    echo Installing proxychains. . .
    $INST proxychains
    echo ——————————————————————————————————————————————— >> $LOG_PATH/install.log
    echo   >> $LOG_PATH/install.log
    echo proxychains installation complete
  fi
}


#execute functions below this line
modify_wget
install_stream
install_pdf
install_nmap
install_proxychains
