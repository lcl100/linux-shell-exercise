# script085
## 题目

> 注：题目来源于 [SHELL28 nginx日志分析6-统计每分钟的请求数 ](https://www.nowcoder.com/practice/9a37600d342c47ed9e9a0fd33c1c189e?tpId=195&tags=&title=&difficulty=0&judgeStatus=0&rp=1&sourceUrl=%2Fexam%2Foj%3Fpage%3D1%26tab%3DSHELL%25E7%25AF%2587%26topicId%3D195)。

假设 nginx 的日志我们存储在 `nowcoder.txt` 里，格式如下：
```text
192.168.1.20 - - [21/Apr/2020:14:12:49 +0800] "GET /1/index.php HTTP/1.1" 404 490 "-" "Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:45.0) Gecko/20100101 Firefox/45.0"
192.168.1.21 - - [21/Apr/2020:15:00:49 +0800] "GET /2/index.php HTTP/1.1" 404 490 "-" "Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:45.0) Gecko/20100101 Firefox/45.0"
192.168.1.22 - - [21/Apr/2020:21:21:49 +0800] "GET /3/index.php HTTP/1.1" 404 490 "-" "Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:45.0) Gecko/20100101 Firefox/45.0"
192.168.1.23 - - [21/Apr/2020:22:10:49 +0800] "GET /1/index.php HTTP/1.1" 404 490 "-" "Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:45.0) Gecko/20100101 Firefox/45.0"
192.168.1.24 - - [22/Apr/2020:15:00:49 +0800] "GET /2/index.php HTTP/1.1" 404 490 "-" "Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:45.0) Gecko/20100101 Firefox/45.0"
192.168.1.25 - - [22/Apr/2020:15:26:49 +0800] "GET /3/index.php HTTP/1.1" 404 490 "-" "Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:45.0) Gecko/20100101 Firefox/45.0"
192.168.1.20 - - [23/Apr/2020:08:05:49 +0800] "GET /2/index.php HTTP/1.1" 404 490 "-" "Baiduspider"
192.168.1.21 - - [23/Apr/2020:09:20:49 +0800] "GET /1/index.php HTTP/1.1" 404 490 "-" "Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:45.0) Gecko/20100101 Firefox/45.0"
192.168.1.22 - - [23/Apr/2020:10:27:49 +0800] "GET /1/index.php HTTP/1.1" 404 490 "-" "Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:45.0) Gecko/20100101 Firefox/45.0"
192.168.1.22 - - [23/Apr/2020:10:27:49 +0800] "GET /1/index.php HTTP/1.1" 404 490 "-" "Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:45.0) Gecko/20100101 Firefox/45.0"
192.168.1.20 - - [23/Apr/2020:14:12:49 +0800] "GET /1/index.php HTTP/1.1" 404 490 "-" "Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:45.0) Gecko/20100101 Firefox/45.0"
192.168.1.21 - - [23/Apr/2020:15:00:49 +0800] "GET /2/index.php HTTP/1.1" 404 490 "-" "Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:45.0) Gecko/20100101 Firefox/45.0"
192.168.1.22 - - [23/Apr/2020:15:00:49 +0800] "GET /3/index.php HTTP/1.1" 404 490 "-" "Baiduspider"
192.168.1.25 - - [23/Apr/2020:16:15:49 +0800] "GET /1/index.php HTTP/1.1" 404 490 "-" "Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:45.0) Gecko/20100101 Firefox/45.0"
192.168.1.24 - - [23/Apr/2020:20:27:49 +0800] "GET /2/index.php HTTP/1.1" 404 490 "-" "Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:45.0) Gecko/20100101 Firefox/45.0"
192.168.1.25 - - [23/Apr/2020:20:27:49 +0800] "GET /3/index.php HTTP/1.1" 404 490 "-" "Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:45.0) Gecko/20100101 Firefox/45.0"
192.168.1.20 - - [23/Apr/2020:20:27:49 +0800] "GET /1/index.php HTTP/1.1" 404 490 "-" "Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:45.0) Gecko/20100101 Firefox/45.0"
192.168.1.21 - - [23/Apr/2020:20:27:49 +0800] "GET /1/index.php HTTP/1.1" 404 490 "-" "Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:45.0) Gecko/20100101 Firefox/45.0"
192.168.1.22 - - [23/Apr/2020:20:27:49 +0800] "GET /1/index.php HTTP/1.1" 404 490 "-" "Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:45.0) Gecko/20100101 Firefox/45.0"
192.168.1.22 - - [23/Apr/2020:22:10:49 +0800] "GET /1/index.php HTTP/1.1" 404 490 "-" "Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:45.0) Gecko/20100101 Firefox/45.0"
192.168.1.21 - - [23/Apr/2020:23:59:49 +0800] "GET /1/index.php HTTP/1.1" 404 490 "-" "Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:45.0) Gecko/20100101 Firefox/45.0"
```

现在需要你统计每分钟的请求数，并且按照请求数降序排序。你的脚本应该输出：
```text
5 20:27
4 15:00
2 22:10
2 14:12
2 10:27
1 23:59
1 21:21
1 16:15
1 15:26
1 09:20
1 08:05
```





## 脚本一

通过 `awk` 命令查找文本行表示小时和分钟的列；再通过 `sort` 命令排序；`uniq -c` 去重并统计出现次数；最后通过 `sed` 命令去除行首的空格。

```shell
awk -F ":" '{print $2":"$3}' nowcoder.txt | sort | uniq -c | sort -nr | sed 's/[ \t]*//'
```





## 脚本二

通过关联数组完成，将小时和分钟组成的字符串放进关联数组中，并统计其出现次数；然后在 `END{}` 中循环遍历关联数组打印请求数和分钟；最后通过 `sort` 命令降序排序。

```shell
awk -F ":" '{map[$2":"$3]++} END{for(k in map) print map[k],k}' nowcoder.txt | sort -nr
```