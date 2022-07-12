#!/bin/bash

# 声明关联数组
declare -A map

# 循环读取文件中的每一行
while read line; do
	# 转换成数组
	a=($line)
	# 如果该行的日期是2020年04月23日20-23点，那么则将IP地址存入到关联数组中，并统计出现次数
	[[ ${a[3]} =~ 23/Apr/2020:2[0-2] ]] && ((map["${a[0]}"]++))
done < nowcoder.txt

# 最后打印关联数组的长度
printf "${#map[*]}"