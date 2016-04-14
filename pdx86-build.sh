#!/bin/bash

LOG="pdx86-build-$(date -I).log"
CPUS=$(grep -c processor /proc/cpuinfo)

build() {
	echo -n "$1: "
	echo $1 >> $LOG
	make $1 &>> $LOG
	make -j$CPUS &>> $LOG && make -j$CPUS modules &>> $LOG
	if [ $? -ne 0 ]; then
		echo FAIL | tee -a $LOG
		exit 1
	else
		echo PASS | tee -a $LOG
	fi
}

if [ -e $LOG ]; then
	LOG=$(mktemp pdx86-build-$(date -I)-XXX.log)
fi

echo "Logfile: $LOG"

date | tee $LOG
build allyesconfig
build allmodconfig
date | tee $LOG
