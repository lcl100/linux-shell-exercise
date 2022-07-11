#!/bin/bash

# 获取文件的列数
column_count=$(awk 'END{print NF}' nowcoder.txt)

for i in $(seq ${column_count}); do
  line=$(cat nowcoder.txt | cut -d " " -f ${i} | tr -s "\n" " ")
  echo ${line}
done