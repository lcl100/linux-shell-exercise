# script063
## 题目

写一个 bash 脚本以输出一个文本文件 `nowcoder.txt` 中空行的行号，可能连续，从1开始。

示例，假设 nowcoder.txt 内容如下：
```text
a
b

c

d

e


f
```

你的脚本应当输出：
```text
3
5
7
9
10
```

## 脚本一
```shell
 grep -n "^$" nowcoder.txt | tr -d ':'
```

## 脚本二
```shell
 awk '{if(length($0)==0) print NR}' nowcoder.txt
```

## 脚本三
```shell
awk '/^$/ {print NR}' nowcoder.txt
```

## 脚本四
```shell
awk 'NF==0{print NR}' nowcoder.txt
```

## 脚本五
```shell
#!/bin/bash

i=0
while read line; do
  i=$((${i}+1))
  if [ -z "${line}" ]; then
      echo "${i}"
  fi
done < nowcoder.txt
```