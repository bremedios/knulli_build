#!/bin/bash

usage () {
    echo "Usage: knulli-mainline-interactive <TARGET>"
    echo ""
    echo "    Valid Targets"
    echo "        a133 (Trim UI Brick, Smart Pro)"
    echo "        atm7039 (Anbernic RG35XX Original)"
    echo "        h700 (Anbernic RG28XX, RG34XX, RG35XX Plus, RG35XX 2024, RG35XX-H, RG40XX-H, RG40XX-V, RG-CubeXX)"
    echo "        r16"
    echo "        rk3128"
    echo "        rk3566"
    echo "        rk3568"
    echo "        sm8250"
}

if [ $# -ne 1 ] ; then
    usage
    exit 1
fi

TARGET=

# Check to see if our requested target is in our list of allowed target
ALLOWED_TARGETS=( "a133" "atm7039" "h700" "r16" "rk3128" "rk3566" "rk3568" "sm8250" )

for OPT in ${ALLOWED_TARGETS[@]}; do
    if [ "$OPT" == $1 ] ; then
        TARGET=$1
    fi
done

if [ -z $TARGET ] ; then
    usage
    exit 1
fi

echo docker run -it --mount type=volume,src=knulli_build-$TARGET,target=/home/developer/build --mount type=volume,src=knulli_toolchain-$TARGET,target=/home/developer/toolchains --mount type=bind,src=./output,target=/home/developer/output bremedios/knulli-build-interactive:latest

docker run --rm -it --mount type=volume,src=knulli_build-$TARGET,target=/home/developer/build --mount type=volume,src=knulli_toolchain-$TARGET,target=/home/developer/toolchains --mount type=bind,src=./output,target=/home/developer/output bremedios/knulli-build-interactive:latest
