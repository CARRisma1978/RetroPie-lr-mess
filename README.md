# RetroPie-lr-mess

Launch scripts for running the **Acorn Electron**, **ZX Spectrum** and **Game & Watch** in RetroPie with **lr-mess** (the MAME/MESS libretro core). Each script picks the right MAME machine and media for the game file, can type the commands to load it, and starts RetroArch with lr-mess.

**No ROMs, BIOS files or games are included.**

> **Use at your own risk.** These scripts have only been tested on the setup listed below.

## How they work

lr-mess can be given a **command file**: a text file holding a MAME command line (machine, media and options). Each script writes one to `/dev/shm` (in memory) for the game being started, then runs RetroArch with lr-mess and that file.

## The files

| File | Goes in | What it does |
|---|---|---|
| `mess-electron.sh` | `/opt/retropie/configs/electron/` | Acorn Electron launcher |
| `retroarch.cfg` | `/opt/retropie/configs/electron/` | RetroArch settings for the Electron |
| `mess-zx.sh` | `/opt/retropie/configs/zxspectrum/` | ZX Spectrum launcher |
| `mess-gnw.sh` | `/opt/retropie/configs/gameandwatch/` | Game & Watch launcher |

### Acorn Electron - `mess-electron.sh`

| Files | Machine | Loads with |
|---|---|---|
| `.uef` `.csw` (tape) | Electron | Types `*TAPE` then `CHAIN""` |
| `.ssd` `.dsd` (DFS disc) | Electron + Plus 1 with the Pegasus 400 DFS cartridge | Types `*CAT` |
| `.adf` `.adm` `.adl` (ADFS disc) | Electron + Plus 3 | Types `*CAT` (untested) |
| `.rom` `.bin` (cartridge) | Electron + Plus 1, cartridge slot 1 | Starts from the cartridge (untested) |

Any other file type is treated as a tape.

**`retroarch.cfg`** is the Electron's own RetroArch settings file. It includes RetroPie's main `retroarch.cfg`, then turns off audio sync and vsync and sets an unlimited fast-forward rate.

### ZX Spectrum - `mess-zx.sh`

| Files | Machine | Loads with |
|---|---|---|
| `.tap` `.tzx` (tape) | 48K Spectrum | Types `LOAD ""` |
| `.dsk` (disc) | Spectrum +3 | Presses Enter at the start-up menu |
| `.z80` `.sna` `.sp` (snapshot) | 48K Spectrum | Loads the snapshot straight away |

Zipped games (`.zip`) are unzipped into memory first and the first file inside is used. Any other file type is treated as a snapshot.

### Game & Watch - `mess-gnw.sh`

Runs MAME's Game & Watch sets (the `hh_sm510` / `hh_sm500` drivers). **The file name must be the MAME machine name**, e.g. `gnw_ssparky.zip`. The folder the game is in is used as the ROM path, so put any parent set it needs in the same folder.

## Requirements

- **lr-mess**, installed from RetroPie-Setup (*Manage packages → Manage experimental packages → lr-mess*).
- **BIOS / system ROM sets** in `~/RetroPie/BIOS/mame/`:

  | Machine | ROM set |
  |---|---|
  | Acorn Electron | `electron.zip` |
  | ZX Spectrum 48K | `spectrum.zip` |
  | ZX Spectrum 128K / +2 / +2A / +3 | `spec128.zip`, `specpls2.zip`, `specpl2a.zip`, `specpls3.zip` |

  The sets must match lr-mess's MAME version. If lr-mess reports missing ROMs, its log names the set it needs.
- **The systems in EmulationStation:** `zxspectrum` and `gameandwatch` are part of RetroPie. **`electron` is not**: add it with a custom `es_systems.cfg` entry, or install it with the [RetroPie-Elkulator](https://github.com/CARRisma1978/RetroPie-Elkulator) module, which also adds the system. Check that each system's file extensions include the types listed above (e.g. `.zip` for Game & Watch).

### Tested on

| | |
|---|---|
| Hardware | Raspberry Pi 5 (16 GB), 1080p over HDMI |
| OS | Raspberry Pi OS Bookworm Lite 64-bit (Debian 12.15) |
| RetroPie | 4.8.12 |
| Gamepad | 8BitDo M30 |

## Installing

1. Copy the files into the folders shown in the table above. Then make the scripts executable:

   ```bash
   sudo chmod +x /opt/retropie/configs/electron/mess-electron.sh
   sudo chmod +x /opt/retropie/configs/zxspectrum/mess-zx.sh
   sudo chmod +x /opt/retropie/configs/gameandwatch/mess-gnw.sh
   ```

2. Add lr-mess as an emulator for each system, with one line in that system's `emulators.cfg`:

   `/opt/retropie/configs/electron/emulators.cfg`

   ```
   lr-mess = "/opt/retropie/configs/electron/mess-electron.sh %ROM%"
   ```

   `/opt/retropie/configs/zxspectrum/emulators.cfg`

   ```
   lr-mess = "/opt/retropie/configs/zxspectrum/mess-zx.sh %ROM%"
   ```

   `/opt/retropie/configs/gameandwatch/emulators.cfg`

   ```
   lr-mess = "/opt/retropie/configs/gameandwatch/mess-gnw.sh %ROM%"
   ```

3. Choose **lr-mess** for a system or a game from the runcommand menu (press a button while the game is starting), or make it the system's `default` in `emulators.cfg`.
4. Copy the BIOS / system ROM sets into `~/RetroPie/BIOS/mame/`.

If you edit the files on Windows, save them with **Unix (LF)** line endings. In Notepad++: *Edit → EOL Conversion → Unix (LF)*. Scripts with Windows (CRLF) line endings fail on the Pi.

### Optional: 128K Spectrum for lr-fuse

If you also use **lr-fuse** (RetroPie's usual Spectrum emulator), it can be set to a 128K Spectrum by adding this line to `/opt/retropie/configs/all/retroarch-core-options.cfg`:

```
fuse_machine = "Spectrum 128K"
```

This only affects lr-fuse, not these scripts.

## Controls

- **Quit:** press **Start + Select** together on the gamepad (sometimes twice).
- **Tab** on the keyboard opens MAME's menu.
- The Electron and Spectrum need a keyboard for most games.

## Credits

- [MAME](https://www.mamedev.org/) and the [lr-mess / MAME libretro core](https://github.com/libretro/mame)
- [RetroArch](https://www.retroarch.com/) and [RetroPie](https://retropie.org.uk/)

## Licence

Released under the MIT Licence; see [LICENSE](LICENSE). MAME, RetroArch and RetroPie are covered by their own licences.
