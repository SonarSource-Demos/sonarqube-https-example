#!/bin/bash

PUBLIC_CERT="server.crt"
PRIVATE_KEY="server.key"

FOLDERS=("../proxy" "../ssl-poke")

for folder in "${FOLDERS[@]}"; do
    cp "${PUBLIC_CERT}" "${folder}/"
    cp "${PRIVATE_KEY}" "${folder}/"
done