# script081
## 题目

假设 nginx 的日志我们存储在 nowcoder.txt 里，格式如下：

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
192.168.1.22 - - [23/Apr/2020:22:27:49 +0800] "GET /1/index.php HTTP/1.1" 404 490 "-" "Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:45.0) Gecko/20100101 Firefox/45.0"
192.168.1.21 - - [23/Apr/2020:23:27:49 +0800] "GET /1/index.php HTTP/1.1" 404 490 "-" "Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:45.0) Gecko/20100101 Firefox/45.0"
```

现在你需要统计2020年04月23日20-23点的去重IP访问量，你的脚本应该输出
```text
5
```


## 脚本一
```shell
grep "23/Apr/2020:2[0-3]" nowcoder.txt | awk '{print $1}' | sort | uniq | wc -l
```


## 脚本二
```shell
awk '/23\/Apr\/2020:2[0-3]/{print $1}' nowcoder.txt | sort | uniq | wc -l
```

## 脚本三
```shell
declare -A map
while read line
    do
        a=($line)
        [[ ${a[3]} =~ 23/Apr/2020:2[0-2] ]] && ((map["${a[0]}"]++))
    done < nowcoder.txt
printf "${#map[*]}"
```