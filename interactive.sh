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

BUILD_BIND=0

if [ $# -eq 2 ] ; then
    if [ "$2" == "--build-bind" ] ; then
        BUILD_BIND=1
    fi
elif [ $# -ne 1 ] ; then
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

# map our build keys into the system.
if [ -f keys.txt ] ; then
    ES_KEYS="-v keys.txt:/home/developer/keys.txt"
fi

if [ $BUILD_BIND -eq 0 ] ; then
    MOUNT_BUILD="--mount type=volume,src=knulli_build-$TARGET,target=/home/developer/build"
else
    MOUNT_BUILD="--mount type=bind,src=./build-$TARGET,target=/home/developer/build"
    mkdir -p ./build-$TARGET
fi

echo "docker run -it \\"
echo "    $MOUNT_BUILD \\"
echo "    --mount type=volume,src=knulli_build-$TARGET,target=/home/developer/build \\"
echo "    --mount type=volume,src=knulli_toolchain-$TARGET,target=/home/developer/toolchains \\"
echo "    --mount type=volume,src=knulli_buildroot_cache-$TARGET,target=/home/developer/.buildroot-ccache \\"
echo "    --mount type=bind,src=./keys.txt,target=/home/developer/keys.txt \\"
echo "    --mount type=bind,src=./output,target=/home/developer/output \\"
echo "    bremedios/knulli-build-interactive:latest"

docker run --rm -it \
	$MOUNT_BUILD \
    --mount type=volume,src=knulli_toolchain-$TARGET,target=/home/developer/toolchains \
    --mount type=volume,src=knulli_buildroot_cache-$TARGET,target=/home/developer/.buildroot-ccache \
    --mount type=bind,src=./keys.txt,target=/home/developer/keys.txt \
    --mount type=bind,src=./output,target=/home/developer/output \
    bremedios/knulli-build-interactive:latest
