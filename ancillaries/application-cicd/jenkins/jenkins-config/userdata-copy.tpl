#!/bin/bash
sudo apt-get update
echo "apt-get update exit-log: " $?
#sudo apt-get -y upgrade
#echo "apt-get upgrade exit-log: " $?
sudo curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
echo "download aws-cli exit-log: " $?
sudo apt-get install unzip -y
echo "download unzip exit-log: " $?
sudo unzip awscliv2.zip
echo "unzip aws-cli exit-log: " $?
sudo ./aws/install
echo "install aws-cli exit-log: " $?
aws --version
sudo hostnamectl set-hostname ${hostname}
echo "hostname rename to ${hostname} exit-log: " $?

sudo apt-get install -y jq
echo "apt-get install jq exit-log: " $?
# password=$(aws secretsmanager get-secret-value --secret-id lscloud.systems/admin | jq --raw-output '.SecretString' | jq -r .password)