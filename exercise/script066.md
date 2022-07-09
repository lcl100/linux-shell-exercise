# script066
## 题目

假设 `nowcoder.txt` 内容如下：
```text
root         2  0.0  0.0      0     0 ?        S    9月25   0:00 [kthreadd]
root         4  0.0  0.0      0     0 ?        I<   9月25   0:00 [kworker/0:0H]
web       1638  1.8  1.8 6311352 612400 ?      Sl   10月16  21:52 test
web       1639  2.0  1.8 6311352 612401 ?      Sl   10月16  21:52 test
tangmiao-pc       5336   0.0  1.4  9100240 238544   ??  S     3:09下午   0:31.70 /Applications
```

以上内容是通过 `ps aux | grep -v 'RSS TTY'` 命令输出到 `nowcoder.txt` 文件下面的。 请你写一个脚本计算一下所有进程占用内存大小的和。





## 脚本一

第六列表示进程所占内存，所以使用 `awk` 命令单独提取第六列的内容；再计算提取出来后所有行的总和。

```shell
awk '{print $6}' nowcoder.txt | awk 'BEGIN{sum=0.0} {sum+=$0} END{print sum}'
# 简化后的结果
awk '{sum+=$6} END{print sum}' nowcoder.txt
```





## 脚本二

一样的原理，只是通过 `while` 循环来遍历文件中的每一行；再通过 `awk` 命令提取第六列内容；通过 `$(( ))` 来进行数学运算。

```shell
#!/bin/bash


FILE="nowcoder.txt"

sum=0
while read line; do
    mem=$(echo "${line}" | awk '{print $6}')
    sum=$(( sum + mem ))
done < "${FILE}"

echo "${sum}"
```