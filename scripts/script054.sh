#!/bin/bash

####################################
#
# 功能：对于按单词出现频率降序排序。
#
# 使用：直接调用脚本，不需要任何参数
#
# 作者：lcl100
#
# 日期：2022-06-04
#
####################################


# 变量，记录句子
words="No. The Bible says Jesus had compassion2 on them for He saw them as sheep without a shepherd. They were like lost sheep, lost in their sin. How the Lord Jesus loved them! He knew they were helpless and needed a shepherd. And the Good Shepherd knew He had come to help them. But not just the people way back then. For the Lord Jesus knows all about you, and loves you too, and wants to help you."

# 先将空格换成换行符，再去除掉标点符号，再排序，再统计每个单词的出现次数，再降序排序
echo "$words" | tr -s " " "\n" | tr -d "[:punct:]" | sort | uniq -c | sort -nr
