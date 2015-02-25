#!/bin/bash
###
#
#	this sets up the scripts, does their initial config and adds to $PATH
#
#
#   tools to look into
#
#totalhash.py - done
#XORStrings - NEEDS WORK
#XORSearch - NEEDS WORK
#
#   Executable analysis
#exescan.py - NEEDS SOME FIXIN
#pescanner.py - SCRIPT NEEDS SOME FIXIN
#pyew - done
#clamscan  -install.sh installs this, tools.sh unpacks signatures
#objdump  -really cool, already installed
#radare - MAYBE on a future build r2 is CLI
#
#   office analysis
#officeparser.py  -done
#officeMalScanner - done
#
#   pdf analysis
#pdf-parser - done
#peepdf - done
#pdf.py
#origami - done
#   - pdfextract, pdfwalker, pdfcop, pdfdecrypt, pdfencrypt, pdfdecompress,
#   - pdfcocoon, pdfmetadata, pdf2graph, pdf2ruby, pdfsh,
#   - pdfexplode, pdf2ps, pdf2pdfa, pdf2dsc
#
#
#   shellcode analysis
#sctest
#DiStorm (dissemble shellcode)
#libemu (emulate shellcode)
#
#   network traffic
#t-shark  -done
#tcp-dump  -done
#dnsmap - done
#
#
#   WRITEUP ON EACH IN README in TOOLBOX AND WHAT EACH IS GOOD TO USE ON
#       include a how-to use the GUI for some tools like pdfwalker





#define global variables
MAIN_PATH=`pwd`
LOG_PATH=$MAIN_PATH/logs
UB_PATH=/usr/bin
INST="apt-get install -y"
TOOL_PATH=$MAIN_PATH/toolbox


#Add stuff to $PATH
PATH=$PATH:$MAIN_PATH/toolbox
PATH=$PATH:$MAIN_PATH/toolbox/recon
PATH=$PATH:$MAIN_PATH/toolbox/file_analysis
PATH=$PATH:$MAIN_PATH/toolbox/office_analysis
PATH=$PATH:$MAIN_PATH/toolbox/pe_analysis
PATH=$PATH:$MAIN_PATH/toolbox/av_scanners
PATH=$PATH:$MAIN_PATH/toolbox/pdf_analysis
PATH=$PATH:$MAIN_PATH/toolbox/yara_scripts



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

# install and build Jsunpack-n: includes spidermonkey, pdf.py
install_jsunpack-n() {
    if [ -f $MAIN_PATH/dev/jsunpack-n/depends/js-1.8.0-rc1-src/Linux_All_OPT.OBJ/js ]; then
        echo jsunpack-n is already installed
    else
        echo installing jsunpack-n
        cd $MAIN_PATH/dev
        svn checkout http://jsunpack-n.googlecode.com/svn/trunk/ jsunpack-n
        cd $MAIN_PATH/dev/jsunpack-n/depends
        tar xvfz js-1.8.0-rc1-src.tar.gz
        cd js-1.8.0-rc1-src
        make BUILD_OPT=1 -f Makefile.ref
        PATH=$PATH=:$MAIN_PATH/dev/jsunpack-n/depends/js-1.8.0-rc1-src/
        if [ -f /usr/local/bin/yara ]; then
            echo yara is already installed
        else
            echo Installing yara. . .
            cd $MAIN_PATH/dev/
            git clone https://github.com/plusvic/yara.git yara
            cd yara
            ./bootstrap.sh
            ./configure
            make
            make install
        fi
        cat /etc/ld.so.conf | grep -q "/usr/local/lib"
        if [ $? -ne 0 ]; then
            echo "/usr/local/lib/" | sudo tee -a /etc/ld.so.conf
            ldconfig
        fi
        if [ -f /usr/local/lib/python2.7/dist-packages/yara_python-3.3.0.egg-info ]; then
            echo yara-python already installed
        else
            if [ -f $MAIN_PATH/dev/yara/yara-python/setup.py ]; then
                echo installing yara-python
                cd $MAIN_PATH/dev/yara/yara-python/
                python setup.py build
                python setup.py install
            else
                pip install yara-python
            fi
            if [ -f /usr/local/lib/python2.7/dist-packages/yara_python-3.3.0.egg-info ]; then
                echo yara-python succcessfully installed
            else
                cd $MAIN_PATH/dev/yara/
                rm -rf yara-python
                pip install yara-python
                ls /usr/local/lib/python2.7/dist-packages/yara_python-3.3.0.egg-info;
                if [ $? -ne 0 ]; then
                    echo -e "yara-python failed to install. manually try installing it.\nfollow instructions at http://yara.readthedocs.org/en/v3.3.0/gettingstarted.html\n -or- remove the yara-python dir and $ sudo pip install yara-python"
                fi
            fi
        fi
    fi
}


#Install Stream
install_stream() {
    if [ -f /usr/bin/stream ]; then
        echo stream is already installed
    else
        apt-get install imagemagick
        echo stream is installed
    fi
}


#Install pdftk
install_pdftk() {
    if [ -f /usr/bin/pdftk ]; then
        echo pdftk is already installed
    else
        apt-get install -y pdftk
    fi
}


# Install pdftotext
install_pdftotext() {
    if [ -f /usr/bin/pdftotext ]; then
        echo pdftotext is already installed
    else
        apt-get install -y poppler-utils
    fi
}


#install pdfxray_lite
install_pdfxray_lite() {
    if [ -f $TOOL_PATH/pdf_analysis/pdfxray_lite/pdfxray_lite.py ]; then
        echo pdfxray_lite is already installed
    else
        cd $TOOL_PATH/pdf_analysis
        git clone https://github.com/9b/pdfxray_lite
        PATH=$PATH:$MAIN_PATH/toolbox/pdf_analysis/pdfxray_lite
    fi
}


#diierstevens suite
#https://didierstevens.com/files/software/DidierStevensSuite.zip
#maybe requires
#https://didierstevens.com/files/software/Ariad_V0_0_0_9.zip

# installing pdfid
install_pdfid() {
    if [ -f $TOOL_PATH/pdf_analysis/pdfid/pdfid.py ]; then
        echo pdfid is already installed
    else
        cd $TOOL_PATH/pdf_analysis
        wget http://didierstevens.com/files/software/pdfid_v0_2_1.zip
        unzip pdfid_v0_2_1.zip -d pdfid
        chmod +x $TOOL_PATH/pdf_analysis/pdfid/pdfid.py
        rm pdfid_v0_2_1.zip
        PATH=$MAIN_PATH/toolbox/pdf_analysis/pdfid:$PATH
    fi
}


# install AnalyzePDF
install_AnalyzePDF() {
    if [ -f $TOOL_PATH/pdf_analysis/AnalyzePDF/AnalyzePDF.py ]; then
        echo AnalyzePDF already installed
    else
        cd $TOOL_PATH/pdf_analysis
        git clone https://github.com/hiddenillusion/AnalyzePDF.git
        sed -i -e "s:\/usr\/local\/etc\/capabilities.yara:pdf_rules.yara:g" /vagrant/toolbox/pdf_analysis/AnalyzePDF/AnalyzePDF.py
        PATH=$PATH:$MAIN_PATH/toolbox/pdf_analysis/AnalyzePDF
        PATH=$PATH:$MAIN_PATH/toolbox/pdf_analysis/AnalyzePDF/extras
    fi

    cat /etc/ld.so.conf | grep -q "/usr/local/lib"
    if [ $? -ne 0 ]; then
        echo "/usr/local/lib/" | sudo tee -a /etc/ld.so.conf
        ldconfig
    fi
}


#install pdf-parser
install_pdfparser() {
    if [ -f $TOOL_PATH/pdf_analysis/pdf-parser.py ]; then
        echo pdf-parser is already installed
    else
        cd $TOOL_PATH/pdf_analysis/
        wget https://didierstevens.com/files/software/pdf-parser_V0_6_0.zip
        unzip pdf-parser_V0_6_0.zip
        chmod +x pdf-parser.py
        rm $TOOL_PATH/pdf_analysis/pdf-parser_V0_6_0.zip
    fi
}


# install origami: pdfextract, pdfwalker, pdfcop, pdfdecrypt,
#    pdfencrypt, pdfdecompress, pdfcocoon, pdfmetadata,
#    pdf2graph, pdf2ruby, pdfsh, pdfexplode, pdf2ps, pdf2pdfa, pdf2dsc
install_origami() {
    if [ -f /usr/local/bin/pdfcop ]; then
        echo origami tools are already installed
    else
        gem install origami
        apt-get install ruby-gtk2
    fi
}


# install peepdf
install_peepdf() {
    if [ -d $TOOL_PATH/pdf_analysis/peepdf_0.3 ]; then
        echo peepdf is already installed
    else
        cd $TOOL_PATH/pdf_analysis
        wget http://eternal-todo.com/files/pdf/peepdf/peepdf_0.3.tar.gz
        tar -zxvf peepdf_0.3.tar.gz
        rm peepdf_0.3.tar.gz
        PATH=$PATH:$MAIN_PATH/toolbox/pdf_analysis/peepdf_0.3
    fi
}


# Installing officeparser.py
install_officeparser() {
    if [ -f $TOOL_PATH/office_analysis/officeparser.py ]; then
        echo officeparsere is already installed
    else
        cd $TOOL_PATH/office_analysis
        git clone https://github.com/unixfreak0037/officeparser.git
        PATH=$PATH:$MAIN_PATH/toolbox/office_analysis/officeparser
    fi
}


#install officemalscanner
#requires wine for use, install.sh installs wine
install_officemalscanner() {
    if [ -f $TOOL_PATH/office_analysis/officemalscanner/OfficeMalScanner.exe ]; then
        echo OfficeMalScanner is already installed
    else
        cd $TOOL_PATH/office_analysis
        wget http://www.reconstructer.org/code/OfficeMalScanner.zip
        unzip OfficeMalScanner.zip -d officemalscanner
        rm $TOOL_PATH/office_analysis/OfficeMalScanner.zip
        PATH=$PATH:$MAIN_PATH/toolbox/office_analysis/officemalscanner
#PROBLEM, CANNOT CALL IT FROM PATH
    fi
}


#install totalhash.py - looks up suspicious files at totalhash.com
install_totalhash() {
    if [ -f $TOOL_PATH/file_analysis/totalhash.py ]; then
        echo totalhash.py already installed
    else
        cd $TOOL_PATH/file_analysis
        git clone https://gist.github.com/10270150.git
        mv $TOOL_PATH/file_analysis/10270150/totalhash.py .
        rm -rf 10270150
    fi
}


#install XORStrings
#requires wine
install_xorstrings() {
    if [ -f $TOOL_PATH/file_analysis/XORStrings/xorstrings.exe ]; then
        echo XORStrings already installed
    else
        cd $TOOL_PATH/file_analysis
        wget https://didierstevens.com/files/software/XORStrings_V0_0_1.zip
        unzip XORStrings_V0_0_1.zip -d XORStrings
        rm XORStrings_V0_0_1.zip
        chmod +x $TOOL_PATH/file_analysis/XORStrings/xorstrings.exe
        PATH=$PATH:$MAIN_PATH/toolbox/file_analysis/XORStrings
#PROBLEM, CANNOT GET PATH TO WORK from path.
#the only time it works is if i drive to the directory with .exe and use $ wine xorstrings.exe -m <path to file>
# in order to see it from path, need to chmod +x,
# there is a OSX version, doesnt work here. so using wine with the exe, can call exe from path,
# but need to back curser and add wine before it, and doesnt call it at that point
    fi
}


#install XORSearch
install_xorsearch() {
    if [ -f $TOOL_PATH/file_analysis/XORSearch/Linux/xorsearch ]; then
        echo XORSearch already installed
    else
        cd $TOOL_PATH/file_analysis
        wget https://didierstevens.com/files/software/XORSearch_V1_11_1.zip
        unzip XORSearch_V1_11_1.zip -d XORSearch
        rm XORSearch_V1_11_1.zip
        chmod +x $TOOL_PATH/file_analysis/XORSearch/Linux/xorsearch
        PATH=$PATH:$TOOL_PATH/file_analysis/XORSearch/Linux
    fi
}





# Exescan install
install_exescan() {
    if [ -f $TOOL_PATH/pe_analysis/ExeScan/exescan.py ]; then
        echo ExeScan is already installed
    else
        cd $TOOL_PATH/pe_analysis
        wget http://securityxploded.com/getfile_direct.php?id=4011 -O exescan.zip
        unzip exescan.zip
        rm exescan.zip
        chmod +x $TOOL_PATH/pe_analysis/ExeScan/exescan.py
#if i chmod +x, i can call it from path, but can execute it, if i dont, i can execute it as long as i am in its current dir
        PATH=$PATH:$TOOL_PATH/pe_analysis/ExeScan
    fi
}


#install pyew
install_pyew() {
    if [ -f $TOOL_PATH/pe_analysis/pyew-2.0-linux/pyew.py ]; then
        echo pyew already installed
    else
        cd $TOOL_PATH/pe_analysis
        wget https://pyew.googlecode.com/files/pyew-2.0-linux-x86.tar.gz
        tar -zxvf pyew-2.0-linux-x86.tar.gz
        rm pyew-2.0-linux-x86.tar.gz
        PATH=$PATH:$TOOL_PATH/pe_analysis/pyew-2.0-linux
    fi
}


#install dnsmap
install_dnsmap() {
    if [ -f $TOOL_PATH/recon/dnsmap-0.30/dnsmap ]; then
        echo dnsmap already installed
    else
        cd $TOOL_PATH/recon
        wget http://dnsmap.googlecode.com/files/dnsmap-0.30.tar.gz
        tar -zxvf dnsmap-0.30.tar.gz
        rm dnsmap-0.30.tar.gz
        cd $TOOL_PATH/recon/dnsmap-0.30
        make
        make install
        PATH=$PATH:$TOOL_PATH/recon/dnsmap-0.30
    fi
}


#install t-shark
install_tshark() {
    if [ -f $UB_PATH/tshark ]; then
        echo t-shark is already installed
    else
        echo installing t-shark
        $INST tshark
    fi
}


#install tcpdump
install_tcpdump() {
    if [ -f /usr/sbin/tcpdump ]; then
        echo tcpdump is already installed
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
        echo proxychains installation complete
    fi
}


# unpack clamav signatures
unpack_clamav() {
    echo Checking for clamav signatures. . .

#define local variables
CLAMDB_PATH=$MAIN_PATH/dbfiles/clamdb
CLSIG_PATH=/var/lib/clamav
SIGT="sigtool -u /var/lib/clamav"
EMAIN="Unpacking clamav main.cvd signatures failed\nYou will need to run sudo apt-get install clamav-freshclam again\nAnd run sigtool -u /var/lib/clamav/main.cvd OR daily.cld"
EDAILY="Unpacking clamav daily.cvd signatures failed\nYou will need to run sudo apt-get install clamav-freshclam again\nAnd run sigtool -u /var/lib/clamav/daily.cvd OR daily.cld"


    if [ -f $CLAMDB_PATH/main.ndb ]; then
        echo clamav signatures already unpacked
        echo Removing old clamav signatures
        rm -r -f $MAIN_PATH/dbfiles/clamdb
        mkdir -p $MAIN_PATH/dbfiles/clamdb
        cd $CLAMDB_PATH
        if [ -f $CLSIG_PATH/main.cvd ]; then
            $SIGT/main.cvd
            echo Unpacking new clamav main.cvd sigantures
        elif [ -f $CLSIG_PATH/main.cld ]; then
            $SIGT/main.cld
            echo Unpacking new clamav main.cld sigantures
        else
            echo -e $EMAIN
        fi
        if [ -f $CLSIG_PATH/daily.cvd ]; then
            $SIGT/daily.cvd
            echo Unpacking new clamav daily.cvd signatures
        elif [ -f $CLSIG_PATH/daily.cld ]; then
            $SIGT/daily.cld
            echo Unpacking new clamav daily.cld signatures
        else
            echo -e $EDAILY
        fi
    else
        cd $CLAMDB_PATH
        echo No clamav signatures present
        echo Unpacking clamav signatures
        if [ -f $CLSIG_PATH/main.cvd ]; then
            $SIGT/main.cvd
        elif [ -f $CLSIG_PATH/main.cld ]; then
            $SIGT/main.cld
        else
            echo -e $EMAIN
        fi
        if [ -f $CLSIG_PATH/daily.cvd ]; then
            $SIGT/daily.cvd
        elif [ -f $CLSIG_PATH/daily.cld ]; then
            $SIGT/daily.cld
        else
            echo -e $EDAILY
        fi
    fi
    echo Unpacking clamav signatures complete
}


#execute functions below this line
modify_wget
install_jsunpack-n
install_stream
install_pdftk
install_pdftotext
install_pdfxray_lite
install_pdfid
install_AnalyzePDF
install_origami
install_pdfparser
install_peepdf
install_officeparser
install_officemalscanner
install_totalhash
install_xorstrings
install_xorsearch
install_exescan
install_pyew
install_dnsmap
install_tshark
install_tcpdump
install_nmap
install_proxychains
unpack_clamav


#append new paths to .bashrc
append_path() {
    cat $HOME/.bashrc | grep -q toolbox
    if [ $? -ne 0 ]; then
        echo -e "\n" >> $HOME/.bashrc
        echo PATH="$PATH" >> $HOME/.bashrc
    fi
}

append_path
