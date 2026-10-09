#!/usr/bin/env python3
"""
Python conversion of worldorder.bat (NightFright2k19/worldorder_raze).
Intended for Windows. Requires bspatch.exe and the BDF patch files in the Raze destination folder,
provided the corresponding optional conversions are selected.
"""
from __future__ import annotations

import fnmatch
import os
import shutil
import subprocess
import sys
import time
import zipfile
from pathlib import Path

TITLE = "DUKE NUKEM 3D: ALIEN WORLD ORDER Extraction Script"
WORLD_TOUR = "Duke Nukem 3D Twentieth Anniversary World Tour"


def detect_steam() -> Path | None:
    """Determines whether Steam is installed using the Windows uninstall key."""
    if os.name != "nt":
        return None
    try:
        import winreg
    except ImportError:
        return None

    keys = [
        (winreg.HKEY_LOCAL_MACHINE,
         r"SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Steam"),
        (winreg.HKEY_LOCAL_MACHINE,
         r"SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Steam"),
    ]
    for root, subkey in keys:
        try:
            with winreg.OpenKey(root, subkey) as key:
                uninstall, _ = winreg.QueryValueEx(key, "UninstallString")
            # UninstallString can be enclosed in quotation marks and point to uninstall.exe.
            value = uninstall.strip().strip('"')
            path = Path(value)
            if path.name.lower() == "uninstall.exe":
                path = path.parent
            if path.is_dir():
                return path
        except (OSError, FileNotFoundError):
            continue
    return None


def ask_directory(prompt: str, default: Path) -> Path:
    answer = input(f"{prompt}\n[{default}]: ").strip().strip('"')
    return Path(answer).expanduser().resolve() if answer else default.resolve()


def ask_yes_no(prompt: str) -> bool:
    while True:
        answer = input(f"{prompt} [Y/N] ").strip().lower()
        if answer in ("y", "yes"):
            return True
        if answer in ("n", "no"):
            return False
        print("Please enter Y or N.")


def copy_matching_files(source: Path, destination: Path, patterns: tuple[str, ...],
                        recursive: bool = False) -> None:
    if not source.is_dir():
        return
    iterator = source.rglob("*") if recursive else source.iterdir()
    for item in iterator:
        if item.is_file() and any(fnmatch.fnmatch(item.name.lower(), p.lower()) for p in patterns):
            target = destination / item.relative_to(source)
            target.parent.mkdir(parents=True, exist_ok=True)
            shutil.copy2(item, target)


def copy_tree_contents(source: Path, destination: Path) -> None:
    if not source.is_dir():
        return
    for item in source.rglob("*"):
        relative = item.relative_to(source)
        target = destination / relative
        if item.is_dir():
            target.mkdir(parents=True, exist_ok=True)
        elif item.is_file():
            target.parent.mkdir(parents=True, exist_ok=True)
            shutil.copy2(item, target)


def run_bspatch(dest: Path, old_name: str, new_name: str, patch_name: str) -> bool:
    bspatch = dest / "bspatch.exe"
    patch = dest / patch_name
    if not bspatch.is_file():
        print("BSPATCH.EXE NOT FOUND – Conversion will be skipped.")
        return False
    if not patch.is_file():
        print(f"{patch_name} NOT FOUND – Conversion will be skipped.")
        return False
    print("If a UAC prompt appears, please confirm bspatch.exe.")
    time.sleep(2)
    result = subprocess.run(
        [str(bspatch), str(dest / old_name), str(dest / new_name), str(patch)],
        cwd=dest, check=False
    )
    if result.returncode != 0 or not (dest / new_name).exists():
        print(f"Patch failed: {patch_name} (Exit-Code {result.returncode}).")
        return False
    return True


def convert_grp(src: Path, dest: Path) -> bool:
    source = src / "DUKE3D.GRP"
    if not source.is_file():
        print("DUKE3D.GRP not found in the World Tour installation.")
        return False
    shutil.copy2(source, dest / "worldtour.grp")
    if not run_bspatch(dest, "worldtour.grp", "duke3d.grp", "wtatomic.bdf"):
        (dest / "worldtour.grp").unlink(missing_ok=True)
        return False
    (dest / "worldtour.grp").unlink(missing_ok=True)
    return True


def convert_map(src: Path, dest: Path, temp: Path, filename: str,
                output_name: str, patch_name: str) -> bool:
    source = src / "maps" / filename
    if not source.is_file():
        print(f"{filename} not found in the World Tour installation.")
        return False
    shutil.copy2(source, dest / filename)
    if not run_bspatch(dest, filename, output_name, patch_name):
        return False
    maps_temp = temp / "maps"
    maps_temp.mkdir(parents=True, exist_ok=True)
    shutil.move(str(dest / output_name), str(maps_temp / output_name))
    shutil.move(str(dest / filename), str(maps_temp / filename.replace(".map", "B.map")))
    return True


def create_grp(temp: Path, dest: Path) -> None:
    output = dest / "worldorder.grp"
    # 7za a -mx0 creates a ZIP file without compression; the .grp file extension is retained.
    with zipfile.ZipFile(output, "w", compression=zipfile.ZIP_STORED) as archive:
        for item in sorted(temp.rglob("*")):
            if item.is_file():
                archive.write(item, item.relative_to(temp).as_posix())


def main() -> int:
    print("=" * 62)
    print(f"       {TITLE}")
    print("=" * 62)
    print("Author: NightFright | Python Port")
    print("=" * 62)
    print("This script creates a standalone copy of 'Alien World Order' for Raze.")
    print("Only the files needed for this episode will be imported.")
    print("No changes have been made to the original four episodes.\n")

    steam = detect_steam()
    if steam is None:
        print("STEAM INSTALLATION NOT FOUND – Abort.")
        print("Please enter the Steam path manually at startup, or install Steam.")
        manual = input("Steam directory (empty = Cancel): ").strip().strip('"')
        if not manual:
            return 1
        steam = Path(manual).expanduser().resolve()

    raze = Path.cwd().resolve()
    steam = ask_directory("Steam Source Directory (Steam Root Folder)", steam)
    raze = ask_directory("Raze destination directory (folder containing raze.exe)", raze)

    src = steam / "steamapps" / "common" / WORLD_TOUR
    dest = raze / "data"
    temp = dest / "temp"

    if not src.is_dir():
        print(f"WORLD TOUR INSTALLATION NOT FOUND: {src}")
        return 1
    if not (raze / "raze.exe").is_file():
        print(f"RAZE.EXE NOT FOUND: {raze / 'raze.exe'}")
        return 1
    dest.mkdir(parents=True, exist_ok=True)

    # If any patch files are missing, the batch file skips directly to the copying process.
    options = [
        ("Import DUKE3D.GRP from World Tour and convert to Atomic?",
         lambda: convert_grp(src, dest)),
        ("Apply patch for E5L6 'Golden Carnage' (TROR)?",
         lambda: convert_map(src, dest, temp, "E5L6.map", "E5L6A.map", "e5l6_tror.bdf")),
        ("Apply patch for E5L8 'Prima Arena' (to restore missing sections)?",
         lambda: convert_map(src, dest, temp, "E5L8.map", "E5L8A.map", "e5l8_uncut.bdf")),
    ]
    for prompt, action in options:
        if ask_yes_no(prompt):
            if not (dest / "bspatch.exe").is_file():
                print("BSPATCH.EXE NOT FOUND – optional conversions will be skipped.")
                break
	    # If a specific patch file is missing, the batch script behaves as if
            # a conversion step had been skipped and continues with the copying process.
            patch_name = {0: "wtatomic.bdf", 1: "e5l6_tror.bdf", 2: "e5l8_uncut.bdf"}[options.index((prompt, action))]
            if not (dest / patch_name).is_file():
                print(f"{patch_name} NOT FOUND – conversion will be skipped.")
                break
            if not action():
                print("Conversion failed; continuing with copying.")
                break

    print("\nSTATUS: Copying process is starting...")
    copy_matching_files(src, temp, ("*.con", "*.art"))
    copy_tree_contents(src / "textures" / "skybox", temp / "textures" / "skybox")
    copy_matching_files(src / "maps", temp / "maps", ("E5*.map",))
    copy_matching_files(src / "music", temp / "music", ("E5*.ogg",))
    copy_matching_files(src / "sound", temp / "sound",
                        ("Pagoda_CheshireAlien*.ogg", "VO_*.ogg", "Wep_*.ogg"), recursive=True)

    for relative in (
        "tiles009.art",
        "music/E5L7_PluckYouPartTwo.ogg",
        "sound/VO_E5L2_Duke_BeHere - ALT.ogg",
        "sound/Wep_Flamethrower_Start.ogg",
    ):
        (temp / relative).unlink(missing_ok=True)

    skybox = temp / "textures" / "skybox"
    for name in ("BIGORBIT1", "CLOUDYOCEAN", "LA", "MOONSKY1", "REDSKY2"):
        path = skybox / name
        if path.is_dir():
            shutil.rmtree(path)
        elif path.is_file():
            path.unlink()

    try:
        create_grp(temp, dest)
    except OSError as exc:
        print(f"Error creating worldorder.grp: {exc}")
        return 1
    shutil.rmtree(temp, ignore_errors=True)

    # This is equivalent to cleaning up the batch file.
    for item in dest.glob("*.exe"):
        if item.is_file():
            item.unlink()
    for item in dest.glob("*.bdf"):
        if item.is_file():
            item.unlink()

    print("STATUS: DONE – worldorder.grp has been created.")
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except KeyboardInterrupt:
        print("\nAborted.")
        raise SystemExit(130)
