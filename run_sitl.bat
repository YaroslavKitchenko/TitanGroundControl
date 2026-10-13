@echo off
title ArduPlane 4.7.1 SITL
cd /d "%~dp0"
echo ==========================================================
echo  Starting ArduPlane 4.7.1 Stable SITL
echo ==========================================================
wsl -d Ubuntu -- /bin/bash /mnt/c/Users/YaroslavKitchenko/SRC/ZverQGC/tools/simulation/run-arduplane-sitl.sh
pause
