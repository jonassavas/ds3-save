$GameDir = Join-Path $env:APPDATA "DarkSoulsIII"
$GameFile = Join-Path $GameDir "DS30000.sl2"
$RepoFile = Join-Path $PSScriptRoot "DS30000.sl2"
$OldSaveDir = Join-Path $PSScriptRoot "old-save"

Write-Host "Press:"
Write-Host "  1: To backup your Dark Souls III savefile"
Write-Host "  2: To restore the savefile from the repository"
$choice = Read-Host

if (-not (Test-Path $GameDir)) {
    Write-Host "Game save directory not found. Doing nothing."
    exit 0
}

switch ($choice) {

"1" {
    if (Test-Path $GameFile) {
        Copy-Item $GameFile $RepoFile -Force
        Write-Host "Save backed up to repository."
    }
    else {
        Write-Host "Save file not found. Doing nothing."
    }
}

"2" {
    if (-not (Test-Path $RepoFile)) {
        Write-Host "No save in repository to restore."
        exit 0
    }

    Write-Host ""
    Write-Host "WARNING:"
    Write-Host "This will restore the savefile from the repository."
    Write-Host "The current save will be placed under .\old-save\"
    $confirm = Read-Host "Would you still like to continue? [y/n]"

    if ($confirm -ne "y" -and $confirm -ne "Y") {
        Write-Host "Restore cancelled."
        exit 0
    }

    if (Test-Path $GameFile) {
        New-Item -ItemType Directory -Force -Path $OldSaveDir | Out-Null
        $timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
        Copy-Item $GameFile (Join-Path $OldSaveDir "DS30000_$timestamp.sl2")
        Write-Host "Existing save backed up to old-save\."
    }

    Copy-Item $RepoFile $GameFile -Force
    Write-Host "Repository save restored."
}

default {
    Write-Host "Invalid selection. Doing nothing."
}

}