#!/bin/bash
echo "Installation Pack By Optimashell inc"
# go to root
cd

# set time GMT +7
ln -fs /usr/share/zoneinfo/Asia/Jakarta /etc/localtime

# set locale
sed -i 's/AcceptEnv/#AcceptEnv/g' /etc/ssh/sshd_config
service sshd restart

# disable ipv6
echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6
sed -i '$ i\echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6' /etc/rc.local
sed -i '$ i\echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6' /etc/rc.d/rc.local

# exim off
service exim stop
chkconfig exim off

# install wget and curl
yum -y install wget curl;
yum -y install nano

# setting repo
wget http://dl.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm
wget http://rpms.famillecollet.com/enterprise/remi-release-6.rpm
rpm -Uvh epel-release-6-8.noarch.rpm
rpm -Uvh remi-release-6.rpm
rm -f *.rpm

# remove unused
yum -y remove sendmail;
yum -y remove cyrus-sasl

# update
yum -y update

# install essential package
yum -y install iftop htop nmap bc nethogs openvpn vnstat ngrep mtr git zsh mrtg unrar rsyslog rkhunter mrtg net-snmp net-snmp-utils expect nano bind-utils
yum -y groupinstall 'Development Tools'

#install Additonal Software

yum -y install firefox
yum -y install java-1.7.0-openjdk java-1.7.0-openjdk-devel
yum -y install httpd

#install Webuzo
wget -O webuzo.sh "http://files.webuzo.com/install.sh"
chmod 0755 webuzo.sh
sh webuzo.sh

# setting vnstat
vnstat -u -i venet0
echo "MAILTO=root" > /etc/cron.d/vnstat
echo "*/5 * * * * root /usr/sbin/vnstat.cron" >> /etc/cron.d/vnstat
sed -i 's/eth0/venet0/g' /etc/sysconfig/vnstat
service vnstat restart
chkconfig vnstat on

#Licenci
mkdir protect
cd protect
#wget -O licenci.txt "http//banner"
cd

# setting port ssh
echo "Port 143" >> /etc/ssh/sshd_config
echo "Port  22" >> /etc/ssh/sshd_config
echo "Banner  /protec/licenci.txt" >> /etc/ssh/sshd_config
service sshd restart
chkconfig sshd on

# install badvpn
wget -O /usr/bin/badvpn-udpgw "http://162.220.10.87/script/conf/badvpn-udpgw"
sed -i '$ i\screen -AmdS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300' /etc/rc.local
sed -i '$ i\screen -AmdS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300' /etc/rc.d/rc.local
chmod +x /usr/bin/badvpn-udpgw
screen -AmdS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300

# install dropbear

wget http://162.220.10.87/script/dropbear-2014.63-1.el6.i686.rpm
wget http://162.220.10.87/script/libtommath-0.42.0-3.el6.i686.rpm
rpm -Uvh libtommath*.rpm
wget http://162.220.10.87/script/libtomcrypt-1.17-21.el6.i686.rpm
rpm -Uvh libtomcrypt*.rpm
rpm -Uvh dropbear-2014.63-1.el6.i686.rpm
rm -f *.rpm
echo "OPTIONS=\"-p 109 -p 110 -p 443 -b/protec/licenci.txt\"" > /etc/sysconfig/dropbear
echo "/bin/false" >> /etc/shells
cd
service dropbear restart
chkconfig dropbear on


# install vnstat gui
#mkdir /var/www/html/vnstat
#cd /var/www/html/vnstat
#wget http://www.sqweek.com/sqweek/files/vnstat_php_frontend-1.5.1.tar.gz
#tar xf vnstat_php_frontend-1.5.1.tar.gz
#rm -y vnstat_php_frontend-1.5.1.tar.gz
#mv /var/www/html/vnstat/vnstat_php_frontend-1.5.1/* /var/www/html/vnstat
#cd /var/www/html/vnstat
#sed -i 's/eth0/venet0/g' config.php
#sed -i "s/\$iface_list = array('venet0', 'sixxs');/\$iface_list = array('venet0');/g" config.php
#sed -i "s/\$language = 'nl';/\$language = 'en';/g" config.php
#sed -i 's/Internal/Internet/g' config.php
#sed -i '/SixXS IPv6/d' config.php
cd

# install fail2ban
yum -y install fail2ban
service fail2ban restart
chkconfig fail2ban on

# install webmin
cd
wget http://sourceforge.net/projects/webadmin/files/webmin/1.680/webmin-1.680-1.noarch.rpm
rpm -i webmin-1.680-1.noarch.rpm;
rm webmin-1.680-1.noarch.rpm
service webmin restart
chkconfig webmin on

# downlaod script
cd
wget -O speedtest_cli.py "https://raw.github.com/sivel/speedtest-cli/master/speedtest_cli.py"
chmod +x speedtest_cli.py

# monitoring user 
#cd /usr/sbin/
#wget http://drop.groundworlds.tk/file/usermon
#chmod 755 usermon
#wget http://drop.groundworlds.tk/file/userlmt
#chmod 755 userlmt
cd
# Install Desktop centos
yum -y update
yum -y install tigervnc-server
yum -y groupinstall desktop
echo 'VNCSERVERS="1:root"' >> /etc/sysconfig/vncservers
echo 'VNCSERVERARGS[1]="-geometry 800x600"' >> /etc/sysconfig/vncservers
cd

# Install Transmission Daemon
cd /etc/yum.repos.d/
wget http://geekery.altervista.org/geekery-el6-i686.repo
yum -y install transmission transmission-daemon
yum -y install transmission*
service transmission-daemon start
service transmission-daemon stop
rm -f /var/lib/transmission/settings.json
cd /var/lib/transmission/
wget -O settings.json "hhtp://settingjason"
cd
mkdir /var/www/html/download
chown -R transmission.transmission /var/www/html/download
chmod g+w /var/www/html/download
chmod +x /var/www/html/download

# Install Flash PlugIns
rpm -ivh http://linuxdownload.adobe.com/adobe-release/adobe-release-i386-1.0-1.noarch.rpm
rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-adobe-linux
yum check-update
yum -y update
yum -y install flash-plugin nspluginwrapper alsa-plugins-pulseaudio libcurl


# info
cd
rm -f install-32.sh
clear
echo "Optimashelll | Auto Script Installer"
echo "=============================================="
echo ""
echo "Services"
echo "----------"
echo "Dropbear Port 443"
echo "Openssh  Port 143"
echo "Badvpn UDPGW"
echo "Webmin   : http://$MYIP:10000/"
echo "vnstat   : http://$MYIP/vnstat/"
echo "Timezone : Asia/Jakarta"
echo "IPv6     : [off]"
echo "exim     : [off]"
echo "----------"
echo "scripting"
echo "OpenSSH Monitoring : usermon -op"
echo "Dropbear Monitoring : usermon -dp"
echo "VPN PPTP Monitoring : last | grep ppp | grep still"
echo "./speedtest_cli.py"
echo ""
echo "REBOOT VPS ANDA !"
echo " reboot -r now"
echo "==============================================="
