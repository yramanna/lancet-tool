#/bin/bash!

#virtualenv
sudo apt update
sudo apt install python3-pip
sudo apt install python3-virtualenv

#wheel
sudo apt install python-wheel-common

#ssh
ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -N ""
cat ~/.ssh/id_rsa.pub
