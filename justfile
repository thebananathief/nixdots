set windows-shell := ['pwsh.exe', '-NoLogo', '-Command']

# list commands
[private]
@default:
  just --list

alias n := nix
nix:
  @git add --all && git commit -m 'talos deployment' && git push
  ssh talos -- ./github/nixdots/quickbuild
