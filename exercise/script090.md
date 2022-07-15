# script090
## 题目

> 注：本题来源于 [SHELL33 业务分析-提取值 ](https://www.nowcoder.com/practice/f144e52a3e054426a4d265ff38399748?tpId=195&tags=&title=&difficulty=0&judgeStatus=0&rp=1&sourceUrl=%2Fexam%2Foj%3Fpage%3D1%26tab%3DSHELL%25E7%25AF%2587%26topicId%3D195)。

假设我们的日志 `nowcoder.txt` 里，内容如下

```text
12-May-2017 10:02:22.789 信息 [main] org.apache.catalina.startup.VersionLoggerListener.log Server version:Apache Tomcat/8.5.15
12-May-2017 10:02:22.813 信息 [main] org.apache.catalina.startup.VersionLoggerListener.log Server built:May 5 2017 11:03:04 UTC
12-May-2017 10:02:22.813 信息 [main] org.apache.catalina.startup.VersionLoggerListener.log Server number:8.5.15.0
12-May-2017 10:02:22.814 信息 [main] org.apache.catalina.startup.VersionLoggerListener.log OS Name:Windows, OS Version:10
12-May-2017 10:02:22.814 信息 [main] org.apache.catalina.startup.VersionLoggerListener.log Architecture:x86_64
```

现在需要你提取出对应的值，输出内容如下：
```text
serverVersion:Apache Tomcat/8.5.15
serverName:8.5.15.0
osName:Windows
osVersion:10
```





## 脚本一

使用 `grep` 匹配符合指定正则表达式的行，然后使用 `sed` 命令删除多余的字符串，则剩下的就是我们需要的结果。

```shell
#!/bin/bash

server_version=$(grep "Server version:" nowcoder.txt | sed 's/.*Server version://')
server_name=$(grep "Server number:" nowcoder.txt | sed 's/.*Server number://')
os_name=$(grep "OS Name:" nowcoder.txt | sed 's/.*OS Name://' | sed 's/,.*//')
os_version=$(grep "OS Version:" nowcoder.txt | sed 's/.*OS Version://')

echo "serverVersion:${server_version}"
echo "serverName:${server_name}"
echo "osName:${os_name}"
echo "osVersion:${os_version}"
```





## 脚本二

使用 `awk` 命令编程实现。

```shell
# 通过 冒号字符和逗号字符 进行分割
awk -F "[:,]" '{
	# 如果该行包含字符串 Server version，则提取第四个字段输出
    if($0~"Server version"){
        print "serverVersion:" $4;
    }
    # 同理
    if($0~"Server number"){
        print "serverName:" $4;
    }
    if($0~"OS Name"){
        print "osName:" $4;
    }
    if($0~"OS Version"){
        print "osVersion:" $6
    }
}' nowcoder.txt
```