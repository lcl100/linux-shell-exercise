# script080
## 题目

假设 nginx 的日志我们存储在 `nowcoder.txt` 里，格式如下：
```text
192.168.1.20 - - [21/Apr/2020:14:27:49 +0800] "GET /1/index.php HTTP/1.1" 404 490 "-" "Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:45.0) Gecko/20100101 Firefox/45.0"
192.168.1.21 - - [21/Apr/2020:15:27:49 +0800] "GET /2/index.php HTTP/1.1" 404 490 "-" "Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:45.0) Gecko/20100101 Firefox/45.0"
192.168.1.22 - - [21/Apr/2020:21:27:49 +0800] "GET /3/index.php HTTP/1.1" 404 490 "-" "Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:45.0) Gecko/20100101 Firefox/45.0"
192.168.1.23 - - [21/Apr/2020:22:27:49 +0800] "GET /1/index.php HTTP/1.1" 404 490 "-" "Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:45.0) Gecko/20100101 Firefox/45.0"
192.168.1.24 - - [22/Apr/2020:15:27:49 +0800] "GET /2/index.php HTTP/1.1" 404 490 "-" "Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:45.0) Gecko/20100101 Firefox/45.0"
192.168.1.25 - - [22/Apr/2020:15:26:49 +0800] "GET /3/index.php HTTP/1.1" 404 490 "-" "Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:45.0) Gecko/20100101 Firefox/45.0"
192.168.1.20 - - [23/Apr/2020:08:27:49 +0800] "GET /1/index.php HTTP/1.1" 404 490 "-" "Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:45.0) Gecko/20100101 Firefox/45.0"
192.168.1.21 - - [23/Apr/2020:09:20:49 +0800] "GET /1/index.php HTTP/1.1" 404 490 "-" "Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:45.0) Gecko/20100101 Firefox/45.0"
192.168.1.22 - - [23/Apr/2020:10:27:49 +0800] "GET /1/index.php HTTP/1.1" 404 490 "-" "Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:45.0) Gecko/20100101 Firefox/45.0"
192.168.1.22 - - [23/Apr/2020:10:27:49 +0800] "GET /1/index.php HTTP/1.1" 404 490 "-" "Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:45.0) Gecko/20100101 Firefox/45.0"
192.168.1.20 - - [23/Apr/2020:14:27:49 +0800] "GET /1/index.php HTTP/1.1" 404 490 "-" "Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:45.0) Gecko/20100101 Firefox/45.0"
192.168.1.21 - - [23/Apr/2020:15:27:49 +0800] "GET /2/index.php HTTP/1.1" 404 490 "-" "Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:45.0) Gecko/20100101 Firefox/45.0"
192.168.1.22 - - [23/Apr/2020:15:27:49 +0800] "GET /3/index.php HTTP/1.1" 404 490 "-" "Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:45.0) Gecko/20100101 Firefox/45.0"
192.168.1.25 - - [23/Apr/2020:16:27:49 +0800] "GET /1/index.php HTTP/1.1" 404 490 "-" "Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:45.0) Gecko/20100101 Firefox/45.0"
192.168.1.24 - - [23/Apr/2020:20:27:49 +0800] "GET /2/index.php HTTP/1.1" 404 490 "-" "Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:45.0) Gecko/20100101 Firefox/45.0"
192.168.1.25 - - [23/Apr/2020:20:27:49 +0800] "GET /3/index.php HTTP/1.1" 404 490 "-" "Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:45.0) Gecko/20100101 Firefox/45.0"
192.168.1.20 - - [23/Apr/2020:20:27:49 +0800] "GET /1/index.php HTTP/1.1" 404 490 "-" "Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:45.0) Gecko/20100101 Firefox/45.0"
192.168.1.21 - - [23/Apr/2020:20:27:49 +0800] "GET /1/index.php HTTP/1.1" 404 490 "-" "Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:45.0) Gecko/20100101 Firefox/45.0"
192.168.1.22 - - [23/Apr/2020:20:27:49 +0800] "GET /1/index.php HTTP/1.1" 404 490 "-" "Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:45.0) Gecko/20100101 Firefox/45.0"
192.168.1.22 - - [23/Apr/2020:15:27:49 +0800] "GET /1/index.php HTTP/1.1" 404 490 "-" "Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:45.0) Gecko/20100101 Firefox/45.0"
192.168.1.21 - - [23/Apr/2020:20:27:49 +0800] "GET /1/index.php HTTP/1.1" 404 490 "-" "Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:45.0) Gecko/20100101 Firefox/45.0"
```

现在需要你统计出2020年4月23号的访问 ip 次数，并且按照次数降序排序。你的脚本应该输出：

```text
5 192.168.1.22
4 192.168.1.21
3 192.168.1.20
2 192.168.1.25
1 192.168.1.24
```





## 脚本一

首先使用 `grep` 命令检索到2020年4月23号的记录行；接着使用 `awk` 命令打印第一个字段域，即 IP 地址列；接着通过 `sort` 命令排序；再通过 `uniq -c` 命令对排序后的结果进行去重统计出现次数；再通过 `sort -nr` 命令对每个 IP 地址的出现次数逆序排列；最后通过 `sed` 命令去重行首多余的空格。

```shell
grep "23/Apr/2020" nowcoder.txt | awk '{print $1}' | sort | uniq -c | sort -nr | sed 's/[ \t]*//'
```





## 脚本二

通过 shell 编程实现，首先使用 `declare` 命令声明一个关联数组；再循环读取文件中的每一行的 IP 地址，将其出现次数记录在关联数组中；由于要对最终结果降序排列，所以不仅要输出关联数组的键名和对应的键值，还得把它们拼接成一个字符串通过管道符传递给 `sort` 命令排序。

```shell
#!/bin/bash

# 声明一个关联数组
declare -A map

# 循环读取文件中的每一行，提取每行的 IP 地址，以 IP 地址作为关联数组的键名，对应的出现次数作为键值
while read line; do
  # 如果不是2020年4月23号的记录则跳过
  if ! echo "${line}"| grep "23/Apr/2020" > /dev/null; then
    continue 
  fi
  # 提取文本行的 IP 地址
  ip=$(echo "${line}" | awk '{print $1}')
  # 把出现次数记录在关联数组中
  map["${ip}"]=$(( map["${ip}"] + 1 ))
done < nowcoder.txt  

# 把IP地址和出现次数记录在这个变量上，为了能排序
result=""
# 循环输出关联数组中的所有元素
for k in ${!map[@]} ; do
  if [ -z "${result}" ]; then
      result="${map[$k]} ${k}"
  else
      result="${result}\n${map[$k]} ${k}"
  fi
done
# 最终对结果进行排序
echo -e "${result}" | sort -nr
```





## 脚本三

跟脚本二的原理一样，只是通过 `awk` 命令来完成，都是通过关联数组来完成的。

```shell
awk '/23\/Apr\/2020/{map[$1]++} END{for(k in map) print map[k],k}' nowcoder.txt | sort -nr
```