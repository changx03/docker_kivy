#!/bin/bash

IMG_NAME="kivy1.11"

echo "Deleteting $IMG_NAME..."
docker image remove $IMG_NAME

echo "Building image: $IMG_NAME..."
docker buildx build -t "$IMG_NAME" .

echo "$IMG_NAME is built."
