#!/bin/bash

set -x

su hdfs - -c "hadoop fs -rmr /shakespeare"
cd /tmp
wget http://homepages.ihug.co.nz/~leonov/shakespeare.tar.bz2
tar xjvf shakespeare.tar.bz2
now=`date +"%y%m%d-%H%M"`
su hdfs - -c "hadoop fs -put /tmp/Shakespeare /shakespeare/$now/input"
su hdfs - -c "hadoop jar /usr/lib/hadoop/hadoop-examples.jar wordcount /shakespeare/$now/input /shakespeare/$now/output"
su hdfs - -c "hadoop fs -cat /shakespeare/$now/output/part-r-* | sort -nk2"
