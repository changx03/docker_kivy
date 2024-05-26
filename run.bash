#!/bin/bash

IMG_NAME="kivy1.11"
CONTAINER_NAME="kivy1-con"
RESOLUTION="1920x1080"

echo "[host] DISPLAY=$DISPLAY"
echo "[host] HOSTNAME=$HOSTNAME"
echo "[host] XAUTHORITY=$XAUTHORITY"
echo "[host] RESOLUTION=$RESOLUTION"

echo "[host] Running container: $CONTAINER_NAME..."

docker run --rm -it \
    --privileged \
    -e DISPLAY \
    -e RESOLUTION=$RESOLUTION \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    --name "$CONTAINER_NAME" \
    "$IMG_NAME"
