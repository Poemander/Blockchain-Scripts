# Setting up a Cosmos SDK Node and what could go wrong
**Installing some basic software:**

First we need to make sure to have the basic software installed, in the case of Cosmos SDK we need make, curl, gcc, go otherwise we’ll run into ‘command not found’ errors or have trouble downloading the required programs. We also need to make sure there’s no previous version of Go installed.

Login as root and execute the following commands one by one:

```
apt-get update -y
apt-get upgrade -y
apt-get install -y gcc
apt-get install -y make
apt-get install -y curl
apt-get install -y git
rm -r /usr/local/go
rm -r home/<your username>/go
rm -r ~/go
```

Now when installing GO we need to make sure we install the right version, the documentation of the network you want to set up.
In this case we need Golang version 1.17 or higher.
ATTENTION:
If you install Go from the Apt repository you’ll most likely end up with an earlier version like 1.13 so best is to just get it from this link 
https://dl.google.com/go/go1.17.2.linux-amd64.tar.gz 

So let's do this with the following command:

```
curl -O https://dl.google.com/go/go1.17.2.linux-amd64.tar.gz
```

It will download into the directory you’re currently in, so don’t move into a different directory, otherwise the following commands will not work. 
Let’s unpack it, put it into /usr/local and remove the downloaded file

```
tar -xvf go1.17.2.linux-amd64.tar.gz
mv go /usr/local
rm go1.17.2.linux-amd64.tar.gz
```

After this another very common mistake can occur, we need to tell the system where to find Go so it can be found by any program that wants to use it. In order to achieve this we need to add the path to /etc/profile and the .profile in your home directory.

```
echo "export PATH=$PATH:/usr/local/go/bin" >> /etc/profile
echo "export PATH=$PATH:/usr/local/go/bin" >> ~/.profile
```

In order for the system to know you changes something in those files we need to reload them

```
source /etc/proflile
source .profile
```

To confirm everything is correct we execute the following, if it doesn’t return an error, everything is fine

```
export PATH=$PATH:$(go env GOPATH)/bin
```

Now Go should be available, let’s check the correct version 

```
go version
```
output:
go version go1.17.2 

**Installing the Node client:**

First thing is to find the Github repository for the network you want to run the node on. You can google it or search it on the Github page.
Here’s some examples:
Evoms - https://github.com/tharsis/evmos.git
Cosmos (gaia 3.0 Stargate Testnet)  https://github.com/cosmos/gaia/tree/cosmoshub-test-stargate

There check the README.md for any updates or special requirements.
It should also show a guide how to install the Node.
In the example of Evmos, installation would be done like this, first download the github repository and move into the evmos folder.
From there we can just have ‘make’ do the installation:

```
git clone https://github.com/tharsis/evmos.git
cd evmos
make install
```

You’ll see go downloading everything, after you can confirm everything worked by checking the daemon version with the <daemon-name> version command.

```
evmosd version
```

If this tells you ‘command not found’ which is happening a lot depending on the steps you took before, we need to find it.
We can do that with the whereis command:

```
whereis evmosd
```

It’ll tell you the directory where the evmosd binary was installed.
Now we have to move it to where we want it to be.
If you have created a Node user it can occur that Go puts the daemon into the root’s home instead of the user's home directory.
So first we find out where we are with the ```pwd``` command, it’ll output your current working directory, for example /home/<your username>
Now we can just move the folder with the binary to where we are and want it to be:

```
mv <output-of-whereis-command> <output-of-pwd-command>
```

Now let’s try again with evmosd version which should now show the daemon version. 
Before we can start the daemon we usually need to change some settings in the Node’s client and config files

#Run a Evmos Node and set up Validator 
**Configure the Node:

After the Node is installed we need to configure it to run on the new arsia_mons Testnet.
First we change the directory to the node client’s setup files:

```
cd .evmosd/config
```

There we have some basic config files app.toml client.toml and config.toml
First we check the client.toml with ```nano client.toml``` and change some values to the following:

```
############################################################################
### Client Configuration ###

############################################################################

# The network chain ID

chain-id = "evmos_9000-1"

# The keyring's backend, where the keys are stored (os|file|kwallet|pass|test|memory)

keyring-backend = "os"

# CLI output format (text|json)

output = "text"

# <host>:<port> to Tendermint RPC interface for this chain

node = "tcp://localhost:26657"

# Transaction broadcasting mode (sync|async|block)

broadcast-mode = "sync"
```

After, we go into config.toml with ```nano config.toml``` and add some seeds, scroll down until you see ‘seeds’ and add 3 seeds. 
You can find them in the link: https://github.com/tharsis/testnets/tree/main/arsia_mons

seeds='<seed1,seed2,seed3>'



Now we can finally start the Node and let it sync. 
There’s different ways to do this, either running it in background with the nohup command or 
creating a service file in order to run it on startup and restart it in case of an error or connection loss.
Let’s first use nohup to see if the Node starts syncing:

```
nohup evmosd start &
```

After use the jobs command to see if it’s active

```
jobs
```

This should show something like this 
[1]+  Done                    nohup evmosd start

Now you can check the logs with

```
tail -f nohup.out
```

We should see some blocks coming in after a few minutes, also check the status from the client:

```
evmosd status 
```

We need to check the latest_block_height is increasing and "catching_up":true if it’s still syncing, or "catching_up":false if it finished. 
Run it multiple times in order to see changes in block_height
As soon as this is finished we can stop the node, run top and find the PID for evmosd then just ```kill <PID>``` set up the validator, first we need to create a Key.

```
evmosd init <your_custom_moniker> --chain-id evmos_9000-1
evmosd keys add <choose-a-keyname>
```

We need to set a keyring password and save the mnemonic, if you lose it you can’t access the funds in case the machine crashes or the key file is deleted.

Get the genesis.json from Github and check it:

```
curl https://raw.githubusercontent.com/tharsis/testnets/main/arsia_mons/genesis.json > ~/.evmosd/config/genesis.json
evmosd validate genesis
```

Now get some Testnet tokens and run the Validator create command:

```
evmosd tx staking create-validator --amount=1000000000000aphoton --pubkey=$(your-public-key) --moniker=<your-custom-moniker> --chain-id=evmos_9000-1 --commission-rate="0.10" --commission-max-rate="0.20" --commission-max-change-rate="0.01" --min-self-delegation="1000000" --gas="auto" --gas-prices="0.025aphoton" --from=<key_name>
```

Restart the Node with the nohup command from above and you should have a Validator running :)
If everything works fine you can create a service file so it restarts itself in case of connection loss or some little bug.
```nano /etc/systemd/system/evmosd.service```

```
[Unit]
Description=<daemon-name> Node
After=network-online.target

[Service]
Type=simple
User=<username>
ExecStart=<path-to-daemon-binary> start
Restart=on-failure
RestartSec=6
LimitNOFILE=4096

[Install]
WantedBy=multi-user.target
```

