
                                =====================================
                                 ALIEN WORLD ORDER EXTRACTION SCRIPT 
				    FOR DUKE NUKEM 3D: WORLD TOUR
                                           By NightFright
                                =====================================
                                    Version: 1.2 / April 19, 2021


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
> 8-bit parallax skies
> Lee Jackson's OGG music (ep.5 only)
> New Duke voice acting (ep.5 only)
> Not included: Maps/music/Duketalk for ep.1-4, 32-bit skyboxes, dev commentaries, normalmaps


================================================================================================
R E Q U I R E M E N T S
================================================================================================

> Windows Vista or newer (to be able to use robocopy command)
> Existing Steam installation of "Duke Nukem 3D: 20th Anniversary World Tour"
> Raze v1.0.2 (or newer)


================================================================================================
I N S T A L L A T I O N
================================================================================================

1) Unpack this zipfile (worldorder_raze.zip) into your Raze installation folder.

2) Specify your Steam and Raze directories when prompted and confirm each input with "Enter".
   No need for any input if you installed Steam in the default directory. Otherwise use root 
   directories only, e.g. "C:\Program Files (x86)\Steam" or "D:\Raze".

3) Choose whether you want to copy over duke3d.grp from World Tour and convert it to 
   Atomic Edition (recommended if you don't own Atomic Edition). There might be a UAC
   popup during this process which you need to confirm.
   In case you have duke3d.grp from Atomic, be sure to copy it to the "data" subdir.

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

> ALIEN WORLD ORDER SOUNDTRACK
  (C) 2016 Lee Jackson

> ORIGINAL DUKE NUKEM 3D ARTWORK
  (C) 1996 3D Realms

> BSPATCH
  Timotheus Pokorra (https://www.pokorra.de/coding/bsdiff.html)
  Original code: Colin Percival

> 7-ZIP COMPRESSION TOOL (7Z.EXE)
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

v1.2 / 2021-04-19
-----------------
> worldorder.bat: Added optional copying/conversion of duke3d.grp

v1.1 / 2021-04-18
-----------------
> Now requires Raze v1.0.2 or newer
> Worldorder.grpinfo, worldorder_wt.grpinfo and worldorder.def removed
> worldorder.bat: Progress bar added; Duke3D version selection and CRC32 check removed;
                  script now closes on its own

v1.0 / 2021-04-12
-----------------
> Initial release
