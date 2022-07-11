# script076
## 题目

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
```text
####*####
###*#*###
##*#*#*##
#*#*#*#*#
*#*#*#*#*
```

```shell
#!/bin/bash

for (( i = 1; i <= 5; i++ )); do
    for (( j = 1; j <= 5-i; j++ )); do
        printf " "
    done
    for (( j = 1; j <= 2*${i}-1; j++ )); do
        if [ $[ ${j} % 2 ] -eq 0 ]; then
            printf " "
        else
            printf "*"
        fi
    done
    for (( j = 1; j <= 5-i; j++ )); do
        printf " "
    done
    printf "\n"
done
```