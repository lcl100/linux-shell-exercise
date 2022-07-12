# script090
## 题目

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
```shell
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
```shell
awk -F "[:,]" '{
    if($0~"Server version"){
        print "serverVersion:" $4;
    }
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