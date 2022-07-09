#!/bin/bash


####################################
#
# 功能：写一个脚本，统计一个文本文件 `nowcoder.txt` 中每个单词出现的个数。
#
# 使用：直接调用脚本，不需要任何参数
#
# 作者：lcl100
#
# 日期：2022-07-09
#
####################################


awk '{
  for(i=1;i<=NF;i++)
    map[$i]++;
}
END{
  for(key in map)
    printf("%s %d\n", key, map[key]);
}' nowcoder.txt | sort -n -k 2