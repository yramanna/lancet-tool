#/bin/bash!

cd ~/

#golang
wget https://dl.google.com/go/go1.23.10.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.23.10.linux-amd64.tar.gz
echo -e "\nexport PATH=\$PATH:/usr/local/go/bin\nexport GOPATH=\$HOME/go\nexport PATH=\$PATH:\$GOPATH/bin" >> ~/.bashr
source ~/.bashrc

cd ~/lancet-tool

#virtualenv
sudo apt update
sudo apt install python3-pip
sudo apt install python3-virtualenv

#coordinator
cd coordinator
go mod init coordinator
go mod tidy
go get golang.org/x/crypto/ssh
go build
make coordinator

#agent
cd ..
sudo apt install libssl-dev
sudo apt install cmake
make agents

#manager
make manager

ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -N ""
sudo apt install python-wheel-common
cd ~/.ssh
