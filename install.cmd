@echo off
set BACK_CD=%cd%
echo.
echo This script is here to make symlinks to your game/server in order to have a clean installation.
echo.
set SOURCE_PATH=%~dp0
echo Source path is assumed to be: %SOURCE_PATH%
echo.
echo You need to input your full absolute garrysmod directory path without quotation marks.
echo.
echo It usually look like this: X:\SteamLibrary\steamapps\common\GarrysMod\garrysmod
echo or this: X:\steamcmd\steamapps\common\GarrysModDS\garrysmod
echo.
set /p TARGET_PATH=garrysmod directory absolute path:
echo.
@echo on
%TARGET_PATH:~0,2%
cd "%TARGET_PATH%"
mkdir gamemodes
mklink /D gamemodes\supercookingpanic "%SOURCE_PATH%gamemodes\supercookingpanic"
@echo off
echo.
echo It should be done now. Please verify that no critical error occurred.
echo.
pause
%BACK_CD:~0,2%
cd "%BACK_CD%"
