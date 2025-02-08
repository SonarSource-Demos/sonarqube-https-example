#!/bin/bash

FOLDERS=("../proxy" "../ssl-poke")

for folder in "${FOLDERS[@]}"; do
    rm -f "${folder}/server.crt"
    rm -f "${folder}/server.key"
done

rm server.crt
rm server.key