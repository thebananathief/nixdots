
Setup NixOS for a flake configuration
Run as root?
```sh
su -
pushd /etc/nixos
git clone <flake> nixdots
pushd nixdots
chmod u+x nixos-rebuild git-sync
ln -sv /etc/nixos/nixdots/flake.nix /etc/nixos/flake.nix
./nixos-rebuild switch
```