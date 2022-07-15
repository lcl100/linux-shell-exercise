# script064
## 题目

> 题目来源于 [SHELL6 去掉空行 ](https://www.nowcoder.com/practice/0372acd5725d40669640fd25e9fb7b0f?tpId=195&tags=&title=&difficulty=0&judgeStatus=0&rp=1&sourceUrl=%2Fexam%2Foj%3Fpage%3D1%26tab%3DSHELL%25E7%25AF%2587%26topicId%3D195)。

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

这里采用的是匹配空行然后删除空白行，最后剩下的就是非空行。其中 `^$` 表示匹配空行；`d` 命令表示删除匹配行。

```shell
sed '/^$/d' nowcoder.txt 
```





## 脚本二

`awk` 命令可以找出文件中的非空行，其中 `/[^\s]/` 表示匹配非空行（`^\s` 表示匹配以非空字符开头的所有行）；然后使用 `{print $0}` 表示打印非空行。

```shell
awk '/[^\s]/{print $0}' nowcoder.txt
```





## 脚本三

同样使用正则表达式匹配文件中的非空行，通过 `grep -E` 命令查找。

```shell
grep -E "[^\s]+" nowcoder.txt 
```





## 脚本四

使用 `awk` 命令完成。

```shell
cat nowcoder.txt | awk NF
```





## 脚本五

使用 `sed` 命令只打印匹配到正则表达式的行。

```shell
sed -n '/[^$]/p' nowcoder.txt
```





## 脚本六

使用 `grep` 命令匹配空行，然后使用 `-v` 选项表示反选非空行。

```shell
grep -v '^$' nowcoder.txt
```





## 脚本七

循环读取文件中的每一行，然后用 `-n` 判断该行是否是非空行，如果是则进行输出。

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

使用 `awk` 进行编程，通过 `length()` 函数判断遍历的行是否是非空行，如果是则进行输出。

```shell
awk '{if(length($0)!=0) print $0}' nowcoder.txt
```