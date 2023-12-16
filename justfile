set windows-shell := ['pwsh.exe', '-NoLogo', '-Command']

# list commands
[private]
@default:
  just --list

alias n := nix
nix:
  -git add --all && git commit -m '$(date '+%Y-%m-%d %H:%M:%S %Z')' && git push
  ssh talos -- ./github/nixdots/quickbuild
