@echo off
setlocal EnableExtensions EnableDelayedExpansion

echo.
echo            ==========================================================
echo                DUKE NUKEM 3D: ALIEN WORLD ORDER Extraction Script
echo            ==========================================================
echo                       Author: NightFright ^| Version: 1.7
echo            ==========================================================
echo.
echo      This script creates a standalone copy of "Alien World Order" for Raze.
echo    Make sure that you have placed the script and all its associated files and
echo            directories in your target folder (with Raze executable).
echo.
echo            You will only get what is needed to play the new episode.
echo      Any changes affecting the original four episodes will NOT be included!
echo.
echo.
echo.

set "SteamPath32="
set "SteamPath64="
for /f "tokens=1,2,*" %%a in ('reg query "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Steam" /v UninstallString 2^>nul') do (
	set "SteamPath32=%%c"
)
for /f "tokens=1,2,*" %%a in ('reg query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Steam" /v UninstallString 2^>nul') do (
	set "SteamPath64=%%c"
)

set "steam="
if defined SteamPath64 set "steam=%SteamPath64%"
if not defined steam if defined SteamPath32 set "steam=%SteamPath32%"
if defined steam set "steam=%steam:\uninstall.exe=%"

if not defined steam (
	set "asset=STEAM INSTALLATION"
	goto Terminate
)

set "raze=%cd%"

echo Enter Steam source directory or press [ENTER] to autodetect (%steam%):
set "input="
set /p "input=> "
if defined input set "steam=%input%"
echo STEAM DIRECTORY SET
echo.

echo Enter Raze target directory or press [ENTER] to use current dir (%raze%):
set "input="
set /p "input=> "
if defined input set "raze=%input%"
echo RAZE DIRECTORY SET
echo.

set "src=%steam%\steamapps\common\Duke Nukem 3D Twentieth Anniversary World Tour"
set "dest=%raze%\data"
set "temp=%dest%\temp"

if not exist "%temp%" mkdir "%temp%" || goto Terminate

if not exist "%src%" (
	set "asset=WORLD TOUR INSTALLATION"
	goto Terminate
)

if not exist "%raze%\raze.exe" (
	set "asset=RAZE.EXE"
	goto Terminate
)

if not exist "%dest%" mkdir "%dest%" || goto Terminate
if not exist "%dest%\7za.exe" (
	set "asset=7ZA.EXE"
	goto Terminate
)

:GrpPatch
choice /c YN /n /m "<OPTION 1/3> Copy over DUKE3D.GRP from World Tour and convert it to Atomic [Y/N]?"
if errorlevel 2 goto MapPatch1
if errorlevel 1 goto Conversion1

:MapPatch1
choice /c YN /n /m "<OPTION 2/3> Apply patch for E5L6 'Golden Carnage' to add TROR feature [Y/N]?"
if errorlevel 2 goto MapPatch2
if errorlevel 1 goto Conversion2

:MapPatch2
choice /c YN /n /m "<OPTION 3/3> Apply patch for E5L8 'Prima Arena' to add cut sections [Y/N]?"
if errorlevel 2 goto StartCopy
if errorlevel 1 goto Conversion3

:Conversion1
set "ConversionMode=1"
goto ConversionCheck

:Resume1
robocopy "%src%" "%dest%" DUKE3D.GRP /nfl /ndl /njh /njs /nc /ns /np
pushd "%dest%" || goto Terminate
ren DUKE3D.GRP worldtour.grp
bspatch worldtour.grp duke3d.grp wtatomic.bdf
del worldtour.grp
popd
goto MapPatch1

:Conversion2
set "ConversionMode=2"
goto ConversionCheck

:Resume2
robocopy "%src%\maps" "%dest%" E5L6.map /nfl /ndl /njh /njs /nc /ns /np
pushd "%dest%" || goto Terminate
bspatch E5L6.map E5L6A.map e5l6_tror.bdf
mkdir "%temp%\maps" 2>nul
move E5L6A.map "%temp%\maps" >nul
move E5L6.map "%temp%\maps\E5L6B.map" >nul
popd
goto MapPatch2

:Conversion3
set "ConversionMode=3"
goto ConversionCheck

:Resume3
robocopy "%src%\maps" "%dest%" E5L8.map /nfl /ndl /njh /njs /nc /ns /np
pushd "%dest%" || goto Terminate
bspatch E5L8.map E5L8A.map e5l8_uncut.bdf
mkdir "%temp%\maps" 2>nul
move E5L8A.map "%temp%\maps" >nul
move E5L8.map "%temp%\maps\E5L8B.map" >nul
popd
goto StartCopy

:ConversionCheck
cls
if not exist "%dest%\bspatch.exe" (
	set "patchfile=BSPATCH.EXE"
	goto PatchError
)

if !ConversionMode! equ 1 if not exist "%dest%\wtatomic.bdf" (
	set "patchfile=ATOMIC BDIFF PATCH"
	goto PatchError
)

if !ConversionMode! equ 2 if not exist "%dest%\e5l6_tror.bdf" (
	set "patchfile=E5L6 BDIFF PATCH"
	goto PatchError
)

if !ConversionMode! equ 3 if not exist "%dest%\e5l8_uncut.bdf" (
	set "patchfile=E5L8 BDIFF PATCH"
	goto PatchError
)

echo Please confirm process 'bspatch.exe' if a UAC notification appears.
timeout /t 5 /nobreak >nul

if !ConversionMode! equ 1 goto Resume1
if !ConversionMode! equ 2 goto Resume2
if !ConversionMode! equ 3 goto Resume3

:PatchError
echo %patchfile% *NOT* FOUND - Skipping conversion...
timeout /t 2 /nobreak >nul

:StartCopy
cls
mkdir "%temp%" 2>nul
echo STATUS: Commencing copy procedure...
timeout /t 2 /nobreak >nul

robocopy "%src%" "%temp%" *.con *.art /nfl /ndl /njh /njs /nc /ns /np
robocopy "%src%\textures\skybox" "%temp%\textures\skybox" /s /nfl /ndl /njh /njs /nc /ns /np
robocopy "%src%\maps" "%temp%\maps" E5*.map /nfl /ndl /njh /njs /nc /ns /np
robocopy "%src%\music" "%temp%\music" E5*.ogg /nfl /ndl /njh /njs /nc /ns /np
robocopy "%src%\sound" "%temp%\sound" Pagoda_CheshireAlien*.ogg VO_*.ogg Wep_*.ogg /s /nfl /ndl /njh /njs /nc /ns /np >nul

del "%temp%\tiles009.art" 2>nul
del "%temp%\music\E5L7_PluckYouPartTwo.ogg" 2>nul
del "%temp%\sound\VO_E5L2_Duke_BeHere - ALT.ogg" 2>nul
del "%temp%\sound\Wep_Flamethrower_Start.ogg" 2>nul
for %%a in ("%temp%\textures\skybox\BIGORBIT1" "%temp%\textures\skybox\CLOUDYOCEAN" "%temp%\textures\skybox\LA" "%temp%\textures\skybox\MOONSKY1" "%temp%\textures\skybox\REDSKY2") do rd /s /q "%%~a"

pushd "%dest%" || goto Terminate
7za a -mx0 worldorder.zip "%temp%\*" >nul
ren worldorder.zip worldorder.grp
popd

rmdir "%temp%" /s /q
del "%dest%\*.exe" 2>nul
del "%dest%\*.bdf" 2>nul

echo STATUS: ALL DONE - Closing script...
goto End

:Terminate
echo.
echo %asset% *NOT* FOUND - Terminating script...

:End
timeout /t 3 /nobreak >nul
endlocal
