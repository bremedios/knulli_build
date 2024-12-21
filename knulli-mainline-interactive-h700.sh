#!/bin/bash
docker run -it --mount type=volume,src=knulli_build-h700,target=/home/developer/build --mount type=volume,src=knulli_toolchain-h700,target=/home/developer/toolchains --mount type=bind,src=./output,target=/home/developer/output bremedios/knulli-build-interactive:latest
