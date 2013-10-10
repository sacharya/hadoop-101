#!/bin/bash

set -x

now=`date +"%y%m%d-%H%M"`

# 500,000,000 (500 million) No of 100 byte rows = 50 GB
su hdfs - -c "hadoop jar /usr/lib/hadoop/hadoop-examples.jar teragen -D dfs.block.size=536870912 500000000 /terasort/$now/input"
su hdfs - -c "hadoop jar /usr/lib/hadoop/hadoop-examples.jar terasort /terasort/$now/input /terasort/$now/output"

#su hdfs - -c "hadoop jar /usr/lib/hadoop/hadoop-examples.jar teragen -D dfs.block.size=536870912 500000000 /terasort/$now/input"
#su hdfs - -c "hadoop jar /usr/lib/hadoop/hadoop-examples.jar terasort -Dmapred.map.tasks=6 -Dmapred.reduce.tasks=6 /terasort/$now/input /terasort/$now/output"
