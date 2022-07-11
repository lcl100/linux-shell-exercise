# script074
## 题目

将字段逆序输出文件 `nowcoder.txt` 的每一行，其中每一字段都是用英文冒号 `:` 相分隔。假设 `nowcoder.txt` 内容如下：
```text
nobody:*:-2:-2:Unprivileged User:/var/empty:/usr/bin/false
root:*:0:0:System Administrator:/var/root:/bin/sh
```

你的脚本应当输出：
```text
/usr/bin/false:/var/empty:Unprivileged User:-2:-2:*:nobody
/bin/sh:/var/root:System Administrator:0:0:*:root
```


## 脚本一
```shell
#!/bin/bash

while read line; do 
  newline=$(echo "${line}" | tr -s ":" "\n" | tac | tr -s "\n" ":")
  echo "${newline::-1}"
done < nowcoder.txt
```


## 脚本二
```shell
awk -F ":" '{
  for(i=1;i<=NF;i++){
    arr[i]=$i
  }
  msg=""
  for(j=NF;j>=1;j--){
    if(msg==""){
      msg=arr[j]
    }else{
      msg=msg":"arr[j]
    }
  }
  print msg
}' nowcoder.txt
```

## 脚本三
```shell
awk -F ':' '{
	for (i = NF; i >= 2; i--) {
		printf("%s:", $i)
	}
	print($1)
}' nowcoder.txt
```