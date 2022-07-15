# script072
## 题目

> 注：题目来源于 [SHELL14 求平均值](https://www.nowcoder.com/practice/c44b98aeaf9942d3a61548bff306a7de?tpId=195&tags=&title=&difficulty=0&judgeStatus=0&rp=1&sourceUrl=%2Fexam%2Foj%3Fpage%3D1%26tab%3DSHELL%25E7%25AF%2587%26topicId%3D195)。

写一个bash脚本以实现一个需求，求输入的一个的数组的平均值。

第 1 行为输入的数组长度 N；第 2~N 行为数组的元素，如以下为：数组长度为 4，数组元素为 1 2 9 8。示例：
```text
4
1
2
9
8
```

那么平均值为：5.000(保留小数点后面3位)。你的脚本获取以上输入应当输出：
```text
5.000
```





## 脚本一

本题考查的就是 `read`、`for` 循环、`$[ ]` 计算、`bc` 命令等。

```shell
#!/bin/bash

# 获取输入的数组长度
read length

# 变量，记录输入的总和
sum=0
# 循环输入
for (( i = 0; i < ${length}; i++ )); do
	# 读取输入的数字
    read num
    # 计算到总和中
    sum=$[ sum + num ]
done
# 计算平均值
avg=$(echo "scale=3;${sum}/${length}" | bc)
echo ${avg}
```