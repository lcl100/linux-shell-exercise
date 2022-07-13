#!/bin/bash

grep "192.168.1.22" nowcoder.txt  | awk '{print $7}' | sort | uniq -c | sort -nr | awk '{print $1,$2}'grep "192.168.1.22" nowcoder.txt  | awk '{print $7}' | sort | uniq -c | sort -nr | awk '{print $1,$2}'