#!/bin/bash

usage () {
    echo "Usage: interactive.sh <TARGET> [options]"
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
    echo ""
    echo "    Options"
    echo "        --build-bind - Bind build directory instead of using build as a volume"

}

DOCKER_IMAGE=bremedios/knulli-build-interactive:latest
GID=`id -g`

BUILD_BIND=0
BUILD_VOLUME=0

if [ $# -eq 2 ] ; then
    if [ "$2" == "--build-bind" ] ; then
        BUILD_BIND=1
    elif [ "$2" == "--build-volume" ] ; then
        BUILD_VOLUME=1
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

# If we don't have a target, we cannot proceed
if [ -z $TARGET ] ; then
    usage
    exit 1
fi

# map our build keys into the system.
if [ -f keys.txt ] ; then
    ES_KEYS="-v keys.txt:/home/developer/keys.txt"
fi

if [ $BUILD_BIND -eq 0 ] ; then
    MOUNT_BUILD="--mount type=volume,src=knulli_build-$TARGET,target=/build"
else
    MOUNT_BUILD="--mount type=bind,src=./build-$TARGET,target=/build"
    mkdir -p ./build-$TARGET
fi

MOUNT_TOOLCHAIN="--mount type=volume,src=knulli_toolchain-$TARGET,target=/home/ubuntu/toolchains"
MOUNT_BUILDROOT_CACHE="--mount type=volume,src=knulli_buildroot_cache-$TARGET,target=/home/ubuntu/.buildroot-ccache"
MOUNT_KEYS="--mount type=bind,src=./keys.txt,target=/home/ubuntu/keys.txt"
MOUNT_OUTPUT="--mount type=bind,src=./output-$TARGET,target=/home/ubuntu/output"
MOUNT_PASSWORD="-v /etc/passwd:/etc/passwd:ro"
MOUNT_GROUP="-v /etc/group:/etc/group:ro"

echo "docker run --rm -it \\"
echo "    $MOUNT_BUILD \\"
echo "    $MOUNT_TOOLCHAIN \\"
echo "    $MOUNT_BUILDROOT_CACHE \\"
echo "    $MOUNT_KEYS \\"
echo "    $MOUNT_OUTPUT \\"
echo "    -u $UID:$GID \\"
echo "    $DOCKER_IMAGE"

mkdir -p knulli_build-$TARGET
mkdir -p output-$TARGET

docker run --rm -it \
    	$MOUNT_BUILD \
    $MOUNT_TOOLCHAIN \
    $MOUNT_BUILDROOT_CACHE \
    $MOUNT_KEYS \
    $MOUNT_OUTPUT \
    $MOUNT_PASSWD \
    $MOUNT_GROUP \
    -u $UID:$GID \
    $DOCKER_IMAGE

