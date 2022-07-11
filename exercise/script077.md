# script077
## 题目

假设我们有一个 `nowcoder.txt`，现在需要你写脚本，打印只有一个数字的行。假设 `nowcoder.txt` 内容如下
```text
haha
1
2ab
cd
77
```

那么你的脚本应该输出：
```text
1
2ab
```


## 脚本一
```shell
while read line; do
  num=$(echo -n ${line} | sed 's/\w/&\n/g' | grep -E -c "[0-9]")
  if [ ${num} -eq 1 ]; then
      echo ${line}
  fi
done < nowcoder.txt
```


## 脚本二
```shell
awk -F "[0-9]" '{if(NF==2) print $0}' nowcoder.txt
```


## 脚本三
```shell
#!/bin/bash

while read line; do
    out=$(echo ${line} | sed 's/[^0-9]//g')

    if [ ${#out} -eq 1 ]; then
        echo $line 
    fi
done < nowcoder.txt
```

## 脚本四
```shell
grep -E '^[a-Z]*[0-9][a-Z]*$' nowcoder.txt
```

## 脚本五
```shell
awk '/^[[:alpha:]]*[[:digit:]][[:alpha:]]*$/{print}' nowcoder.txt
```