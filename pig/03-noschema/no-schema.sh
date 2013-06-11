#!/bin/bash
cd 03-noschema
su hdfs - -c "pig -x no_schema.pig"
su hdfs - -c "hadoop dfs -text /user/hdfs/no_schema/part*"
