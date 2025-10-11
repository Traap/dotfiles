## ssh Hacks
DO NOT USE THIS SCRIPT WITHOUT READING IT FIRST.

YOU HAVE BEEN WARNED!

Traap


## .ssh
```bash
cd ~/.ssh
chmod 600 *
chmod 644 *.pub
```

## See what is set.
```bash
echo $HOST
echo $HOSTFILE
echo $HOSTNAME
echo $HOSTTYPE
echo $INPUTRC
echo $MACHTYPE
echo $UID
```

# When I need an ssh server.
```bash
sudo apt-get install openssh-server
sudo apt-get purge openssh-server
sudo apt-get update
```

# Start the server.
```bash
sudo service ssh --full-restart
```

# Examine file.
```bash
sudo vim /etc/ssh/sshd_config
```
