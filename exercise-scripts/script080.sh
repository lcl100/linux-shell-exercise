#!/bin/bash

# 声明一个关联数组
declare -A map

# 循环读取文件中的每一行，提取每行的 IP 地址，以 IP 地址作为关联数组的键名，对应的出现次数作为键值
while read line; do
  # 如果不是2020年4月23号的记录则跳过
  if ! echo "${line}"| grep "23/Apr/2020" > /dev/null; then
    continue
  fi
  # 提取文本行的 IP 地址
  ip=$(echo "${line}" | awk '{print $1}')
  # 把出现次数记录在关联数组中
  map["${ip}"]=$(( map["${ip}"] + 1 ))
done < nowcoder.txt

# 把IP地址和出现次数记录在这个变量上，为了能排序
result=""
# 循环输出关联数组中的所有元素
for k in ${!map[@]} ; do
  if [ -z "${result}" ]; then
      result="${map[$k]} ${k}"
  else
      result="${result}\n${map[$k]} ${k}"
  fi
done
# 最终对结果进行排序
echo -e "${result}" | sort -nr