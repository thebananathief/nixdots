set windows-shell := ['pwsh.exe', '-NoLogo', '-Command']

# <leader>tj
alias run := switch
# <leader>tk
alias run2 := rswitch

# list commands
[private]
@default:
  just --list



alias sw := switch
# git commit all and push, then remotely rebuild switch talos
switch *args:
  ./nixos-rebuild switch {{args}}



# links the flake.nix to one in /etc/nixos, then rebuild switches
install:
  sudo ln -sv '/etc/nixos/nixdots/flake.nix' '/etc/nixos/flake.nix'
  ./nixos-rebuild switch



# Check all the flake's outputs for valid Nix expressions, then sync git
alias c := check
check:
  nix flake check --extra-experimental-features nix-command --extra-experimental-features flakes --offline
  ./git-sync

# updates the flake's package versions, so that we pull new package updates (is that wrong?)
update:
  nix flake update
