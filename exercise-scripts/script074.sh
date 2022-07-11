#!/bin/bash

# 读取文件的每一行
while read line; do
  # 逆序文件行
  newline=$(echo "${line}" | tr -s ":" "\n" | tac | tr -s "\n" ":")
  # 删除行末尾的字符
  echo "${newline::-1}"
done < nowcoder.txt