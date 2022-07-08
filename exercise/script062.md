# script062
## 题目

写一个 bash脚本以输出一个文本文件 `nowcoder.txt` 中第5行的内容。

示例， 假设 `nowcoder.txt` 内容如下：
```text
welcome
to
nowcoder
this
is
shell
code
```

你的脚本应当输出：
```text
is
```

## 脚本一
```shell
cat -n nowcoder.txt | egrep '[ ]+5' | awk '{print $2}'
```

## 脚本二
```shell
 head -n 5 nowcoder.txt | tail -n 1
```

## 脚本三
```shell
sed -n '5p' nowcoder.txt
```

## 脚本四
```shell
awk 'NR==5{print $0}' nowcoder.txt
```

## 脚本五
```shell
#!/bin/bash

i=0
while read line; do
  i=$((${i}+1))
  if [ $i -eq 5 ]; then
      echo "${line}"
      exit
  fi
done < nowcoder.txt
```


## 脚本六
```shell
awk '{if(NR==5) print $0}' nowcoder.txt
```