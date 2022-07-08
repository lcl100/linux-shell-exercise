# script059
## 题目

写一个 `bash` 脚本以输出一个文本文件 `nowcoder.txt` 中的行数。

示例，假设 `nowcoder.txt` 内容如下：
```c
#include <iostream>
using namespace std;
int main()
{
    int a = 10;
    int b = 100;
    cout << "a + b:" << a + b << endl;
    return 0;
}
```
那么你的脚本应当输出：
```text
9
```


## 脚本一
```shell
cat nowcoder.txt | wc -l
```

## 脚本二
```shell
wc -l nowcoder.txt | awk '{print $1}'
```

## 脚本三
```shell
#!/bin/bash

count=0

while read line; do
  count=$((${count}+1))
done < nowcoders.txt

echo "${count}"
```

## 脚本四
```shell
 cat nowcoders.txt | grep ".*" -c
```

## 脚本五
```shell
awk 'BEGIN{count=0} {count=count+1} END{print count}' nowcoders.txt 
```

## 脚本六
```shell
awk '{print NR}' nowcoders.txt | tail -n 1
```

## 脚本七
```shell
cat -n nowcoders.txt | tail -n 1 | awk '{print $1}'
```

## 脚本八
```shell
sed -n '$=' nowcoders.txt 
```

## 脚本九
```shell
nl nowcoders.txt | tail -n 1 | awk '{print $1}'
```

## 脚本十
```shell
awk 'END{print NR}' nowcoders.txt
```

新增 `nl` 命令学习