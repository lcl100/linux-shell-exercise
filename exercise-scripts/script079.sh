#!/bin/bash

result=$(cat nowcoder.txt | awk -F ":" '{print $1}' | sort | uniq)
for item in ${result} ; do
    echo "[${item}]"
    grep "${item}" nowcoder.txt | awk -F ":" '{print $2}'
done