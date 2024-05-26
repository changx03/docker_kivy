#!/bin/bash

echo "[container] RESOLUTION=$RESOLUTION (TODO: Unsued !)"

# Create symbolic links for FTDI Daul Dual USB UART/FIFO IC
create_link() {
    local _PORT=$1
    local _USB=$2

    rm -f "$_PORT"
    ln -s "$_USB" "$_PORT"
    echo "Created $_PORT from $_USB"
}

for USB in /dev/ttyUSB*; do
    INTERFACE=$(udevadm info -a "$USB" | grep "ATTRS{interface}" | awk -F'==' '{print $2}' | sed 's/"//g')
    INTERFACE_NUM=$(udevadm info -a "$USB" | grep "ATTRS{bInterfaceNumber}" | awk -F'==' '{print $2}' | sed 's/"//g')
    echo "   Device: $USB"
    echo "Vender ID: $MANUF"
    echo "Interface: $INTERFACE"
    if [ "$INTERFACE" = "Dual RS232" ]; then
        case "$INTERFACE_NUM" in
        00)
            create_link /dev/ttyMyRS232_1 $USB
            ;;
        01)
            create_link /dev/ttyMyRS232_0 $USB
            ;;
        *)
            echo "Dual RS232 Converter does not match any INTERFACE!"
            ;;
        esac
    else
        echo "Not a Dual RS232 Converter"
    fi
done

# Allows to run next CMD in Dockerfile
exec $*
