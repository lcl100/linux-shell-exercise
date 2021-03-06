# script087
## 题目

> 注：题目来源于 [SHELL30 netstat练习2-查看和3306端口建立的连接](https://www.nowcoder.com/practice/534b95941ffb495b9ba57fbfc3cd723a?tpId=195&tags=&title=&difficulty=0&judgeStatus=0&rp=1&sourceUrl=%2Fexam%2Foj%3Fpage%3D1%26tab%3DSHELL%25E7%25AF%2587%26topicId%3D195)。

假设 netstat 命令运行的结果我们存储在 `nowcoder.txt` 里，格式如下：
```text
Proto Recv-Q Send-Q Local Address           Foreign Address         State
tcp        0      0 0.0.0.0:6160            0.0.0.0:*               LISTEN
tcp        0      0 127.0.0.53:53           0.0.0.0:*               LISTEN
tcp        0      0 0.0.0.0:22              0.0.0.0:*               LISTEN
tcp        0      0 172.16.56.200:41856     172.16.34.144:3306      ESTABLISHED
tcp        0      0 172.16.56.200:49822     172.16.0.24:3306        ESTABLISHED
tcp        0      0 172.16.56.200:49674     172.16.0.24:3306        ESTABLISHED
tcp        0      0 172.16.56.200:42316     172.16.34.143:3306      ESTABLISHED
tcp        0      0 172.16.56.200:44076     172.16.240.74:6379      ESTABLISHED
tcp        0      0 172.16.56.200:49656     172.16.0.24:3306        ESTABLISHED
tcp        0      0 172.16.56.200:58248     100.100.142.4:80        TIME_WAIT
tcp        0      0 172.16.56.200:50108     172.16.0.24:3306        ESTABLISHED
tcp        0      0 172.16.56.200:41944     172.16.34.144:3306      ESTABLISHED
tcp        0      0 172.16.56.200:35548     100.100.32.118:80       TIME_WAIT
tcp        0      0 172.16.56.200:39024     100.100.45.106:443      TIME_WAIT
tcp        0      0 172.16.56.200:41788     172.16.34.144:3306      ESTABLISHED
tcp        0      0 172.16.56.200:58260     100.100.142.4:80        TIME_WAIT
tcp        0      0 172.16.56.200:41812     172.16.34.144:3306      ESTABLISHED
tcp        0      0 172.16.56.200:41854     172.16.34.144:3306      ESTABLISHED
tcp        0      0 172.16.56.200:58252     100.100.142.4:80        TIME_WAIT
tcp        0      0 172.16.56.200:49586     172.16.0.24:3306        ESTABLISHED
tcp        0      0 172.16.56.200:41754     172.16.34.144:3306      ESTABLISHED
tcp        0      0 172.16.56.200:50466     120.55.222.235:80       TIME_WAIT
tcp        0      0 172.16.56.200:38514     100.100.142.5:80        TIME_WAIT
tcp        0      0 172.16.56.200:49832     172.16.0.24:3306        ESTABLISHED
tcp        0      0 172.16.56.200:52162     100.100.30.25:80        ESTABLISHED
tcp        0      0 172.16.56.200:50372     172.16.0.24:3306        ESTABLISHED
tcp        0      0 172.16.56.200:50306     172.16.0.24:3306        ESTABLISHED
tcp        0      0 172.16.56.200:49600     172.16.0.24:3306        ESTABLISHED
tcp        0      0 172.16.56.200:41908     172.16.34.144:3306      ESTABLISHED
tcp        0      0 172.16.56.200:60292     100.100.142.1:80        TIME_WAIT
tcp        0      0 172.16.56.200:37650     100.100.54.133:80       TIME_WAIT
tcp        0      0 172.16.56.200:41938     172.16.34.144:3306      ESTABLISHED
tcp        0      0 172.16.56.200:49736     172.16.0.24:3306        ESTABLISHED
tcp        0      0 172.16.56.200:41890     172.16.34.144:3306      ESTABLISHED
udp        0      0 127.0.0.1:323           0.0.0.0:*
udp        0      0 0.0.0.0:45881           0.0.0.0:*
udp        0      0 127.0.0.53:53           0.0.0.0:*
udp        0      0 172.16.56.200:68        0.0.0.0:*
udp6       0      0 ::1:323                 :::*
raw6       0      0 :::58                   :::*                    7
```

现在需要你查看和本机 3306 端口建立连接并且状态是 established 的所有 IP，按照连接数降序排序。你的脚本应该输出：
```text
10 172.16.0.24
9 172.16.34.144
1 172.16.34.143
```





## 脚本一

使用 `grep` 命令查找 3306 端口建立的连接并且连接状态是 `ESTABLISHED` 的记录行；然后使用 `awk` 命令提取第五列；再通过 `cut` 命令提取 IP 地址（即去除端口号）；通过 `sort` 命令排序；`uniq -c` 去重并统计出现次数；再通过 `sort` 命令按降序排列；最后通过 `sed` 命令去除行首空格。

```shell
grep ":3306.*ESTABLISHED" nowcoder.txt | awk '{print $5}' | cut -d ":" -f 1 | sort | uniq -c | sort -nr | sed 's/[ \t]*//'
```





## 脚本二

通过 `awk` 命令编程和关联数组来完成；其中 `/:3306.*ESTABLISHED/` 用来查找 3306 端口建立的连接并且连接状态是 `ESTABLISHED` 的记录行；在 `{}` 中将 IP 地址和出现次数存入到关联数组中；然后在 `END{}` 中循环打印关联数组，输出出现次数和 IP 地址；最后通过 `sed` 命令去除统计行中的 3306 端口号；`sort` 命令按降序排列。

```shell
awk '/:3306.*ESTABLISHED/{map[$5]++} END{for(k in map) print map[k],k}' nowcoder.txt | sed 's/:3306//' | sort -nr
```