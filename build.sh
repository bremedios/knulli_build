#!/bin/bash
CWD=`pwd`

if [ $# -ne 1 ] ; then
	echo "Usage: build.sh <platform>"
	echo "    platforms"
	echo "        h700 - RG35XX 20224, RG35XX Plus, RG35XX-H, RG40XX-V, RG40XX-H, RG-CubeXX"
	echo "        a133 - TrimUi Brick, TrimUi Smart Pro"
	exit 1
fi

TARGET=$1

if [ "$TARGET" != "h700" ] && [ "$TARGET" != "a133" ] ; then
	echo "Invalid target $TARGET.  Cannot proceed"
	exit 1
fi


RUN git clone https://github.com/knulli-cfw/distribution.git

cd distribution
git submodule init
git submodule update

make DIRECT_BUILD=1 $TARGET-build
cd $CWD

