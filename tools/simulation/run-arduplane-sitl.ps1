param(
    [string]$HomeLocation = "50.4501,30.5234,150,0"
)

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host " ArduPlane 4.7.1 Stable SITL Runner" -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan

$wslCheck = wsl -l -q 2>$null
if (-not $wslCheck) {
    Write-Error "WSL not found. Please install WSL."
    exit 1
}

Write-Host "Starting ArduPlane 4.7.1 in WSL Ubuntu..." -ForegroundColor Green
Write-Host "Home Location: $HomeLocation" -ForegroundColor Yellow
Write-Host "MAVLink TCP port: 127.0.0.1:5760" -ForegroundColor Green
Write-Host "Press Ctrl+C to stop simulation" -ForegroundColor Yellow
Write-Host "----------------------------------------------------------" -ForegroundColor DarkGray

$wslScript = "/mnt/c/Users/YaroslavKitchenko/SRC/ZverQGC/tools/simulation/run-arduplane-sitl.sh"
wsl -d Ubuntu -- /bin/bash $wslScript $HomeLocation
