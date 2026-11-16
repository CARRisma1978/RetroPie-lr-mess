#!/usr/bin/env bash
[ -z "$BASH_VERSION" ] && exec /usr/bin/env bash "$0" "$@"

ROM="$1"
shift

# Setup a temporary directory in RAM
TMP_DIR="/dev/shm/spectrum_tmp"
mkdir -p "$TMP_DIR"
rm -rf "${TMP_DIR:?}/"*

EXT="${ROM##*.}"
EXT=$(echo "$EXT" | tr '[:upper:]' '[:lower:]')

# Handle ZIP extraction
if [[ "$EXT" == "zip" ]]; then
    # Extract silently, ignoring directory structure
    unzip -qj "$ROM" -d "$TMP_DIR"
    
    # Target the first extracted file
    ROM=$(find "$TMP_DIR" -type f | head -n 1)
    
    # Re-evaluate the extension based on the extracted file
    EXT="${ROM##*.}"
    EXT=$(echo "$EXT" | tr '[:upper:]' '[:lower:]')
fi

CMD="/dev/shm/spectrum.cmd"

# -----------------------------
# Build lr-mess command file
# -----------------------------
if [[ "$EXT" == "tap" || "$EXT" == "tzx" ]]; then
    cat > "$CMD" <<EOF
spectrum -cass "$ROM" -autoboot_delay 3 -autoboot_command j""\n
EOF
elif [[ "$EXT" == "dsk" ]]; then
    cat > "$CMD" <<EOF
specpls3 -flop1 "$ROM" -autoboot_delay 3 -autoboot_command \n
EOF
elif [[ "$EXT" == "z80" || "$EXT" == "sna" || "$EXT" == "sp" ]]; then
    cat > "$CMD" <<EOF
spectrum -dump "$ROM"
EOF
else
    # Fallback for unrecognized extensions
    cat > "$CMD" <<EOF
spectrum -dump "$ROM"
EOF
fi

# -----------------------------
# Launch RetroArch + lr-mess
# -----------------------------
/opt/retropie/emulators/retroarch/bin/retroarch \
    -L /opt/retropie/libretrocores/lr-mess/mamemess_libretro.so \
    --config /opt/retropie/configs/zxspectrum/retroarch.cfg \
    "$CMD"

# -----------------------------
# Cleanup
# -----------------------------
rm -rf "$TMP_DIR"