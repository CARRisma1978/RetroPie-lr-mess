#!/bin/bash
# lr-mess launcher for the Acorn Electron
#   .uef .csw         tape  - types *TAPE / CHAIN""
#   .ssd .dsd         DFS disc (Plus 1 + Pegasus 400 DFS cartridge) - types *CAT
#   .adf .adm .adl    ADFS disc (Plus 3) - types *CAT            (untested)
#   .rom .bin         cartridge in the Plus 1, slot 1            (untested)

ROM="$1"
shift

EXT="${ROM##*.}"
EXT="${EXT,,}"

case "$EXT" in
    ssd|dsd)
        MACHINE='electron -exp plus1 -exp:plus1:cart1 peg400'
        MEDIA='-flop1'
        AUTOBOOT='-autoboot_delay 2 -autoboot_command *CAT\n'
        ;;
    adf|adm|adl)
        MACHINE='electron -exp plus3'
        MEDIA='-flop1'
        AUTOBOOT='-autoboot_delay 2 -autoboot_command *CAT\n'
        ;;
    rom|bin)
        MACHINE='electron -exp plus1'
        MEDIA='-cart1'
        AUTOBOOT=''
        ;;
    *)
        MACHINE='electron'
        MEDIA='-cass'
        AUTOBOOT='-autoboot_delay 2 -autoboot_command *TAPE\nCHAIN""\n'
        ;;
esac

echo "$MACHINE $MEDIA \"$ROM\" $AUTOBOOT" > /dev/shm/electron.cmd

exec /opt/retropie/emulators/retroarch/bin/retroarch \
    -L /opt/retropie/libretrocores/lr-mess/mamemess_libretro.so \
    --config /opt/retropie/configs/electron/retroarch.cfg \
    "/dev/shm/electron.cmd" "$@"
