#!/bin/bash


####################################
#
# 功能：写一个脚本，检查文件第二列是否有重复，且有几个重复，并提取出重复的行的第二列信息。
#
# 使用：直接调用脚本，不需要任何参数
#
# 作者：lcl100
#
# 日期：2022-07-09
#
####################################


awk '{map[$2]++} END{for(k in map) if(map[k]>=2) printf("%d %s\n", map[k], k)}' nowcoder.txt