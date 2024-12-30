#!/bin/bash

usage () {
    echo "Usage: knulli-mainline-interactive <TARGET> [options]"
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
#OCKER_IMAGE=batoceralinux/batocera.linux-build
GID=`id -g`:

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
    MOUNT_BUILD="--mount type=volume,src=knulli_build-$TARGET,target=/home/ubuntu/build"
else
    MOUNT_BUILD="--mount type=bind,src=./build-$TARGET,target=/home/ubuntu/build"
    mkdir -p ./build-$TARGET
fi

MOUNT_KEYS="--mount type=bind,src=./keys.txt,target=/home/ubuntu/keys.txt"

echo "docker run -it \\"
echo "    $MOUNT_BUILD \\"
echo "    --mount type=volume,src=knulli_toolchain-$TARGET,target=/home/ubuntu/toolchains \\"
echo "    --mount type=volume,src=knulli_buildroot_cache-$TARGET,target=/home/ubuntu/.buildroot-ccache \\"
echo "    $MOUNT_KEYS \\"
echo "    --mount type=bind,src=./output,target=/home/ubuntu/output \\"
echo "    bremedios/knulli-build-interactive:latest"

mkdir -p knulli_build-$TARGET
mkdir -p output-$TARGET

docker run --rm -it \
    	$MOUNT_BUILD \
    --mount type=volume,src=knulli_toolchain-$TARGET,target=/home/ubuntu/toolchains \
    --mount type=volume,src=knulli_buildroot_cache-$TARGET,target=/home/ubuntu/.buildroot-ccache \
    $MOUNT_KEYS \
    --mount type=bind,src=./output-$TARGET,target=/home/ubuntu/output \
    -u $UID:$GID \
    $DOCKER_IMAGE

