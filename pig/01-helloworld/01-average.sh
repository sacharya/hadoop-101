#!/bin/bash

su hdfs - -c "hadoop dfs -ls /user/hdfs"

su hdfs - -c "pig -x mapreduce 01-average_dividend.pig"

su hdfs - -c "hadoop dfs -text /user/hdfs/average_dividend/part*"
