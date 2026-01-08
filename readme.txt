
                                =====================================
                                 ALIEN WORLD ORDER EXTRACTION SCRIPT 
				    FOR DUKE NUKEM 3D: WORLD TOUR
                                           By NightFright
                                =====================================
                                     Version: 1.7 / Jan 8, 2026


================================================================================================
A B O U T
================================================================================================

This script allows you to play the new episode from "Duke Nukem 3D: 20th Anniversary World Tour" 
with Raze and duke3d.grp from the Atomic Edition (or World Tour). You will end up with a
standalone version of the game (in the form of an addon) which works without requiring the 
Steam installation of "World Tour".

Features:
---------
> "Alien World Order" maps
> World Tour CONs, including the Firefly enemy, Incinerator boss and new minibosses
> 8-bit parallax skies + skyboxes (ep.5 only)
> Lee Jackson's OGG music (ep.5 only)
> New Duke voice acting (ep.5 only)
> Not included: Maps/music/Duketalk for ep.1-4, ep.1-4 skyboxes, dev commentaries, normalmaps


================================================================================================
R E Q U I R E M E N T S
================================================================================================

> Windows Vista or newer (to be able to use robocopy command)
> Existing Steam installation of "Duke Nukem 3D: 20th Anniversary World Tour"
> Raze v1.0.2 (or newer)


================================================================================================
I N S T A L L A T I O N
================================================================================================

1) Unpack this zipfile (worldorder_raze.zip) into your Raze installation folder, then
   launch worldorder.bat.

2) Choose your Steam (source) and Raze (target) directories. You can either enter the paths 
   manually or use defaults (Steam: reads registry, Raze: current dir) by pressing "Enter". 

3) You will be given three [Y]es/[N]o choices now.
   There might be UAC popups during this process which you need to confirm:
   a) Choose whether you want to copy over duke3d.grp from World Tour and convert it to 
      Atomic Edition (recommended if you don't own Atomic Edition).
      In case you have duke3d.grp from Atomic, be sure to copy it to the "data" subdir.
   b) Choose whether you want to replace the original "Golden Carnage" map (E5L6) with one
      that supports TROR (True Room Over Room). Note that this feature is best supported
      by EDuke32 in Polymer rendering mode. Other ports and/or renderers may suffer from
      visual glitches and performance issues.
      The original map will be saved as E5L6B.map in case you want to revert manually later.
   c) Choose whether you want to patch the original "Prima Arena" map (E5L8) to make
      some sections accessible which were cut from the original release.
      The original map will be saved as E5L8B.map in case you want to revert manually later.

4) You can (and should) uninstall World Tour on Steam at this point. Also the script
   file itself (worldorder.bat) is no longer needed.

5) Launch Raze (raze.exe). In the selection menu, choose "Alien World Order (worldorder)".


================================================================================================
C R E D I T S
================================================================================================

> DUKE NUKEM 3D: 20TH ANNIVERSARY WORLD TOUR
  (C) 2016 Gearbox Software, LLC / Nerve Software

> ALIEN WORLD ORDER MAPS
  (C) 2016 Allen Blum, Richard "Levelord" Gray, Randy Pitchford

> GOLDEN GATE TROR
  pepsodent (https://forums.duke4.net/topic/12795-golden-carnage-tror-edition)

> PRIMA ARENA UNCUT
  Ness (https://steamcommunity.com/sharedfiles/filedetails/?id=781120926)

> ALIEN WORLD ORDER SOUNDTRACK
  (C) 2016 Lee Jackson

> ORIGINAL DUKE NUKEM 3D ARTWORK
  (C) 1996 3D Realms

> BSPATCH
  Timotheus Pokorra (https://www.pokorra.de/coding/bsdiff.html)
  Original code: Colin Percival

> 7-ZIP COMPRESSION TOOL (7ZA.EXE)
  Igor Pavlov (http://www.7-zip.org)

> ALIEN WORLD ORDER STEAM EXTRACTION SCRIPT
  NightFright (nightfright2k7[at]gmail.com | http://hrp.duke4.net)


================================================================================================
L I N K S
================================================================================================

- Raze port for Duke Nukem 3D .................... https://github.com/coelckers/Raze/releases

- ZDoom/Raze Forums .............................. https://forum.zdoom.org


================================================================================================
C H A N G E L O G
================================================================================================

v1.7 / 2026-01-08
-----------------
> Improved script robustness:
  - Added Delayed Expansion (avoids code breaking in edge cases)
  - Improve Steam path detection (prefer 64-bit, fallback to 32-bit otherwise)
  - Fix user input overwriting detected paths incorrectly
  - Error checking for cd "%dest%"
  - Fix fragile choice errorlevel logic
  - Quote all set commands
  - Use pushd/popd instead of cd (prevents directory state corruption)
  - Ensure %temp% exists before use
  - Replace ping delays with timeout (ping localhost is a hack and slower)
  - Use only one robocopy option block
> Changed script so that skyboxes are copied to "textures\skybox" instead of "skyboxes"
> Removed engine\engine.def and skyboxes\skyboxes.def (no longer needed, handled by Raze)

v1.6 / 2025-10-13
-----------------
> Added option to install TROR version of E5L6
> 7za.exe updated to latest version (v25.01)

v1.55 / 2024-09-04
------------------
> 7za.exe updated to latest version (v24.08)
> 7za.dll removed (not required)

v1.54 / 2023-10-26
------------------
> Added abort condition in case chcp.com is not found
> 7za.exe updated to latest version (v23.01)

v1.53 / 2023-05-01
------------------
> 7z.exe updated to latest version (v22.01); 7z.dll added (in case 7-Zip is not installed)

v1.52 / 2022-10-24
------------------
> Bugfix for E5L8 patch (unable to find/create target directory)

v1.51 / 2022-05-09
------------------
> Moved 7z.exe abort condition to the beginning of script (instead of terminating at 80%)
> Optimized abort conditions
> Optimized BSPATCH/BDIFF process

v1.5 / 2021-10-01
-----------------
> Can choose source and target dir again (pressing ENTER uses defaults)
> Source/target dirs with name spaces now supported
> Script now terminates if source/target dir is not found
> Added case handling for bspatch.exe, 7z.exe or any bdiff patch not found

v1.41 / 2021-06-23
------------------
> Choosing source dir during installation is also no longer necessary

v1.4 / 2021-06-22
-----------------
> Choosing target dir during installation is no longer necessary
> Added option for patching E5L8 to add cut sections
> DLLs for bspatch.exe removed

v1.31 / 2021-06-09
------------------
> worldorder.def moved to engine\engine.def for automatic skybox loading

v1.3 / 2021-06-05
-----------------
> Ep.5 skyboxes added

v1.21 / 2021-04-21
------------------
> Missing pickup message for keycards fixed

v1.2 / 2021-04-19
-----------------
> Optional copying/conversion of duke3d.grp added

v1.1 / 2021-04-18
-----------------
> Now requires Raze v1.0.2 or newer
> Grpinfo files and worldorder.def removed
> Progress bar added; Duke3D version selection and CRC32 check removed; 
  script now closes on its own

v1.0 / 2021-04-12
-----------------
> Initial release
