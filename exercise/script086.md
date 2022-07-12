# script086
## 题目

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
```shell
grep "tcp" nowcoder.txt | awk '{print $6}' | sort | uniq -c | sort -nr | awk '{print $2,$1}'
```


## 脚本二
```shell
awk '/tcp/{map[$6]++} END{for(k in map) print k,map[k]}' nowcoder.txt | sort -nr -k 2
```