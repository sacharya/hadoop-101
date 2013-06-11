#!/bin/bash
su hdfs - -c "pig -x mapreduce no-schema.pig"
su hdfs - -c "hadoop dfs -text /user/hdfs/no-schema/part*"
