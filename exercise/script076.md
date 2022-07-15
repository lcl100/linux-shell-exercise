# script076

## 题目

> 注：题目来源于 [SHELL19 打印等腰三角形](https://www.nowcoder.com/practice/1c55ca2b73a34e80bafd5978810dd8ea?tpId=195&tags=&title=&difficulty=0&judgeStatus=0&rp=1&sourceUrl=%2Fexam%2Foj%3Fpage%3D1%26tab%3DSHELL%25E7%25AF%2587%26topicId%3D195)。

打印边长为5的等腰三角形。

你的脚本应该输出：
```text
    *
   * *
  * * *
 * * * *
* * * * *
```





## 脚本

如果直接使用 `echo` 输出五行的话，那么意义不大。可以通过循环来进行输出，我们探求它们之间的规律，把原来的空格字符替换成井号字符，发型就变成了一个 5 行 9 列的矩阵。

```text
####*####
###*#*###
##*#*#*##
#*#*#*#*#
*#*#*#*#*
```

我们可以把每一行当作三部分来输出，规律如下：

- 第一部分

```text
####
###
##
#

```

- 第二部分

```text
    *
   *#*
  *#*#*
 *#*#*#*
*#*#*#*#*
```

- 第三部分

```text
####
 ###
  ##
   #
    
```

看上面的图形就能发现每行的规律变化了，就能很轻易写出循环代码了。


```shell
#!/bin/bash

for (( i = 1; i <= 5; i++ )); do
	# 第一部分
    for (( j = 1; j <= 5-i; j++ )); do
        printf " "
    done
    # 第二部分
    for (( j = 1; j <= 2*${i}-1; j++ )); do
        if [ $[ ${j} % 2 ] -eq 0 ]; then
            printf " "
        else
            printf "*"
        fi
    done
    # 第三部分
    for (( j = 1; j <= 5-i; j++ )); do
        printf " "
    done
    printf "\n"
done
```

