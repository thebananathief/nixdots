# Git Repository Sync Script
# This script performs git add, commit, pull, and push operations while attempting to auto-resolve conflicts

function Write-ColorOutput($ForegroundColor) {
  $fc = $host.UI.RawUI.ForegroundColor
  $host.UI.RawUI.ForegroundColor = $ForegroundColor
  if ($args) {
      Write-Output $args
  }
  $host.UI.RawUI.ForegroundColor = $fc
}

function Get-GitStatus {
  # Get status and convert to string
  $status = git status --porcelain
  return $status
}

function Add-GitChanges {
  $status = Get-GitStatus
  
  if ([string]::IsNullOrEmpty($status)) {
      Write-ColorOutput Yellow "No changes to add"
      return $false
  }
  
  Write-Output "Adding all changes..."
  git add .
  return $true
}

function New-GitCommit {
  # Check if there are staged changes
  $stagedChanges = git diff --cached --quiet
  if ($LASTEXITCODE -eq 0) {
      Write-ColorOutput Yellow "No staged changes to commit"
      return $false
  }
  
  # Generate commit message with hostname and timestamp
  $hostname = $env:COMPUTERNAME
  $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
  $Message = "Auto-commit from $hostname at $timestamp"
  
  # Show what's being committed
  Write-ColorOutput Cyan "Committing changes with message: $Message"
  git diff --cached --stat
  
  # Perform commit
  $commitResult = git commit -m $Message 2>&1
  
  if ($LASTEXITCODE -ne 0) {
      Write-ColorOutput Red "Commit failed:"
      Write-Output $commitResult
      return $false
  }
  
  Write-ColorOutput Green "Changes committed successfully!"
  return $true
}

function Sync-GitRepository {
  # Store current branch name
  $currentBranch = git rev-parse --abbrev-ref HEAD
  
  Write-ColorOutput Green "Starting git sync on branch: $currentBranch"
  
  # Add changes
  $changesAdded = Add-GitChanges
  
  # Commit changes if there are any
  if ($changesAdded) {
      $committed = New-GitCommit
      if (-not $committed) {
          Write-ColorOutput Red "Sync aborted due to commit failure"
          return
      }
  }
  
  # Stash any remaining local changes
  Write-Output "Stashing any remaining local changes..."
  git stash
  
  # Fetch all changes
  Write-Output "Fetching remote changes..."
  git fetch --all
  
  # Try to pull with recursive strategy
  Write-Output "Pulling changes with recursive strategy..."
  $pullResult = git pull --strategy recursive --strategy-option theirs 2>&1
  
  if ($LASTEXITCODE -ne 0) {
      Write-ColorOutput Red "Warning: Pull encountered conflicts that couldn't be auto-resolved"
      Write-Output $pullResult
      
      # Abort the pull if there are conflicts
      git merge --abort
      
      # Restore stashed changes
      git stash pop
      
      Write-ColorOutput Red "Sync failed. Please resolve conflicts manually."
      return
  }
  
  # Try to push changes
  Write-Output "Pushing changes to remote..."
  $pushResult = git push 2>&1
  
  if ($LASTEXITCODE -ne 0) {
      Write-ColorOutput Red "Warning: Push failed"
      Write-Output $pushResult
      
      # Restore stashed changes
      git stash pop
      
      Write-ColorOutput Red "Sync failed. Remote push was rejected."
      return
  }
  
  # Apply stashed changes back
  Write-Output "Restoring stashed changes..."
  $stashResult = git stash pop 2>&1
  
  if ($stashResult -match "No stash entries found") {
      Write-Output "No stashed changes to restore"
  }
  elseif ($LASTEXITCODE -ne 0) {
      Write-ColorOutput Yellow "Warning: Conflicts while restoring stashed changes"
      Write-Output $stashResult
      Write-ColorOutput Yellow "Please resolve conflicts in your working directory"
      return
  }
  
  Write-ColorOutput Green "Repository sync completed successfully!"
  Write-Output "Current branch is up to date with origin/$currentBranch"
}

# Execute the sync function
Sync-GitRepository