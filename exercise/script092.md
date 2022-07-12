# script092
## 题目

写一个脚本统计文件nowcoder.txt中的每一行是否是正确的IP地址。
- 如果是正确的IP地址输出：yes
- 如果是错误的IP地址，四段号码的话输出：no，否则的话输出：error

假设 nowcoder.txt 内容如下： 
```text
192.168.1.1
192.168.1.0
300.0.0.0
123
```

你的脚本应该输出：
```text
yes
yes
no
error
```


## 脚本一
```shell
while read line; do
  echo "${line}" | awk -F "." '{
  if(NF!=4){
    print "error"
  }else{
    for(i=1;i<=NF;i++){
      if($i>=0&&$i<=255){
        count++
      }
    }
    if(count==4){
      print "yes"
    } else{
      print "no"
    }
  }
}'
done < nowcoder.txt  
```


## 脚本二
```shell

```