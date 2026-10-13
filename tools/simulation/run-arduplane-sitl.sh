#!/usr/bin/env bash
# ArduPlane 4.7.1 Stable SITL Test Runner
set -euo pipefail

SITL_DIR="${HOME}/sitl_plane"
mkdir -p "${SITL_DIR}"
cd "${SITL_DIR}"

# Terminate any previously running instances to avoid port conflicts
killall -9 arduplane 2>/dev/null || true
sleep 1

BINARY_URL="https://firmware.ardupilot.org/Plane/stable-4.7.1/SITL_x86_64_linux_gnu/arduplane"

# Download binary if missing
if [ ! -f "arduplane" ]; then
    echo "Downloading ArduPlane 4.7.1 stable SITL binary..."
    curl -fL -o arduplane "${BINARY_URL}"
    chmod +x arduplane
fi

# Ensure pre-calibrated EEPROM is used (avoids 3D accel calibration prompts)
if [ -f "calibrated_eeprom.bin" ]; then
    cp -f "calibrated_eeprom.bin" "eeprom.bin"
fi
rm -f default_params.parm

HOME_LOCATION="${1:-50.4501,30.5234,150,0}"

echo "=========================================================="
echo " Starting ArduPlane 4.7.1 Stable SITL"
echo " Home Location:  ${HOME_LOCATION}"
echo " MAVLink TCP:    127.0.0.1:5760"
echo " Sensors:        Pre-calibrated (Ready to arm & fly)"
echo "=========================================================="

while true; do
    tail -f /dev/null | ./arduplane \
        --model plane \
        --home "${HOME_LOCATION}" || true
    echo "SITL finished. Restarting in 2 seconds (Ctrl+C to stop)..."
    sleep 2
done
