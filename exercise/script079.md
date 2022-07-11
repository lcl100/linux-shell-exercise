# script0
## 题目


假设我们有一个 `nowcoder.txt`，假设里面的内容如下：

```text
111:13443
222:13211
111:13643
333:12341
222:12123
```

现在需要你写一个脚本按照以下的格式输出：

```text
[111]
13443
13643
[222]
13211
12123
[333]
12341
```


## 脚本一
```shell
#!/bin/bash

result=$(cat nowcoder.txt | awk -F ":" '{print $1}' | sort | uniq)
for item in ${result} ; do
    echo "[${item}]"
    grep "${item}" nowcoder.txt | awk -F ":" '{print $2}'
done
```


## 脚本二
```shell
awk -F ":" '{
    res[$1] = (res[$1] == "" ? $2 : (res[$1] "\n" $2))
}END{
    for(k in res){
        print "["k"]"
        print res[k]
    }
}' nowcoder.txt
```