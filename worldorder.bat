@echo off & cls && "%__APPDIR__%chcp.com" 65001 >nul
@echo.
@echo            ==========================================================
@echo                DUKE NUKEM 3D: ALIEN WORLD ORDER Extraction Script
@echo            ==========================================================
@echo                       Author: NightFright ^| Version: 1.41
@echo            ==========================================================              
@echo.
@echo      This script creates a standalone copy of "Alien World Order" for Raze.
@echo.
@echo            You will only get what is needed to play the new episode.
@echo      Any changes affecting the original four episodes will NOT be included!
@echo.
@echo.
@echo.

(for /f "usebackq tokens=1,2,*" %%a in (`reg query "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Steam" /v UninstallString`) do set SteamPath32=%%c) >nul 2>&1
(for /f "usebackq tokens=1,2,*" %%a in (`reg query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Steam" /v UninstallString`) do set SteamPath64=%%c) >nul 2>&1
set steam=%SteamPath64%%SteamPath32%
set steam=%steam:\uninstall.exe=%
set src="%steam%\steamapps\common\Duke Nukem 3D Twentieth Anniversary World Tour"
set dest=%cd%\data
set temp=%dest%\temp
@echo.

choice /c YN /n /m "<OPTION 1/2> Copy over duke3d.grp from World Tour and convert it to Atomic [Y/N]?"
if errorlevel 2 goto MapPatch
if errorlevel 1 goto Conversion1

:MapPatch
choice /c YN /n /m "<OPTION 2/2> Apply patch for 'Prima Arena' (E5L8.map) to add cut sections [Y/N]?"
if errorlevel 2 goto StartCopy
if errorlevel 1 goto Conversion2

:Conversion1
cls
@echo.
@echo Please confirm process 'bspatch.exe' if a UAC notification appears.
ping -n 6 localhost >nul
robocopy %src% %dest% DUKE3D.GRP /nfl /ndl /njh /njs /nc /ns /np
cd %dest%
ren DUKE3D.GRP worldtour.grp
bspatch worldtour.grp duke3d.grp wtatomic.bdf
del %dest%\worldtour.grp
@echo Duke3d.grp copied, Atomic patch applied.
ping -n 3 localhost >nul
@echo.
goto MapPatch

:Conversion2
cls
@echo.
@echo Please confirm process 'bspatch.exe' if a UAC notification appears.
ping -n 6 localhost >nul
robocopy %src%\maps %dest% E5L8.map /nfl /ndl /njh /njs /nc /ns /np
cd %dest%
bspatch E5L8.map E5L8A.map e5l8_uncut.bdf
move E5L8A.map %temp%\maps >nul
move E5L8.map %temp%\maps\E5L8B.map >nul
@echo E5L8 patch applied. Backup saved as E5L8B.map.
ping -n 3 localhost >nul
goto StartCopy

:StartCopy
cls
@echo.
@echo PROGRESS: ▓▒▒▒▒▒▒▒▒▒  10%%
@echo STATUS: SETUP COMPLETE! Commencing copy procedure...
ping -n 3 localhost >nul

cls
@echo.
@echo PROGRESS: ▓▓▒▒▒▒▒▒▒▒  20%%
@echo STATUS: Copying CON files...
robocopy %src% %temp% *.con /nfl /ndl /njh /njs /nc /ns /np
del %temp%\USER.CON
del %temp%\GAME.CON
ren %temp%\USER_FIX.CON USER.CON
ren %temp%\GAME_FIX.CON GAME.CON
ping -n 2 localhost >nul

cls
@echo.
@echo PROGRESS: ▓▓▓▒▒▒▒▒▒▒  30%%
@echo STATUS: Copying ART files and skyboxes...
robocopy %src% %temp% *.art /nfl /ndl /njh /njs /nc /ns /np
robocopy %src%\textures\skybox %temp%\skyboxes /nfl /ndl /njh /njs /nc /ns /np /s
ping -n 2 localhost >nul

cls
@echo.
@echo PROGRESS: ▓▓▓▓▒▒▒▒▒▒  40%%
@echo STATUS: Copying maps...
robocopy %src%\maps %temp%\maps E5*.map /nfl /ndl /njh /njs /nc /ns /np
if exist %temp%\maps\E5L8A.map (
   del %temp%\maps\E5L8.map
   ren %temp%\maps\E5L8A.map E5L8.map
)
ping -n 2 localhost >nul

cls
@echo.
@echo PROGRESS: ▓▓▓▓▓▒▒▒▒▒  50%%
@echo STATUS: Copying music...
robocopy %src%\music %temp%\music E5*.ogg /nfl /ndl /njh /njs /nc /ns /np
ping -n 2 localhost >nul

cls
@echo.
@echo PROGRESS: ▓▓▓▓▓▓▒▒▒▒  60%%
@echo STATUS: Copying sounds...
robocopy %src%\sound %temp%\sound Pagoda_CheshireAlien*.ogg /s /nfl /ndl /njh /njs /nc /ns /np >nul
robocopy %src%\sound %temp%\sound VO_*.ogg /s /nfl /ndl /njh /njs /nc /ns /np >nul
robocopy %src%\sound %temp%\sound Wep_*.ogg /s /nfl /ndl /njh /njs /nc /ns /np >nul
ping -n 2 localhost >nul

cls
@echo.
@echo PROGRESS: ▓▓▓▓▓▓▓▒▒▒  70%%
@echo STATUS: Cleaning up...
del %temp%\tiles009.art
del %temp%\music\E5L7_PluckYouPartTwo.ogg
del "%temp%\sound\VO_E5L2_Duke_BeHere - ALT.ogg"
del %temp%\sound\Wep_Flamethrower_Start.ogg
for %%a in ("%temp%\skyboxes\BIGORBIT1" "%temp%\skyboxes\CLOUDYOCEAN" "%temp%\skyboxes\LA" "%temp%\skyboxes\MOONSKY1" "%temp%\skyboxes\REDSKY2") do rd /s /q "%%~a"
ping -n 2 localhost >nul

cls
@echo.
@echo PROGRESS: ▓▓▓▓▓▓▓▓▒▒  80%%
@echo STATUS: Creating data file "worldorder.grp"...
cd %dest%
7z a -mx0 worldorder.zip %temp%\* >nul
ren worldorder.zip worldorder.grp
ping -n 2 localhost >nul

cls
@echo.
@echo PROGRESS: ▓▓▓▓▓▓▓▓▓▒  90%%
@echo STATUS: Deleting temporary files...
rmdir %temp% /s /q
del %dest%\*.exe
del %dest%\*.bdf
ping -n 2 localhost >nul

cls
@echo.
@echo PROGRESS: ▓▓▓▓▓▓▓▓▓▓ 100%%
@echo STATUS: ALL DONE! Closing script...
ping -n 4 localhost >nul