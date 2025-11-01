
# New NixOS systems

- add config under hosts/
- on the host, get nixos running, then:
```sh
ssh-keygen
nix-shell -p git ssh-to-age sops
{ cat $HOME/.ssh/id_ed25519.pub; cat $HOME/.ssh/id_ed25519.pub | ssh-to-age; } | curl --data-binary @- https://0x0.st
```
add ssh key to [https://code.talos.home.arpa/user/settings/keys]
add age key to [.sops.yaml] in this repository


This next block will update encryption for the secrets using the new public keys. But it needs to be ran from an already authorized public key holder.
```sh
sops updatekeys secrets.yml
./git-sync
```


```sh
mkdir $HOME/code
git clone ssh://git@talos:2222/cameron/nixdots.git



mkdir -p $HOME/.config/sops/age
ssh-to-age -private-key -i $HOME/.ssh/id_ed25519 -o $HOME/.config/sops/age/keys.txt
```

`curl -F "file=@configuration.nix" https://0x0.st`

and export / push a hardware config to the same host config
- git config



# SOPS

sops only deals in GPG or AGE keys, it won't automatically convert your 
SSH keys for you. So you're manually mimicking your SSH key setup but
converted into AGE keys for sops.

TALOS = Converted its SSH host keys at /etc/ssh
THOTH = Converted its SSH keys created in $HOME/.ssh

1. Install ssh-to-age
  `go install github.com/Mic92/ssh-to-age/cmd/ssh-to-age@latest`
  `nix-shell -p ssh-to-age`
   
2. Create an private age key from a private SSH key and stow it at .config/sops/age
  `ssh-to-age -private-key -i $HOME/.ssh/id_ed25519 -o $HOME\AppData\Roaming\sops\age\keys.txt`
  `ssh-to-age -private-key -i $HOME/.ssh/id_ed25519 -o $HOME/.config/sops/age/keys.txt`
  
2. Create a public age key from an SSH public key
  `cat /etc/ssh/ssh_host_ed25519.pub | ssh-to-age`
  `ssh-to-age -private-key -i /etc/ssh/ssh_host_ed25519_key -o $HOME\.config\sops\age\keys.txt`
Get remote host key (public)
  `ssh-keyscan -t ed25519 192.168.0.6 | ssh-to-age`

Once you set up a private key in .config\sops\age, and 
put a public key at the top of this file, you can run
sops updatekeys <file>
to update the encryption for the secrets using the new public keys.
HOWEVER, this needs to be ran from an already authorized master...


# Deploying new config to remote system
```
nixos-rebuild --target-host <sshUser>@<remoteSystem> --flake .#<remoteSystem> --sudo switch
```