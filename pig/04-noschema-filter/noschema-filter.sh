#!/bin/bash
su hdfs - -c "pig -x mapreduce noschema-filter.pig"

