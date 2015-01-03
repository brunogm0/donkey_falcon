#!/bin/bash
TOOLCHAIN="/home/nando/dev/toolchains/sabermod48/bin"
CLEAN=$1
DEFCONF=$2
JOBS=$3

echo    # (optional) move to a new line
if [[ $CLEAN =~ ^[YySs]$ ]]
then
	make clean && make mrproper
	echo "CLEANING" 
fi

echo    # (optional) move to a new line
if [[ $DEFCONF =~ ^[YySs]$ ]]
then
	make ARCH=arm CROSS_COMPILE=$TOOLCHAIN/arm-linux-androideabi- falcon_defconfig
fi

echo    # (optional) move to a new line
make CONFIG_NO_ERROR_ON_MISMATCH=y ARCH=arm CROSS_COMPILE=$TOOLCHAIN/arm-linux-androideabi- -j$JOBS

