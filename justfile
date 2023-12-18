set windows-shell := ['pwsh.exe', '-NoLogo', '-Command']

# <leader>tj
alias run := rswitch
 
# list commands
[private]
@default:
  just --list

[linux]
install: 
  sudo ln -sv '/home/cameron/github/nixdots/flake.nix' '/etc/nixos/flake.nix'
  ./nixos-rebuild

[windows]
rinstall host:
  ssh talos -- ~/github/nixdots/nixos-rebuild switch
[linux]
rinstall host:
  ssh talos -- ~/github/nixdots/nixos-rebuild switch

alias s := switch
[linux]
switch:
  -git add --all && git commit -m "$(date '+%Y-%m-%d %H:%M:%S %Z')" ; git push
  ./nixos-rebuild switch

alias rs := rswitch
[windows]
rswitch:
  -git add --all && git commit -m "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') EST" ; git push
  ssh talos -- ~/github/nixdots/nixos-rebuild switch
[linux]
rswitch:
  -git add --all && git commit -m "$(date '+%Y-%m-%d %H:%M:%S %Z')" ; git push
  ssh talos -- ~/github/nixdots/nixos-rebuild switch
