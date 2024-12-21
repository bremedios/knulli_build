#!/bin/bash
CWD=`pwd`

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

TARGETS=()

#   Make sure all of our targets are valid
for arg in "$@"
do
    if [ "$arg" == "h700" ] ; then
        echo "Adding target $arg (h700)"
        TARGETS+=( $arg )
    elif [ "$arg" == "a133" ] ; then
        TARGETS+=( $arg )
        echo "Adding target $arg (a133)"
    else
        echo "Invalid target $arg."
        exit 1
    fi
done

cd build

if [ $? -ne 0 ] ; then
    echo "Failed to change to folder 'build'"
    exit 1
fi

if [ ! -d distribution ] ; then
    echo "git clone $REPO"
    git clone $REPO

    if [ $? -ne 0 ] ; then
        echo "git clone failed for: $REPO"
        exit 1
    fi
else
    cd distribution
    echo "git pull"
    git pull

    if [ $? -ne 0 ] ; then
        echo "git pull failed"
        exit 1
    fi
    
    cd $CWD/build
fi
    
cd distribution

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
    cd $CWD/build/distribution
    echo "Building $TARGET"
    
    # this may fail if emulation station has not been built yet.
    if [ -f $CWD/keys.txt ] ; then
        cp $CWD/keys.txt $CWD/package/batocera/emulationstation/batocera-emulationstation
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
    cp -r build/distribution/output/$TARGET/images/knulli/images/* output/
    
    if [ $? -ne 0 ] ; then
        echo "Failed to copy knulli images for $TARGET"
        exit 1
    fi
    
    # remove any pre-existing toolchains
    rm -fr toolchains/$TARGET
    
    mkdir -p toolchains/$TARGET
    
    echo "Installing toolchain for $TARGET"
    # Installing toolchain for $TARGET
    cp -ar build/distribution/output/$TARGET/host toolchains/$TARGET
    
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



