#!/bin/bash

su hdfs - -c "hadoop dfs -ls /user/hdfs"

su hdfs - -c "pig -x local wordcount.pig"

su hdfs - -c "pig -x mapreduce wordcount.pig"

su hdfs - -c "hadoop dfs -text /user/hdfs/wordcount/part*"
