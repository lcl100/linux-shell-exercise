# script086
## 题目

> 注：题目来源于 [SHELL29 netstat练习1-查看各个状态的连接数 ](https://www.nowcoder.com/practice/f46a302d14e04b149bb50670f255293a?tpId=195&tags=&title=&difficulty=0&judgeStatus=0&rp=1&sourceUrl=%2Fexam%2Foj%3Fpage%3D1%26tab%3DSHELL%25E7%25AF%2587%26topicId%3D195)。

假设 netstat 命令运行的结果我们存储在 `nowcoder.txt` 里，格式如下：
```shell
Proto Recv-Q Send-Q Local Address           Foreign Address         State
tcp        0      0 0.0.0.0:6160            0.0.0.0:*               LISTEN
tcp        0      0 127.0.0.53:53           0.0.0.0:*               LISTEN
tcp        0      0 0.0.0.0:22              0.0.0.0:*               LISTEN
tcp        0      0 172.16.56.200:41856     172.16.34.144:3306      ESTABLISHED
tcp        0      0 172.16.56.200:49822     172.16.0.24:3306        ESTABLISHED
tcp        0      0 172.16.56.200:49674     172.16.0.24:3306        ESTABLISHED
tcp        0      0 172.16.56.200:42316     172.16.34.144:3306      ESTABLISHED
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

现在需要你查看系统tcp连接中各个状态的连接数，并且按照连接数降序输出。你的脚本应该输出如下：

```text
ESTABLISHED 22
TIME_WAIT 9
LISTEN 3
```





## 脚本一

通过 `grep` 命令检索 tcp 连接行；然后使用 `awk` 命令提取第六列，表示各个连接的状态；再使用 `sort` 命令排序，让重复的行相邻；使用 `uniq -c` 命令去除并统计各个状态连接的出现次数；再通过 `sort` 命令降序排列；最后通过 `awk` 调整显示列顺序，让状态名在第一列显示，第二列显示连接数。

```shell
grep "tcp" nowcoder.txt | awk '{print $6}' | sort | uniq -c | sort -nr | awk '{print $2,$1}'
```





## 脚本二

通过关联数组来实现，将各个状态和该状态的连接数放进关联数组中；接着在 `END{}` 中循环遍历关联数组，打印状态名和状态表示的连接数；最后通过 `sort` 命令对第二列进行倒序排列。

```shell
awk '/tcp/{map[$6]++} END{for(k in map) print k,map[k]}' nowcoder.txt | sort -nr -k 2
```