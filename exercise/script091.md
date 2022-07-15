# script091
## 题目

> 注：题目来源于 [SHELL34 ps分析-统计VSZ,RSS各自总和](https://www.nowcoder.com/practice/7094b5f96e1a4c998ce01baf407beee6?tpId=195&tags=&title=&difficulty=0&judgeStatus=0&rp=1&sourceUrl=%2Fexam%2Foj%3Fpage%3D1%26tab%3DSHELL%25E7%25AF%2587%26topicId%3D195)。

假设命令运行的结果我们存储在 `nowcoder.txt` 里，格式如下：
```text
USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root         1  0.0  0.1  37344  4604 ?        Ss    2020   2:13 /sbin/init
root       231  0.0  1.5 166576 62740 ?        Ss    2020  15:15 /lib/systemd/systemd-journald
root       237  0.0  0.0      0     0 ?        S<    2020   2:06 [kworker/0:1H]
root       259  0.0  0.0  45004  3416 ?        Ss    2020   0:25 /lib/systemd/systemd-udevd
root       476  0.0  0.0      0     0 ?        S<    2020   0:00 [edac-poller]
root       588  0.0  0.0 276244  2072 ?        Ssl   2020   9:49 /usr/lib/accountsservice/accounts-daemon
message+   592  0.0  0.0  42904  3032 ?        Ss    2020   0:01 /usr/bin/dbus-daemon --system --address=systemd: --nofork --nopidfile --systemd-activation
root       636  0.0  0.0  65532  3200 ?        Ss    2020   1:51 /usr/sbin/sshd -D
daemon     637  0.0  0.0  26044  2076 ?        Ss    2020   0:00 /usr/sbin/atd -f
root       639  0.0  0.0  29476  2696 ?        Ss    2020   3:29 /usr/sbin/cron -f
root       643  0.0  0.0  20748  1992 ?        Ss    2020   0:26 /lib/systemd/systemd-logind
syslog     645  0.0  0.0 260636  3024 ?        Ssl   2020   3:17 /usr/sbin/rsyslogd -n
root       686  0.0  0.0 773124  2836 ?        Ssl   2020  26:45 /usr/sbin/nscd
root       690  0.0  0.0  19472   252 ?        Ss    2020  14:39 /usr/sbin/irqbalance --pid=/var/run/irqbalance.pid
ntp        692  0.0  0.0  98204   776 ?        Ss    2020  25:18 /usr/sbin/ntpd -p /var/run/ntpd.pid -g -u 108:114
uuidd      767  0.0  0.0  28624   192 ?        Ss    2020   0:00 /usr/sbin/uuidd --socket-activation
root       793  0.0  0.0 128812  3148 ?        Ss    2020   0:00 nginx: master process /usr/sbin/nginx -g daemon on; master_process on;
www-data   794  0.0  0.2 133376  9120 ?        S     2020 630:57 nginx: worker process
www-data   795  0.0  0.2 133208  8968 ?        S     2020 633:02 nginx: worker process
www-data   796  0.0  0.2 133216  9120 ?        S     2020 634:24 nginx: worker process
www-data   797  0.0  0.2 133228  9148 ?        S     2020 632:56 nginx: worker process
web        955  0.0  0.0  36856  2112 ?        Ss    2020   0:00 /lib/systemd/systemd --user
web        956  0.0  0.0  67456  1684 ?        S     2020   0:00 (sd-pam)
root      1354  0.0  0.0   8172   440 tty1     Ss+   2020   0:00 /sbin/agetty --noclear tty1 linux
root      1355  0.0  0.0   7988   344 ttyS0    Ss+   2020   0:00 /sbin/agetty --keep-baud 115200 38400 9600 ttyS0 vt220
root      2513  0.0  0.0      0     0 ?        S    13:07   0:00 [kworker/u4:1]
root      2587  0.0  0.0      0     0 ?        S    13:13   0:00 [kworker/u4:2]
root      2642  0.0  0.0      0     0 ?        S    13:17   0:00 [kworker/1:0]
root      2679  0.0  0.0      0     0 ?        S    13:19   0:00 [kworker/u4:0]
root      2735  0.0  0.1 102256  7252 ?        Ss   13:24   0:00 sshd: web [priv]
web       2752  0.0  0.0 102256  3452 ?        R    13:24   0:00 sshd: web@pts/0
web       2753  0.5  0.1  14716  4708 pts/0    Ss   13:24   0:00 -bash
web       2767  0.0  0.0  29596  1456 pts/0    R+   13:24   0:00 ps aux
root     10634  0.0  0.0      0     0 ?        S    Nov16   0:00 [kworker/0:0]
root     16585  0.0  0.0      0     0 ?        S<    2020   0:00 [bioset]
root     19526  0.0  0.0      0     0 ?        S    Nov16   0:00 [kworker/1:1]
root     28460  0.0  0.0      0     0 ?        S    Nov15   0:03 [kworker/0:2]
root     30685  0.0  0.0  36644  2760 ?        Ss    2020   0:00 /lib/systemd/systemd --user
root     30692  0.0  0.0  67224  1664 ?        S     2020   0:00 (sd-pam)
root     32689  0.0  0.0  47740  2100 ?        Ss    2020   0:00 /usr/local/ilogtail/ilogtail
root     32691  0.2  0.5 256144 23708 ?        Sl    2020 1151:31 /usr/local/ilogtail/ilogtail
```

现在需要你统计 VSZ，RSS 各自的总和（以M兆为统计），输出格式如下：
```text
MEM TOTAL
VSZ_SUM:3250.8M,RSS_SUM:179.777M
```





## 脚本一

第五列表示 VSZ，第六列表示 RSS；使用 `grep -E` 只提取数字行，即去掉标题行，因为无法参与运算；最后使用 `awk` 命令循环每行进行总和的计算，最后除以 1024 将单位转换成兆。

```shell
#!/bin/bash

vsz_sum=$(awk '{print $5}' nowcoder.txt | grep -E "[0-9]+" | awk '{sum+=$0} END{print sum/1024}')
rss_sum=$(awk '{print $6}' nowcoder.txt | grep -E "[0-9]+" | awk '{sum+=$0} END{print sum/1024}')

echo "MEM TOTAL"
echo "VSZ_SUM:${vsz_sum}M,RSS_SUM:${rss_sum}M"
```





## 脚本二

直接利用 `awk` 命令编程实现。

```shell
awk '/[0-9]+/{vsz_sum+=$5;rss_sum+=$6} END{printf("MEM TOTAL\nVSZ_SUM:%.1fM,RSS_SUM:%.3fM\n",vsz_sum/1024,rss_sum/1024)}' nowcoder.txt
```