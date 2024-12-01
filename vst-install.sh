###################################
### INSTALL VESTACP ON CENTOS7 ####
###################################
#!/bin/bash

# Remove the current REPO
rm -rf /etc/yum.repos.d/CentOS-Base.repo

# Define the file path
REPO_FILE="/etc/yum.repos.d/CentOS-Base.repo"

# Create the new REPO and add the content
cat <<EOF > "$REPO_FILE"
[base]
name=CentOS-7 - Base
baseurl=http://vault.centos.org/7.9.2009/os/x86_64/
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7

[updates]
name=CentOS-7 - Updates
baseurl=http://vault.centos.org/7.9.2009/updates/x86_64/
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7

[extras]
name=CentOS-7 - Extras
baseurl=http://vault.centos.org/7.9.2009/extras/x86_64/
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7

[centosplus]
name=CentOS-7 - Plus
baseurl=http://vault.centos.org/7.9.2009/centosplus/x86_64/
gpgcheck=1
enabled=0
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7
EOF

echo "Repo file created at $REPO_FILE"

yum clean all
yum makecache
yum repolist

#yum install wget nano -y
#curl -O https://vestacp.com/pub/vst-install.sh
#bash vst-install.sh


################################################################################################################################################
#### DOWNLOAD AND INSTALL VESTACP !!! #### --------------------------------------------------------------------------------------------- #######
################################################################################################################################################

################################################################################################################################################
#### INSTALL SOME DEPENDENCIES:) #### -------------------------------------------------------------------------------------------------- #######
################################################################################################################################################

yum -y install epel-release
yum -y install curl 
yum -y install nano 
yum -y install wget 
yum -y install git 
yum -y install jq
yum -y install mlocate
updatedb


curl -O http://vestacp.com/pub/vst-install.sh

SERVER_IP=$(hostname -I | awk '{print $1}')
DOMAIN_NAME=myworld.com
ADMIN_PASS="Money22"
ADMIN_EMAIL="info@ssdextreme.nl"

echo "y" | bash vst-install.sh --hostname "${SERVER_IP}.${DOMAIN_NAME}" --email "${ADMIN_EMAIL}" --password "${ADMIN_PASS}" --nginx yes --apache yes --phpfpm no --named yes --remi yes --vsftpd yes --proftpd no --iptables yes --fail2ban yes --quota no --exim yes --dovecot yes --spamassassin no --clamav no --softaculous no --mysql yes --postgresql no 

sudo hostnamectl set-hostname ${SERVER_IP}.${DOMAIN_NAME}

((COMPLETED_STEPS++))
send_progress_message "$((COMPLETED_STEPS * 100 / TOTAL_STEPS))"

#### FINAL MESSAGE 100% SETUP COMPLETE!!! ####
((COMPLETED_STEPS++))
send_progress_message "100"

SERVER_IP=$(hostname -I | awk '{print $1}')

#### SEND FINAL INSTALLATION MESSAGE TO TG ####
MESSAGE="VestaCP installation completed successfully!!!
You can access the control panel at:

https://${SERVER_IP}:8083

username: admin
password: Money22"

curl -s -X POST "${TELEGRAM_API}" -d "chat_id=${CHAT_ID}" -d "text=${MESSAGE}"

################################################################################################################################################
#### DOWNLOAD CUSTOM INDEX.PHP FOR MAIN IP  #### --------------------------------------------------------------------------------------- #######
################################################################################################################################################

SERVER_IP=$(hostname -I | awk '{print $1}')

#### DELETE INDEX.HTML AND ROBOTS AND WGET INDEX.PHP ####
rm -rf /home/admin/web/${SERVER_IP}.${DOMAIN_NAME}/public_html/robots.txt
rm -rf /home/admin/web/${SERVER_IP}.${DOMAIN_NAME}/public_html/index.html

wget https://raw.githubusercontent.com/ji4a/php/main/v_index.php -O /home/admin/web/${SERVER_IP}.${DOMAIN_NAME}/public_html/index.php

#### ADD FIREWALL PORT 4477 and 5901 FOR VNC AND CHANGE DATE TO PARIS :)####
/usr/local/vesta/bin/v-add-firewall-rule ACCEPT 0.0.0.0/0 4477 TCP
/usr/local/vesta/bin/v-add-firewall-rule ACCEPT 0.0.0.0/0 5901 TCP

/usr/local/vesta/bin/v-change-sys-timezone Europe/Paris
