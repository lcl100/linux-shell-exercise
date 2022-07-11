# script075
## 题目

假设我们有一些域名，存储在 `nowcoder.txt` 里，现在需要你写一个脚本，将域名取出并根据域名进行计数排序处理。

假设nowcoder.txt内容如下：
```text
http://www.nowcoder.com/index.html
http://www.nowcoder.com/1.html
http://m.nowcoder.com/index.html
```

你的脚本应该输出：
```text
2 www.nowcoder.com
1 m.nowcoder.com
```


## 脚本一
```shell
awk -F "/" '{print $3}' nowcoder.txt | sort | uniq -c | sort -nr | sed 's/^[ \t]*//g'
```


## 脚本二
```shell
awk -F "/" '{
  for(i=1;i<=NF;i++){
    if(i==3){
      arr[$i]++
    }
  }
} END{
  for(k in arr){
    printf("%d %s\n", arr[k], k)
  }
}' nowcoder.txt | sort -r -k 1
```

## 脚本三
```shell
#!/bin/bash

declare -A arr 

while read line; do 
  line=${line#*//}
  line=${line%/*}
  arr[$line]=$[ ${arr[$line]} + 1 ]
done < nowcoder.txt

# 为了能对结果排序，所以要进行处理
result=""
for k in ${!arr[@]}; do 
  if [ "${result}" == "" ]; then
    result="${arr[$k]} ${k}"
  else
    result="${arr[$k]} ${k}""\n${result}" 
  fi
done

echo -e "${result}" |  sort -r -k 1
```