# script061
## 题目

写一个 bash 脚本以输出数字 0 到 500 中 7 的倍数(0 7 14 21...)的命令。


## 脚本一
```shell
seq 0 7 500
```

## 脚本二
```shell
#!/bin/bash

for num in {0..500} ; do
    if [ $((${num} % 7)) -eq 0 ]; then
        echo "${num}"
    fi
done
```

## 脚本三
```shell
seq 0 500 | awk '{if($0%7==0) print $0}'
```

## 脚本四
```shell
echo {0..500..7} | tr -s ' ' '\n'
```

## 脚本五
```shell
seq 0 500 | sed -n '1~7p'
```