#!/bin/bash

su hdfs - -c "hadoop dfs -ls /user/hdfs"

#su hdfs - -c "pig -x local 00-wordcount.pig"

su hdfs - -c "pig -x mapreduce 00-wordcount.pig"

su hdfs - -c "hadoop dfs -text /user/hdfs/wordcount/part*"
