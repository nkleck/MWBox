#!/bin/bash
###
#
#	this sets up the scripts, does their initial config and adds to $PATH
#
#
#   tools to look into
#
#
#
#
#   STILL TO DO
#   - exescan.py - NEEDS SOME FIXIN
#   - pescanner.py - SCRIPT NEEDS SOME FIXIN
#
#   - GO INTO MWCB SCRIPTS ALREADY HAVE, SEE IF CAN GET THEM RATHER THAN STORE THEM, AND THEN GO THROUGH THEIR SETUP
#
#
#   - WRITEUP ON EACH IN README in TOOLBOX AND WHAT EACH IS GOOD TO USE ON
#       include a how-to use the GUI for some tools like pdfwalker
#       - do an install and see if each works, why not, and document its usage
#
#
#   - PROBLEM: IF ITS A .py script, doenst call from path, even if the dir is in path


cd /home/vagrant

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
        echo     >> /home/vagrant/.profile
        echo '# usewithtor wget aliases' >> /home/vagrant/.profile
        echo 'alias wgffu='\''usewithtor wget -U "Mozilla/5.0 (X11\; U\; Linux i686\; en-US\; rv:1.9.0.4) Gecko/2008111318 Ubuntu/8.10 (intrepid) Firefox/3.0.4" '\'' ' >> /home/vagrant/.profile
        echo 'alias wgie='\''usewithtor wget -U "Mozilla/5.0 (Windows\; U\; Windows NT 5.1\; en-US\; rv:1.8.1.1)"  '\'' ' >> /home/vagrant/.profile
        echo 'alias wgie1='\''usewithtor wget -U "Mozilla/4.0 (compatible\; MSIE 6.0\; Windows NT 5.1\; SV1)" '\'' ' >> /home/vagrant/.profile
        echo 'alias wgie7='\''usewithtor wget -U "Mozilla/4.0 (compatible\; MSIE 7.0\; Windows NT 5.1\; .NET CLR 2.0.50727)" '\'' ' >> /home/vagrant/.profile
        echo 'alias wgie10='\''usewithtor wget -U "Mozilla/5.0 (compatible\; MSIE 10.0\; Windows NT 6.1\; WOW64; Trident/6.0)" '\'' ' >> /home/vagrant/.profile
        echo 'alias wgierss='\''usewithtor wget -U "Mozilla/4.0 (compatible\; MSIE 7.0\; Windows NT 5.1\; Trident/4.0\; InfoPath.2)" '\'' ' >> /home/vagrant/.profile
        echo wget aliases made
    fi
}


echo Installing tools...

$INST html2text whois dnsutils pdftk netcat tshark tcpdump nmap proxychains


#get a few tools from MWCB
install_mwcb() {
    if [ -f $TOOL_PATH/av_scanners/av_multiscan.py ]; then
        echo MWCB scripts already present
    else
        mkdir $TOOL_PATH/mwcb
        cd $TOOL_PATH/mwcb
        svn checkout http://malwarecookbook.googlecode.com/svn/trunk/3/
        wait
        svn checkout http://malwarecookbook.googlecode.com/svn/trunk/4/
        wait
        mv $TOOL_PATH/mwcb/3/7/av_multiscan.py $TOOL_PATH/av_scanners
        mv $TOOL_PATH/mwcb/3/8/pescanner.py $TOOL_PATH/pe_analysis
        mv $TOOL_PATH/mwcb/3/5/capabilities.yara $TOOL_PATH/yara_scripts
        mv $TOOL_PATH/mwcb/3/3/clamav_to_yara.py $TOOL_PATH/yara_scripts
        mv $TOOL_PATH/mwcb/3/6/magic.yara $TOOL_PATH/yara_scripts
        mv $TOOL_PATH/mwcb/3/4/packer.yara $TOOL_PATH/yara_scripts
        mv $TOOL_PATH/mwcb/3/4/peid_to_yara.py $TOOL_PATH/yara_scripts
        mv $TOOL_PATH/mwcb/4/12/artifactscanner.py $TOOL_PATH/av_scanners
        mv $TOOL_PATH/mwcb/4/4/avsubmit.py $TOOL_PATH/av_scanners
        mv $TOOL_PATH/mwcb/4/12/dbmgr.py $TOOL_PATH/av_scanners
        rm -rf $TOOL_PATH/mwcb
    fi

}


# install and build Jsunpack-n: includes spidermonkey, pdf.py
install_jsunpack-n() {
    if [ -f $MAIN_PATH/dev/jsunpack-n/depends/js-1.8.0-rc1-src/Linux_All_OPT.OBJ/js ]; then
        echo jsunpack-n is already installed
    else
        echo installing jsunpack-n
        cd $MAIN_PATH/dev
        svn checkout http://jsunpack-n.googlecode.com/svn/trunk/ jsunpack-n
        cd $MAIN_PATH/dev/jsunpack-n/depends
        tar xvfz pynids-0.6.1.tar.gz
        cd $MAIN_PATH/dev/jsunpack-n/depends/pynids-0.6.1/ directory
        python setup.py build
        sudo python setup.py install
        cd $MAIN_PATH/dev/jsunpack-n/depends
        tar xvfz js-1.8.0-rc1-src.tar.gz
        cd $MAIN_PATH/dev/jsunpack-n/depends/js-1.8.0-rc1-src
        make BUILD_OPT=1 -f Makefile.ref
        PATH=$PATH:$MAIN_PATH/dev/jsunpack-n/depends/js-1.8.0-rc1-src/
        if [ -f /usr/local/bin/yara ]; then
            echo yara is already installed
        else
            echo Installing yara. . .
            cd $MAIN_PATH/dev/
            git clone https://github.com/plusvic/yara.git yara
            cd $MAIN_PATH/dev/yara
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


#Install libemu - emulate shellcode
install_libemu() {
    if [ -f $UB_PATH/sctest ]; then
        echo libemu is already installed
    else
        $INST libemu2 graphviz
    fi
}




#Install Stream
install_stream() {
    if [ -f /usr/bin/stream ]; then
        echo stream is already installed
    else
        $INST imagemagick
        echo stream is installed
    fi
}



# Install pdftotext
install_pdftotext() {
    if [ -f /usr/bin/pdftotext ]; then
        echo pdftotext is already installed
    else
        $INST poppler-utils
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
#not calling from path
    fi
}


#install didierstevens suite
install_dssuite() {
    if [ -f $TOOL_PATH/DidierStevensSuite/pdf-parser.py ]; then
        echo didier stevens suite already installed
    else
        cd $TOOL_PATH
        wget https://didierstevens.com/files/software/DidierStevensSuite.zip
        unzip DidierStevensSuite.zip
        rm DidierStevensSuite.zip
        sudo chmod +x $TOOL_PATH/DidierStevensSuite/*
        sudo chmod +x $TOOL_PATH/DidierStevensSuite/Linux/*
        sudo chmod +x $TOOL_PATH/DidierStevensSuite/OSX/*
        PATH=$PATH:$TOOL_PATH/DidierStevensSuite
        PATH=$PATH:$TOOL_PATH/DidierStevensSuite/Linux
        PATH=$PATH:$TOOL_PATH/DidierStevensSuite/OSX
    fi
}

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
        sed -i -e "s:\/usr\/local\/etc\/capabilities.yara:pdf_rules.yara:g" $TOOL_PATH/pdf_analysis/AnalyzePDF/AnalyzePDF.py
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
        $INST ruby-gtk2
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
    if [ -f $TOOL_PATH/office_analysis/officeparser/officeparser.py ]; then
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
        echo No clamav signatures present
        mkdir -p $MAIN_PATH/dbfiles/clamdb
        cd $CLAMDB_PATH
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
install_mwcb
install_jsunpack-n
install_libemu
install_stream
install_pdftotext
install_pdfxray_lite
install_dssuite
#install_pdfid
install_AnalyzePDF
install_origami
#install_pdfparser
install_peepdf
install_officeparser
install_officemalscanner
install_totalhash
#install_xorstrings
#install_xorsearch
install_exescan
install_pyew
install_dnsmap
unpack_clamav


#append new paths to .bashrc
#IF YOU ARE NOT USING VAGRANT, CHANGE /home/vagrant/.bashrc TO $HOME/.bashrc
append_path() {
    cat $MAIN_PATH/.bashrc | grep -q toolbox
    if [ $? -ne 0 ]; then
        echo -e "\n" >> $MAIN_PATH/.bashrc
        echo PATH="$PATH" >> $MAIN_PATH/.bashrc
    fi
}

append_path

echo -e "Your Tools setup is complete.\nSee the install.log file in logs for details\nand check the install-errors.log for information \non any errors during installation."
