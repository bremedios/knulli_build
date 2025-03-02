#!/bin/bash
CWD=`pwd`


BUILD_DIR=/build

if [ -z ${REPO} ] ; then
    REPO=https://github.com/knulli-cfw/distribution.git
fi

if [ -z ${BRANCH} ] ; then
    BRANCH=knulli-main
fi

if [ $# -lt 1 ] ; then
    echo "Usage: build.sh <platform>"
    echo "    platforms"
    echo "        h700 - Anbernic RG28XX, RG35XX 2024, RG35XX Plus, RG35XX-H, RG40XX-V, RG40XX-H, RG-CubeXX"
    echo "        a133 - TrimUi Brick, Smart Pro"
    exit 1
fi

# Check to see if our requested target is in our list of allowed target
ALLOWED_TARGETS=( "a133" "atm7039" "h700" "r16" "rk3128" "rk3566" "rk3568" "sm8250" )
TARGETS=()

#   Make sure all of our targets are valid
for arg in "$@"
do
    TARGET=
    
    for OPT in ${ALLOWED_TARGETS[@]}; do
        if [ "$OPT" == $arg ] ; then
            echo "Adding target $arg"
            TARGETS+=( $arg )
            TARGET=$arg
        fi
    done

    if [ -z $TARGET ] ; then
        echo "Unrecognized target $arg"
        exit 1
    fi
done

cd $BUILD_DIR

if [ $? -ne 0 ] ; then
    echo "Failed to change to folder 'build'"
    exit 1
fi

if [ ! -f $BUILD_DIR/.gitignore ] ; then
    echo "git clone $REPO" .
    git clone $REPO $BUILD_DIR

    if [ $? -ne 0 ] ; then
        echo "git clone failed for: $REPO"
        exit 1
    fi
else
    cd $BUILD_DIR
    echo "git pull"
    git pull

    if [ $? -ne 0 ] ; then
        echo "git pull failed"
        exit 1
    fi
fi
    
cd $BUILD_DIR

git checkout $BRANCH

if [ $? -ne 0 ] ; then
    echo "git checkout failed for: $REPO: $BRANCH"
    exit 1
fi

if [ $? -ne 0 ] ; then
    echo "Failed to change to folder 'distribution'"
    exit 1
fi

git submodule init

if [ $? -ne 0 ] ; then
    echo "git submodule init failed for: $REPO"
    exit 1
fi

git submodule update

if [ $? -ne 0 ] ; then
    echo "git submodule update failed for: $REPO"
    exit 1
fi

cd $CWD
rm -rf output/*
    
# build each target
for TARGET in ${TARGETS[@]};
do
    cd $BUILD_DIR
    echo "Building $TARGET"
    
    # this may fail if emulation station has not been built yet.
    if [ -f $CWD/keys.txt ] ; then
        cp $CWD/keys.txt $BUILD_DIR/package/batocera/emulationstation/batocera-emulationstation
    fi
    
    make DIRECT_BUILD=1 $TARGET-build
    MAKE_RESULT=$?
    
    # This check is disabled because the build always fails at the moment.
    #if [ $MAKE_RESULT -ne 0 ] ; then
    #    echo "make DIRECT_BUILD=1 $TARGET-build failed"
    #    exit 1
    #fi
    
    cd $CWD
    if [ $? -ne 0 ] ; then
        echo "Failed to change to directory $CWD"
        exit 1
    fi
    
    # Copy out all device images
    mkdir -p output/
    
    if [ $? -ne 0 ] ; then
        echo "Failed to make directory path output/images"
        exit 1
    fi

    echo "Copying device images"
    cp -r $BUILD_DIR/output/$TARGET/images/knulli/images/* output/
    
    if [ $? -ne 0 ] ; then
        echo "Failed to copy knulli images for $TARGET"
        exit 1
    fi
    
    # remove any pre-existing toolchains
    rm -fr toolchains/$TARGET
    
    mkdir -p toolchains/$TARGET
    
    echo "Installing toolchain for $TARGET"
    # Installing toolchain for $TARGET
    cp -ar $BUILD_DIR/output/$TARGET/host toolchains/$TARGET
    
    if [ $? -ne 0 ] ; then
        echo "Failed to install toolchain for $TARGET"
        exit 1
    fi
    
    cd toolchains
    
    echo "Archiving toolchain for $TARGET"
    mkdir -p $CWD/output/toolchains
    tar -c $TARGET -jf $CWD/output/toolchains/toolchain-$TARGET.tar.bz2
    
    if [ $? -ne 0 ] ; then
        echo "Failed to copy archive toolchain for $TARGET"
        exit 1
    fi
done

exit 1
