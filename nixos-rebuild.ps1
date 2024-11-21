
# Obviously we aren't running nixos on windows, but we can initiate rebuilds on remote nixos systems!

function Invoke-Nixos-Rebuild {
  param (
    [string]$ComputerName
  )

  ./git-sync.ps1
  $NixdotsPath = Switch ($ComputerName)
  {
      "talos" {"/home/cameron/github/nixdots"}
      "icebox" {"/etc/nixos/nixdots"}
  }
  ssh $ComputerName -J $NixdotsPath -- sudo "./nixos-rebuild" switch
}
