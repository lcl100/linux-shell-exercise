# script061
## 题目

> 题目来源于 [SHELL3 输出7的倍数 ](https://www.nowcoder.com/practice/8b85768394304511b0eb887244e51872?tpId=195&tags=&title=&difficulty=0&judgeStatus=0&rp=1&sourceUrl=%2Fexam%2Foj%3Fpage%3D1%26tab%3DSHELL%25E7%25AF%2587%26topicId%3D195)。

写一个 bash 脚本以输出数字 0 到 500 中 7 的倍数(0 7 14 21...)的命令。





## 脚本一

`seq` 命令可以输出数字序列。请参考：[Linux命令之产生序列化数seq](https://blog.csdn.net/cnds123321/article/details/125116743)。

```shell
seq 0 7 500
```





## 脚本二

还可以循环 0 到 500 之间的每一个数字，判断它对 7 取余的结果是否为 0，如果是则为所求，那么输出该数；否则继续判断下一个数。

```shell
#!/bin/bash

for num in {0..500} ; do
    if [ $((${num} % 7)) -eq 0 ]; then
        echo "${num}"
    fi
done
```





## 脚本三

使用 `seq` 输出 0 到 500 之间的每一个数字，然后使用 `awk` 命令编程判断每个数字是否为所求的数字，如果是则输出结果。

```shell
seq 0 500 | awk '{if($0%7==0) print $0}'
```





## 脚本四

`{0..500..7}` 也可以输出我们想要的数字序列，但它们却是在一行显示并且使用空格分隔，所以如果要它们单独一行显示，需要使用 `tr` 命令的 `-s` 选项将空格替换成换行符就行了。

```shell
echo {0..500..7} | tr -s ' ' '\n'
```





## 脚本五

`sed` 命令也可以提取到结果。

```shell
seq 0 500 | sed -n '1~7p'
```