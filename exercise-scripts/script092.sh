#!/bin/bash

# 循环读取文件每一行
while read line; do
  # 用点号分割每一行的内容
  echo "${line}" | awk -F "." '{
  # 如果切割后的字段域个数不是四个则输出 "error"
  if(NF!=4){
    print "error"
  }
  # 如果字段域的个数是四个，则判断 IP 地址是否正确
  else{
  	# 循环每一个字段
    for(i=1;i<=NF;i++){
      # 判断该字段的范围是否在 [0, 255] 范围内，如果是则进行计数
      if($i>=0&&$i<=255){
        count++
      }
    }
    # 最后判断计数变量 count 是否等于 4，如果是则表示该 IP 地址是正确的，否则不正确
    if(count==4){
      print "yes"
    } else{
      print "no"
    }
  }
}'
done < nowcoder.txt