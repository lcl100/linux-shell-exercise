# script089
## 题目

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

现在需要你输出和本机3306端口建立连接的各个状态的数目，按照以下格式输出：
- TOTAL_IP表示建立连接的ip数目
- TOTAL_LINK表示建立连接的总数目

```text
TOTAL_IP 3
ESTABLISHED 20
TOTAL_LINK 20
```





## 脚本一

通过 `grep` 命令使用正则表达式匹配正确行，再使用 `awk` 命令提取指定列，最后使用 `wc` 命令统计行数。

```shell
#!/bin/bash

total_ip_count=$(grep ":3306" nowcoder.txt | awk '{print $5}' | sed 's/:3306//' | sort | uniq | wc -l)
established_count=$(grep -E ":3306.*ESTABLISHED" nowcoder.txt | awk '{print $5}' | wc -l)
total_link_count=$(grep -E ":3306.*ESTABLISHED" nowcoder.txt | wc -l)

echo "TOTAL_IP ${total_ip_count}"
echo "ESTABLISHED ${established_count}"
echo "TOTAL_LINK ${total_link_count}"
```





## 脚本二

使用 `awk` 命令编程实现。

```shell
awk '{
	# 如果第一个字段是 tcp，并且 第五个字段包含字符串 3306
    if ($1 == "tcp" && $5 ~ /3306/) {
    	# 则判断第六个字段是否是 ESTABLISHED 状态
        if ($6 == "ESTABLISHED") {
        	# 该变量记录 ESTABLISHED 的出现次数
            es++
        }
        # 记录总连接数
        ans++
        # 用关联数组记录不重复 IP，数组的长度就是 IP 的个数，这里元素值为零没有实际含义
        arr[$5]=0
    }
} END {
    printf("TOTAL_IP %d\nESTABLISHED %d\nTOTAL_LINK %d", length(arr), es, ans)
}'
```