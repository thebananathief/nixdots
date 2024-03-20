set windows-shell := ['pwsh.exe', '-NoLogo', '-Command']

# <leader>tj
alias run := switch
# <leader>tk
alias run2 := rswitch

# list commands
[private]
@default:
  just --list

# links the flake.nix to one in /etc/nixos, then rebuild switches
[linux]
install:
  sudo ln -sv '/home/cameron/github/nixdots/flake.nix' '/etc/nixos/flake.nix'
  ./nixos-rebuild switch

[linux]
up:
  -git add --all
  -git commit -m "$(date '+%Y-%m-%d %H:%M:%S %Z')"
  -git push
  
# remotely links the flake.nix to one in /etc/nixos, then rebuild switches | MUST SPECIFY HOSTNAME TO SSH TO
[windows]
rinstall host:
  ssh {{host}} -- ~/github/nixdots/nixos-rebuild switch
# remotely links the flake.nix to one in /etc/nixos, then rebuild switches | MUST SPECIFY HOSTNAME TO SSH TO
[linux]
rinstall host:
  ssh {{host}} -- ~/github/nixdots/nixos-rebuild switch

alias s := switch
# git commit all and push, then remotely rebuild switch talos
[windows]
switch *args:
  just rswitch {{args}}
# git commit all and push, then rebuild switch
[linux]
switch *args:
  -git add --all
  -git commit -m "$(date '+%Y-%m-%d %H:%M:%S %Z')"
  -git push
  ./nixos-rebuild switch {{args}}

alias rs := rswitch
# git commit all and push, then remotely rebuild switch talos
[windows]
rswitch *args:
  -git add --all
  -git commit -m "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') EST"
  -git push
  ssh talos -- ~/github/nixdots/nixos-rebuild switch {{args}}
# git commit all and push, then remotely rebuild switch talos
[linux]
rswitch *args:
  -git add --all
  -git commit -m "$(date '+%Y-%m-%d %H:%M:%S %Z')"
  -git push
  ssh talos -- ~/github/nixdots/nixos-rebuild switch {{args}}

# updates the flake's package versions, so that we pull new package updates (is that wrong?)
[linux]
update:
  nix flake update
