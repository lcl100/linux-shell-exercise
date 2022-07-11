# script0
## 题目

我们有一个文件 `nowcoder.txt`，里面的每一行都是一个数字串，假设数字串为 `"123456789"`，那么我们要输出为 `123,456,789`。

假设 `nowcoder.txt` 内容如下：
```text
1
12
123
1234
123456
```

那么你的脚本输出如下：
```text
1
12
123
1,234
123,456
```


## 脚本一
核心是把用例中的每一行当成一串数字，给数字的千位加英文样式的分隔符，也就是逗号 用 `%'d` 或 `%'.f`，只要是数字类型的就行
```shell
for i in `cat nowcoder.txt`
do
  printf "%'d\n" $i
done
```


## 脚本二
```shell
sed -E ':a; s/([[:digit:]])([[:digit:]]{3})\>/\1,\2/; ta' nowcoder.txt
```


## 脚本三
```shell
awk -F "" '{
    k=0
    for (i=NF; i>0; i--) {
        k++
        str = sprintf("%s%s", $i, str)
        if (k%3 == 0 && i>=2 && NF > 3) {
            str = sprintf(",%s", str)
        }
    }
    print(str)
    str=""
}' nowcoder.txt
```