# script065
## 题目

写一个 bash脚本以统计一个文本文件 `nowcoder.txt` 中字母数小于 `8` 的单词。

示例，假设 nowcoder.txt 内容如下：
```text
how they are implemented and applied in computer
```

你的脚本应当输出：
```text
how
they
are
and
applied
in
```

> 说明：不要担心你输出的空格以及换行的问题


## 脚本一
```shell
cat nowcoder.txt | tr -s ' ' '\n' | awk '{if(length($0)<8) print $0}'
```

## 脚本二
```shell
#!/bin/bash


FILE="nowcoder.txt"

words=$(cat "${FILE}" | tr -s ' ' '\n')
for word in ${words} ; do
    if [ ${#word} -lt 8 ]; then
        echo "${word}"
    fi
done
```

## 脚本三
```shell
tr " " "\n" < nowcoder.txt | awk '/^.{0,7}$/'
```