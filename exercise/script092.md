# script092
## 题目

> 注：题目来源于 [SHELL16 判断输入的是否为IP地址 ](https://www.nowcoder.com/practice/ad7b6dbfab2a4267a9991110c57aa64f?tpId=195&tags=&title=&difficulty=&judgeStatus=&rp=1&sourceUrl=%2Fexam%2Foj%3Fpage%3D1%26tab%3DSHELL%25E7%25AF%2587%26topicId%3D195&gioEnter=menu)。

写一个脚本统计文件nowcoder.txt中的每一行是否是正确的IP地址。
- 如果是正确的IP地址输出：yes
- 如果是错误的IP地址，四段号码的话输出：no，否则的话输出：error

假设 nowcoder.txt 内容如下： 
```text
192.168.1.1
192.168.1.0
300.0.0.0
123
```

你的脚本应该输出：
```text
yes
yes
no
error
```





## 脚本一

循环读取文件中的每一行，通过 `awk` 命令编程来判断 IP 地址是否正确。首先 `-F "."` 表示按照点号进行分割，`NF` 是 `awk` 命令的内置变量，表示分割后字段域的个数，如果不足四个，则应该输出 `"error"` 表示错误的。如果字段域的个数是四个，则需要判断每个字段的值是否在 `[0, 255]` 范围内，如果四个字段的值都在这个范围内则表示是正确的 IP 地址则输出 `"yes"`；只要有一个字段的值不在这个范围内则表示是错误的 IP 地址则输出 `"no"`。

```shell
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
```
