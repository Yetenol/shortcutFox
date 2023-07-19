$rootPath = "D:\"

Write-Host "Scanning for repositories in $rootPath..."

# Find repositories
$repositories = @()
Get-ChildItem -Path $rootPath -Directory -Hidden -Recurse -Filter ".git" -ErrorAction SilentlyContinue | 
Where-Object { $_.FullName -notmatch '\\\$RECYCLE\.BIN\\' } | foreach { $_.Parent } | foreach {
    $repositories += $_
    Write-Output $_
}

# Update repositories
$index = 0
$repositories | sort LastWriteTime -Descending | foreach { 
    # Print progress information
    Write-Host @("`n(" + (++$index) + "/" + $repositories.Length + ") Found ") -NoNewline
    Write-Host $_.Name -ForegroundColor Cyan -NoNewline
    Write-Host " in " -NoNewline
    Write-Host $_.Parent.FullName -ForegroundColor Cyan
    
    $path = $_.FullName
    $localBranches = git -C $path branch --format='%(refname:short)'
    $remoteBranches = git -C $path branch --remotes --format='%(refname:short)' | foreach { 
        $_.replace("origin/", "")
    }
    
    # Sync branches, that are already on remote
    $localBranches | where { 
        $remoteBranches.Contains($_) 
    } | foreach { 
        Write-Host "fetch " -NoNewline
        Write-Host $_" `t" -ForegroundColor Yellow -NoNewline
        git -C $path fetch origin $_":"$_
        Write-Host "push " -NoNewline
        Write-Host $_" `t" -ForegroundColor Yellow -NoNewline
        git -C $path push origin $_":"$_
    }
}