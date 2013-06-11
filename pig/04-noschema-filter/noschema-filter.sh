#!/bin/bash
cd 04-noschema-filter
su hdfs - -c "pig -x mapreduce noschema-filter.pig"

