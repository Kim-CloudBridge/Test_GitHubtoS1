#!/bin/bash
sudo apt-get update
echo "apt-get update exit: " $?
sudo apt-get install openjdk-11-jdk -y
echo "apt-get install openjdk-11-jdk: " $?
sudo curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee   /usr/share/keyrings/jenkins-keyring.asc > /dev/null
sudo echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]   https://pkg.jenkins.io/debian-stable binary/ | sudo tee   /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update -y
echo "apt-get update exit: " $?
sudo apt-get install jenkins -y
echo "apt-get update exit: " $?
sudo systemctl start jenkins
sudo systemctl enable jenkins