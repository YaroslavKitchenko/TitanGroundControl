@echo off
title TitanGroundControl
set "PATH=C:\Users\YaroslavKitchenko\Qt\6.10.3\msvc2022_64\bin;%PATH%"
cd /d "%~dp0build\Release"
start "" "%~dp0build\Release\TitanGroundControl.exe"
