#!/bin/bash
su hdfs - -c "hadoop dfs -put input.txt input.txt"
su hdfs - -c "hadoop dfs -put NYSE_dividends NYSE_dividends"
su hdfs - -c "hadoop dfs -put NYSE_daily NYSE_daily"
su hdfs - -c "hadoop dfs -put baseball baseball"
su hdfs - -c "hadoop dfs -put webcrawl webcrawl"
