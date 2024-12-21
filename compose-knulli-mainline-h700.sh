#!/bin/bash
rm compose.yaml -f
ln -s compose-knulli-mainline-h700.yaml compose.yaml
docker compose up
