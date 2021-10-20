#! /bin/bash

cd ~
echo “create node user”
read USER
adduser $USER --disabled-login

GOFILENAME="go1.17.2.linux-amd64.tar.gz"
GODOWNLOADLINK="https://dl.google.com/go/$GOFILENAME"

echo "Installing make curl gcc and removing go if present"
sleep 2

apt-get update -y
apt-get upgrade -y
apt-get install -y make gcc curl
rm -r /usr/local/go
rm -r home/$USER/go
rm -r ~/go

curl -O $GODOWNLOADLINK
sleep 2
tar -xvf $HOME/$GOFILENAME
rm $HOME/$GOFILENAME
mv $HOME/go /usr/local
sleep 3
echo "export PATH=$PATH:/usr/local/go/bin" >> /etc/profile
echo "export PATH=$PATH:/usr/local/go/bin" >> ~/.profile
sleep 3
source ~/.profile
sleep 3
export PATH=$PATH:$(go env GOPATH)/bin
sleep 3
source /etc/profile
sleep 3
go version
sleep 4
echo "GO installed and added to PATH (.profile), you can continue installing the node now :)"
