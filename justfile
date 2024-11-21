set windows-shell := ['pwsh.exe', '-NoLogo', '-Command']

# <leader>tj
alias run := switch
# <leader>tk
alias run2 := rswitch

# list commands
[private]
@default:
  just --list



alias s := sync
[windows]
sync:
  ./git-sync.ps1
[linux]
sync:
  ./git-sync



# remotely links the flake.nix to one in /etc/nixos, then rebuild switches | MUST SPECIFY HOSTNAME TO SSH TO
[windows]
rinstall host:
  ssh {{host}} -- ~/github/nixdots/nixos-rebuild switch
[linux]
rinstall host:
  ssh {{host}} -- ~/github/nixdots/nixos-rebuild switch



alias sw := switch
# git commit all and push, then remotely rebuild switch talos
[windows]
switch *args:
  just rswitch {{args}}
[linux]
switch *args:
  ./nixos-rebuild switch {{args}}



alias rs := rswitch
# git commit all and push, then remotely rebuild switch talos
[windows]
rswitch host *args:
  ./git-sync.ps1
  ssh {{host}} -- ~/github/nixdots/nixos-rebuild switch {{args}}
[linux]
rswitch *args:
  ./git-sync
  ssh talos -- ~/github/nixdots/nixos-rebuild switch {{args}}



# links the flake.nix to one in /etc/nixos, then rebuild switches
[windows]
install host:
  ssh {{host}} -- sudo ln -sv '/etc/nixos/nixdots/flake.nix' '/etc/nixos/flake.nix'
  ssh {{host}} -- ./nixos-rebuild switch
[linux]
install:
  sudo ln -sv '/etc/nixos/nixdots/flake.nix' '/etc/nixos/flake.nix'
  ./nixos-rebuild switch



# updates the flake's package versions, so that we pull new package updates (is that wrong?)
[linux]
update:
  nix flake update

# syntax-checks the flake
[linux]
syntax:
  nix-instantiate '<nixpkgs/nixos>' -A system
