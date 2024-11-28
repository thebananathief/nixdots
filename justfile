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
rswitch host *args:
  ./git-sync
  ssh {{host}} -- ~/github/nixdots/nixos-rebuild switch {{args}}



# links the flake.nix to one in /etc/nixos, then rebuild switches
[windows]
install host:
  ssh {{host}} -- sudo ln -sv '/etc/nixos/nixdots/flake.nix' '/etc/nixos/flake.nix'
  ssh {{host}} -- ./nixos-rebuild switch
[linux]
install:
  sudo ln -sv '/etc/nixos/nixdots/flake.nix' '/etc/nixos/flake.nix'
  ./nixos-rebuild switch



# Check all the flake's outputs for valid Nix expressions, then sync git
alias c := check
check:
  nix flake check --extra-experimental-features nix-command --extra-experimental-features flakes --offline
  ./git-sync

# updates the flake's package versions, so that we pull new package updates (is that wrong?)
[linux]
update:
  nix flake update
