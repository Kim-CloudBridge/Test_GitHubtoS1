#!/bin/bash
marker_file="/var/log/setup_completed.marker"
if [ -f "$marker_file" ]; then
    echo "Setup already completed. Exiting."
    exit 0
fi
sudo apt-get update -y
sleep 5
echo "apt-get update exit-log: " $?
sudo apt-get upgrade -y 
sleep 5
echo "apt-get upgrade exit-log: " $?
sudo curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
echo "download aws-cli exit-log: " $?
sudo apt-get install unzip -y
echo "download unzip exit-log: " $?
sudo unzip awscliv2.zip
echo "unzip aws-cli exit-log: " $?
sudo ./aws/install
echo "install aws-cli exit-log: " $?
aws --version
sudo hostnamectl set-hostname ${hostname}.${domain_name}
echo "hostname rename to ${hostname} exit-log: " $?
echo "[libdefaults]" | sudo tee /etc/krb5.conf
echo "default_realm = ${domain_name}" | sudo tee -a /etc/krb5.conf
echo "rdns = false" | sudo tee -a /etc/krb5.conf
sudo DEBIAN_FRONTEND=noninteractive apt-get -y install sssd realmd krb5-user samba-common packagekit adcli libpam-runtime
echo "apt-get install ad components exit-log: " $?
sudo apt-get install -y jq
echo "apt-get install jq exit-log: " $?
username=$(aws secretsmanager get-secret-value --secret-id ${secret_id} | jq --raw-output '.SecretString' | jq -r .username)
password=$(aws secretsmanager get-secret-value --secret-id ${secret_id} | jq --raw-output '.SecretString' | jq -r .password)
sudo echo $password | kinit $username
sudo echo $password | sudo realm join -U $username ${domain_name} --verbose --computer-ou='OU=client0123Test,OU=lscloud,DC=lscloud,DC=systems'
echo "join ${hostname} in ${domain_name} domain exit-log: " $?
echo "session required pam_mkhomedir.so" | sudo tee -a /etc/pam.d/common-session
echo '%AWS\ Delegated\ Server\ Administrators@LSCLOUD.SYSTEMS ALL=(ALL:ALL) ALL' | sudo tee -a /etc/sudoers >/dev/null
realm permit -g AWS\ Delegated\ Server\ Administrators@LSCLOUD.SYSTEMS
echo "permit exit-log: " $?
sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
sudo service sshd restart
sudo apt-get install openjdk-11-jdk -y
echo "apt-get install openjdk-11-jdk exit-log: " $?
sudo curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee   /usr/share/keyrings/jenkins-keyring.asc > /dev/null
sudo echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]   https://pkg.jenkins.io/debian-stable binary/ | sudo tee   /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update -y
echo "apt-get update exit-log: " $?
sudo apt-get install jenkins -y
echo "apt-get install jenkins exit-log: " $?
sudo systemctl start jenkins
sudo systemctl enable jenkins
sudo touch "$marker_file"
