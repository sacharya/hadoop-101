#!/bin/bash

cd average

su hdfs - -c "hadoop dfs -put NYSE_dividends NYSE_dividends"

su hdfs - -c "hadoop dfs -ls /user/hdfs"

su hdfs - -c "pig -x mapreduce average_dividend.pig"

su hdfs - -c "hadoop dfs -text /user/hdfs/average_dividend/part*"
