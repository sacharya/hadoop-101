#!/bin/bash

#set -x

su hdfs - -c "hadoop fs -rmr /terasort"

sleep 10

now=`date +"%y%m%d-%H%M"`

#su hdfs - -c "hadoop jar /usr/lib/hadoop/hadoop-examples.jar teragen -Ddfs.block.size=536870912 -Dmapred.map.tasks=6 -Dmapred.reduce.tasks=6 300000000 /terasort/$now/input"
#su hdfs - -c "hadoop jar /usr/lib/hadoop/hadoop-examples.jar terasort -Ddfs.block.size=536870912 -Dmapred.map.tasks=6 -Dmapred.reduce.tasks=6 /terasort/$now/input /terasort/$now/output"

read -p "Data Size in GB eg. 50: " SIZE_IN_GB

size=`expr $SIZE_IN_GB \* 10000000`
echo $size
su hdfs - -c "hadoop jar /usr/lib/hadoop/hadoop-examples.jar teragen -Dmapred.map.tasks=6 -Dmapred.reduce.tasks=6 $size /terasort/$now/input"

T="$(date +%s)"
su hdfs - -c "hadoop jar /usr/lib/hadoop/hadoop-examples.jar terasort -Dmapred.map.tasks=6 -Dmapred.reduce.tasks=6 /terasort/$now/input /terasort/$now/output"
T="$(($(date +%s)-T))"
echo "Data Size: $gb GB. Time Taken: ${T} Seconds"
