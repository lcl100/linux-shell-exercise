# script084
## 题目

假设 nginx 的日志我们存储在 nowcoder.txt 里，格式如下：
```text
192.168.1.20 - - [21/Apr/2020:14:12:49 +0800] "GET /1/index.php HTTP/1.1" 301 490 "-" "Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:45.0) Gecko/20100101 Firefox/45.0"
192.168.1.21 - - [21/Apr/2020:15:00:49 +0800] "GET /2/index.php HTTP/1.1" 500 490 "-" "Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:45.0) Gecko/20100101 Firefox/45.0"
192.168.1.22 - - [21/Apr/2020:21:21:49 +0800] "GET /3/index.php HTTP/1.1" 404 490 "-" "Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:45.0) Gecko/20100101 Firefox/45.0"
192.168.1.23 - - [21/Apr/2020:22:10:49 +0800] "GET /1/index.php HTTP/1.1" 404 490 "-" "Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:45.0) Gecko/20100101 Firefox/45.0"
192.168.1.24 - - [22/Apr/2020:15:00:49 +0800] "GET /2/index.php HTTP/1.1" 200 490 "-" "Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:45.0) Gecko/20100101 Firefox/45.0"
192.168.1.25 - - [22/Apr/2020:15:26:49 +0800] "GET /3/index.php HTTP/1.1" 404 490 "-" "Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:45.0) Gecko/20100101 Firefox/45.0"
192.168.1.20 - - [23/Apr/2020:08:05:49 +0800] "GET /2/index.php HTTP/1.1" 404 490 "-" "Mozilla/5.0 (compatible; Baiduspider/2.0; +http://www.baidu.com/search/spider.html)"
192.168.1.21 - - [23/Apr/2020:09:20:49 +0800] "GET /1/index.php HTTP/1.1" 404 490 "-" "Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:45.0) Gecko/20100101 Firefox/45.0"
192.168.1.22 - - [23/Apr/2020:10:27:49 +0800] "GET /1/index.php HTTP/1.1" 200 490 "-" "Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:45.0) Gecko/20100101 Firefox/45.0"
192.168.1.22 - - [23/Apr/2020:10:27:49 +0800] "GET /1/index.php HTTP/1.1" 404 490 "-" "Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:45.0) Gecko/20100101 Firefox/45.0"
192.168.1.20 - - [23/Apr/2020:14:12:49 +0800] "GET /1/index.php HTTP/1.1" 200 490 "-" "Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:45.0) Gecko/20100101 Firefox/45.0"
192.168.1.21 - - [23/Apr/2020:15:00:49 +0800] "GET /2/index.php HTTP/1.1" 404 490 "-" "Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:45.0) Gecko/20100101 Firefox/45.0"
192.168.1.22 - - [23/Apr/2020:15:00:49 +0800] "GET /3/index.php HTTP/1.1" 404 490 "-" "Mozilla/5.0 (compatible; Baiduspider/2.0; +http://www.baidu.com/search/spider.html)"
192.168.1.22 - - [23/Apr/2020:15:00:49 +0800] "GET /3/index.php HTTP/1.1" 200 490 "-" "Mozilla/5.0 (compatible; Baiduspider/2.0; +http://www.baidu.com/search/spider.html)"
192.168.1.24 - - [23/Apr/2020:20:27:49 +0800] "GET /2/index.php HTTP/1.1" 404 490 "-" "Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:45.0) Gecko/20100101 Firefox/45.0"
192.168.1.25 - - [23/Apr/2020:20:27:49 +0800] "GET /3/index.php HTTP/1.1" 200 490 "-" "Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:45.0) Gecko/20100101 Firefox/45.0"
192.168.1.20 - - [23/Apr/2020:20:27:49 +0800] "GET /1/index.php HTTP/1.1" 300 490 "-" "Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:45.0) Gecko/20100101 Firefox/45.0"
192.168.1.21 - - [23/Apr/2020:20:27:49 +0800] "GET /1/index.php HTTP/1.1" 404 490 "-" "Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:45.0) Gecko/20100101 Firefox/45.0"
192.168.1.22 - - [23/Apr/2020:20:27:49 +0800] "GET /1/index.php HTTP/1.1" 500 490 "-" "Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:45.0) Gecko/20100101 Firefox/45.0"
192.168.1.22 - - [23/Apr/2020:22:10:49 +0800] "GET /1/index.php HTTP/1.1" 404 490 "-" "Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:45.0) Gecko/20100101 Firefox/45.0"
192.168.1.21 - - [23/Apr/2020:23:59:49 +0800] "GET /1/index.php HTTP/1.1" 404 490 "-" "Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:45.0) Gecko/20100101 Firefox/45.0"
```


现在需要你统计百度爬虫抓取 404 的次数，你的脚本应该输出：
```text
2
```





## 脚本一

先通过 `grep` 命令查找到有百度地址的记录行；然后再通过 `grep -c` 命令统计这些行中出现了 404 的行数。

```shell
grep "www.baidu.com/search/spider.html" nowcoder.txt | grep -c "404" 
```





## 脚本二

直接使用 `grep -c -E` 命令通过正则表达式匹配百度爬虫抓取 404 的行数。

```shell
grep -c -E "404.*www.baidu.com/search/spider.html" nowcoder.txt 
```





## 脚本三

通过 `awk` 命令来匹配正则表达式行，并打印行数。

```shell
awk '/404.*www.baidu.com\/search\/spider.html/{print NR}' nowcoder.txt | wc -l
```