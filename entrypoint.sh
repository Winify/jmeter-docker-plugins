#!/bin/sh

if [ $# -lt 1 ]; then
        echo "[ERROR] - Missing filename argument! Please add a performance test file as argument!"
        exit 1
    else
        read testfile
fi

timestamp=$(date +"%Y%m%d%H%M%S")

mkdir /opt/results/$timestamp
results=/opt/results/$timestamp

mkdir $results/report
cp /opt/tests/$1.jmx $results/test.jmx

testfile=$results/test.jmx

if [ -f $testfile ];
    then
        echo "Start Running JMeter on `date`..."

        echo "Setting Server Hostname set to: $PROTOCOL://$DOMAIN:$PORT"
        sed -r "s|protocol\">(.*)</|protocol\">$PROTOCOL</|" -i $testfile
        sed -r "s|domain\">(.*)</|domain\">$DOMAIN</|" -i $testfile
        sed -r "s|port\">(.*)</|port\">$PORT</|" -i $testfile

        # Setting JVM ARGS
        set -e
        free=`awk '/MemFree/ { print int($2/1024) }' /proc/meminfo`
        usable=$(($free/10*8))
        export JVM_ARGS="-Xms${usable}m -Xmx${usable}m"
        echo "Setting JVM_ARGS to: ${JVM_ARGS}"

        echo "Running JMeter Test suite: $1.jmx"
        jmeter -n -t $testfile -l jmeter_log.jtl -e -o $results/report

        echo "Reporting output to: $results/report"
        cp jmeter_log.jtl $results/$1_log.jtl
        exit 0

    else
        echo "[ERROR] - Testfile '$testfile' does not exist!"
        exit 1
fi