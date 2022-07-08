# script064
## 题目

写一个 bash 脚本以去掉一个文本文件 `nowcoder.txt` 中的空行。

示例，假设 nowcoder.txt 内容如下：
```text
abc

567


aaa
bbb



ccc
```

你的脚本应当输出：
```text
abc
567
aaa
bbb
ccc
```


## 脚本一
```shell
sed '/^$/d' nowcoder.txt 
```

## 脚本二
```shell
awk '/[^\s]/{print $0}' nowcoder.txt
```

## 脚本三
```shell
egrep "[^\s]+" nowcoder.txt 
```

## 脚本四
```shell
cat nowcoder.txt | awk NF
```

## 脚本五
```shell
sed -n '/[^$]/p' nowcoder.txt
```

## 脚本六
```shell
grep -v '^$' nowcoder.txt
```

## 脚本七
```shell
#!/bin/bash

i=0
while read line; do
  i=$((${i}+1))
  if [ -n "${line}" ]; then
      echo "${line}"
  fi
done < nowcoder.txt
```

## 脚本八
```shell
 awk '{if(length($0)!=0) print $0}' nowcoder.txt
```