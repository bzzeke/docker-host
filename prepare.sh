#!/bin/bash

USR=zeke
USRHOME="/home/$USR"

echo "Adding user $USR..."

adduser --gecos "" $USR
usermod -aG sudo $USR

sed -i 's/PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config 
sed -i 's/PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config 
sed -i 's/\%sudo\tALL=(ALL:ALL) ALL/\%sudo\tALL=(ALL:ALL) NOPASSWD:ALL/' /etc/sudoers

mkdir $USRHOME/.ssh
chmod 700 $USRHOME/.ssh

echo "Paste SSH public key"
read PUBLIC_KEY

echo $PUBLIC_KEY > $USRHOME/.ssh/authorized_keys
chmod 600 $USRHOME/.ssh/authorized_keys
chown -R $USR:$USR $USRHOME/.ssh

service sshd restart
apt-get update
apt-get remove docker docker-engine docker.io
apt-get -y install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt-get update
apt-get -y install docker-ce docker-compose
apt-get -y upgrade

usermod -a -G docker $USR
