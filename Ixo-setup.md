# IXO (Pandora4-Testnet):
**First Steps:
These steps are to be run once logged in as root user. 
Use the following command to access the root user (skip if already root).**

`sudo -i`


Install git to clone this repository on the VM
```
apt-get install git
git clone https://github.com/ixofoundation/genesis.git && cd genesis && git checkout master
```

Access the pandora-4 folder and run the installation script:
```
cd pandora-4
bash InstallPandora.sh
```
**Follow the configuration steps as the node is installed:**

Switch to the new IXO user:
`su ixo`

Access the node's configuration file and add Simply VC's Pandora-4 peers:
`nano $HOME/.ixod/config/config.toml`

Required: Find the persistent_peers parameter and add the following peers to its value. The default value of this entry should be "". This must be changed as follows:

`persistent_peers ='3e6c0845dadd4cd3702d11185ff242639cf77ab9@46.166.138.209:26656,c0b2d9f8380313f0e2756dc187a96b7c65cae49b@80.64.208.22:26656'`

Required: Enable the peer exchange reactor pex, which enables nodes to share each other's peers. This ensures your node discovers other peers on the network. The default value of this entry should be "true", but you should confirm that this is the case:

`pex = true`

Optional: The node's moniker can be changed from Pandora node to anything of your liking. The default value of the moniker entry is "Pandora node". This can be changed as desired.

Exit back to the root user and start the IXO blockchain daemon:

`exit`


`systemctl start ixod.service`

Check the node's logs as the root user

Tail the node's logs using the following:

`journalctl -f -u ixod.service`



