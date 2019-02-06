#!/bin/sh

if [ $# -lt 1 ]; then
        echo "[ERROR] - Missing filename argument! Please add a performance test file as argument!"
        exit 1
    else
        read testfile
fi

testfile=/opt/tests/$1.jmx
timestamp=$(date +"%Y%m%d%H%M%S")

if [ -f $testfile ];
    then
        set -e
        free=`awk '/MemFree/ { print int($2/1024) }' /proc/meminfo`
        usable=$(($free/10*8))
        export JVM_ARGS="-Xms${usable}m -Xmx${usable}m"

        echo "Start Running JMeter on `date`..."
        echo "JVM_ARGS=${JVM_ARGS}"

        jmeter -n -t $testfile -l jmeter_log.jtl
        cp jmeter_log.jtl /opt/results/$1_log_$timestamp.jtl
        exit 0

    else
        echo "[ERROR] - Testfile '$testfile' does not exist!"
        exit 1
fi