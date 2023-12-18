set windows-shell := ['pwsh.exe', '-NoLogo', '-Command']

# list commands
[private]
@default:
  just --list

alias run := switch
alias r := run

install:
  ./quickbuild

rinstall host:
  ssh talos -- ./github/nixdots/quickbuild

switch:
  -git add --all && git commit -m "$(date '+%Y-%m-%d %H:%M:%S %Z')" && git push

rswitch:
  -git add --all && git commit -m "$(date '+%Y-%m-%d %H:%M:%S %Z')" && git push
  ssh talos -- ./github/nixdots/quickbuild
