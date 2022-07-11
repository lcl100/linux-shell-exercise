# script0
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
192.168.1.22 - - [23/Apr/2020:22:27:49 +0800] "GET /1/index.php HTTP/1.1" 404 490 "-" "Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:45.0) Gecko/20100101 Firefox/45.0"
192.168.1.21 - - [23/Apr/2020:23:27:49 +0800] "GET /1/index.php HTTP/1.1" 404 490 "-" "Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:45.0) Gecko/20100101 Firefox/45.0"
```

现在需要你写脚本统计访问 3 次以上的 IP，你的脚本应该输出：
```text
6 192.168.1.22
5 192.168.1.21
4 192.168.1.20
```


## 脚本一
```shell
awk '{print $1}' nowcoder.txt | sort | uniq -c | awk '{if($1>3) print $1,$2}' | sort -nr
```


## 脚本二
```shell
awk '{map[$1]++} END{for(k in map){if(map[k]>3){print map[k],k}}}' nowcoder.txt | sort -nr
```


## 脚本三
```shell
#!/bin/bash

declare -A map

while read line; do 
  ip=$(echo "${line}" | awk '{print $1}')
  map["${ip}"]=$(( map["${ip}"] + 1 ))  
done < nowcoder.txt

result=""
for k in ${!map[@]} ; do
  if [ ! ${map[$k]} -gt 3 ]; then
      continue 
  fi
  if [ -z "${result}" ]; then
      result="${map[$k]} ${k}"
  else
      result="${result}\n${map[$k]} ${k}"
  fi
done
echo -e "${result}" | sort -nr
```