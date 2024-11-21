
# Obviously we aren't running nixos on windows, but we can initiate rebuilds on remote nixos systems!

function Invoke-Nixos-Rebuild() {
  ./git-sync.ps1
  ssh talos -- ~/github/nixdots/nixos-rebuild switch
}