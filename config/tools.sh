#!/bin/bash
###
#
#	this sets up the scripts, does their initial config and adds to $PATH
#
#
#   tools to look into
#VBinDiff
#totalhash.py
#exescan.py
#pescanner.py - needs some fixin
#XORStrings
#officeparser.py  -done
#pdf-extract - may not work
#pdf-parser -done
#officeMalScanner
#pdfdecrypt
#pdf-parser  -done
#t-shark  -done
#tcp-dump  -done





#define global variables
MAIN_PATH=`pwd`
LOG_PATH=$MAIN_PATH/logs
UB_PATH=/usr/bin
INST="apt-get install -y"
TOOL_PATH=$MAIN_PATH/toolbox

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

$INST html2text

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

    if [ -f $TOOL_PATH/pdf_analysis/pdfxray_lite/pdfxray_lite.py ]; then
        continue
    else
        cd $TOOL_PATH/pdf_analysis
        git clone https://github.com/9b/pdfxray_lite
    fi
}


#installing pdfextract
#this aint gonna work, there is a problem with the script and ruby in vagrant.
#git clone https://github.com/CrossRef/pdfextract.git
#apt-get install -y ruby-full
#apt-get install ruby-dev
#apt-get install zlib1g-dev
#apt-get install libsqlite3-dev



# installing AnalyzePDF
analyze_pdf(){
    if [ -f $TOOL_PATH/pdf_analysis/pdfid/pdfid.py ]; then
        continue
    else
        cd $TOOL_PATH/pdf_analysis
        wget http://didierstevens.com/files/software/pdfid_v0_2_1.zip
        unzip pdfid_v0_2_1.zip -d pdfid
        chmod +x $TOOL_PATH/pdf_analysis/pdfid/pdfid.py
        rm pdfid_v0_2_1.zip
    fi

    if [ -f $TOOL_PATH/pdf_analysis/AnalyzePDF/AnalyzePDF.py ]; then
        echo AnalyzePDF already installed
    else
        cd $TOOL_PATH/pdf_analysis
        git clone https://github.com/hiddenillusion/AnalyzePDF.git
        sed -i -e "s:\/usr\/local\/etc\/capabilities.yara:pdf_rules.yara:g" /vagrant/toolbox/pdf_analysis/AnalyzePDF/AnalyzePDF.py
    fi

    cat /etc/ld.so.conf | grep -q "/usr/local/lib"
    if [ $? -ne 0 ]; then
        echo "/usr/local/lib/" | sudo tee -a /etc/ld.so.conf
        ldconfig
    fi
}


#install pdf-parser
install_pdfparser(){
    if [ -f $TOOL_PATH/pdf_analysis/pdf-parser.py ]; then
        continue
    else
        cd $TOOL_PATH/pdf_analysis/
        wget https://didierstevens.com/files/software/pdf-parser_V0_6_0.zip
        unzip pdf-parser_V0_6_0.zip
        chmod +x pdf-parser.py
        rm pdf-parser_V0_6_0.zip
    fi
}


# Installing officeparser.py
install_officeparser(){
    if [ -f $TOOL_PATH/office_analysis/officeparser.py ]; then
        continue
    else
        cd $TOOL_PATH/office_analysis
        git clone https://github.com/unixfreak0037/officeparser.git
    fi
}


#install t-shark
install_tshark(){
    if [ -f $UB_PATH/tshark ]; then
        continue
    else
        echo installing t-shark
        $INST tshark
    fi
}


#install tcpdump
install_tcpdump(){
    if [ -f /usr/sbin/tcpdump ]; then
        continue
    else
        echo installing tcpdump
        $INST tcpdump
    fi
}


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
analyze_pdf
install_pdfparser
install_officeparser
install_tshark
install_tcpdump
install_nmap
install_proxychains
