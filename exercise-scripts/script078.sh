#!/bin/bash

awk -F "" '{
    k=0
    # 倒序输出每位字符
    for (i=NF; i>0; i--) {
        k++
        # 拼接之前的字符串
        str = sprintf("%s%s", $i, str)
        # 每三位添加一个千位分隔符
        if (k%3 == 0 && i>=2 && NF > 3) {
            str = sprintf(",%s", str)
        }
    }
    print(str)
    str=""
}' nowcoder.txt