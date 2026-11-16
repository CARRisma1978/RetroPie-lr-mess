#!/bin/bash
# lr-mess launcher for Game & Watch (MAME hh_sm510 / hh_sm500 sets)
# The file name must be the MAME machine name, e.g. gnw_ssparky.zip

ROM="$1"
shift

if [[ ! -f "$ROM" ]]; then
    echo "gnw-mess: file not found: $ROM" >&2
    exit 1
fi

# machine name = file name without path and extension; MAME names are lower case
FILENAME="$(basename "$ROM")"
MACHINE="${FILENAME%.*}"
MACHINE="${MACHINE,,}"

# the folder holding the set (and any parent set it needs)
ROMDIR="$(dirname "$ROM")"

echo "$MACHINE -rompath \"$ROMDIR\"" > /dev/shm/gnw.cmd

exec /opt/retropie/emulators/retroarch/bin/retroarch \
    -L /opt/retropie/libretrocores/lr-mess/mamemess_libretro.so \
    --config /opt/retropie/configs/gameandwatch/retroarch.cfg \
    "/dev/shm/gnw.cmd" "$@"
