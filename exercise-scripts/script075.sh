#!/bin/bash

# 声明关联数组
declare -A arr

# 循环读取文本行
while read line; do
  # 删除 // 前面的所有内容
  line=${line#*//}
  # 删除 / 后面的所有内容
  line=${line%%/*}
  # 存储到关联数组中并计数
  arr[$line]=$[ ${arr[$line]} + 1 ]
done < nowcoder.txt

# 为了能对结果排序，所以要进行处理
result=""
# 循环打印关联数组，对它们进行拼接
for k in ${!arr[@]}; do
  # 如果是第一次则进行赋值
  if [ "${result}" == "" ]; then
    result="${arr[$k]} ${k}"
  # 如果不是第一次则需要对之前的内容进行拼接，通过换行符拼接
  else
    result="${arr[$k]} ${k}""\n${result}"
  fi
done

# 然后使用 sort 命令进行排序
echo -e "${result}" |  sort -r -k 1