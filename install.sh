#!/bin/bash

rm -rf /etc/yum.repos.d/CentOS-Base.repo

# Define the file path
REPO_FILE="/etc/yum.repos.d/CentOS-Base.repo"

# Create the file and add the content
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

# Print a message indicating success
echo "Repo file created at $REPO_FILE"

yum clean all
yum makecache
yum repolist

yum install wget nano -y

curl -O https://vestacp.com/pub/vst-install.sh

bash vst-install.sh
