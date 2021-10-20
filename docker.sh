#! /bin/bash

# Install docker from repository
# Check root
if [ "$USER" != "root" ]; then
        echo "You must be logged in as root to use this installer!"
        exit 0;
fi
sleep 2

# Set up repository
apt-get update -y
apt-get install -y apt-transport-https
apt-get install -y ca-certificates
apt-get install -y curl
apt-get install -y gnupg
apt-get install -y lsb-release
sleep 2

# Add GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Use the following command to set up the stable repository.
# To add the nightly or test repository, add the word nightly or test (or both) after the word stable in the commands below.

echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker Engine
apt-get update -y
apt-get install -y docker-ce
apt-get install -y docker-ce-cli
apt-get install -y containerd.io
sleep 5

# Verify that Docker Engine is installed correctly by running the hello-world image.
echo "running 'hello world' image to verify correct installation"
docker run hello-world
