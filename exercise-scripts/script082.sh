#!/bin/bash

# 声明关联数组
declare -A map

# 循环读取文件中的每一行，将 IP 地址及其出现次数保存在关联数组中
while read line; do
  # 提取 IP 地址
  ip=$(echo "${line}" | awk '{print $1}')
  # 存储 IP 地址的出现次数
  map["${ip}"]=$(( map["${ip}"] + 1 ))
done < nowcoder.txt

# 循环遍历关联数组中的 IP 地址和出现次数
result=""
for k in ${!map[@]} ; do
  # 如果出现次数小于 3 则跳过不输出
  if [ ! ${map[$k]} -gt 3 ]; then
      continue
  fi
  if [ -z "${result}" ]; then
      result="${map[$k]} ${k}"
  else
      result="${result}\n${map[$k]} ${k}"
  fi
done

# 打印结果并排序
echo -e "${result}" | sort -nr