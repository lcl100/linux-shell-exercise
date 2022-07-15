# script078
## 题目

> 注：题目来源于 [SHELL21 格式化输出](https://www.nowcoder.com/practice/d91a06bfaff443928065e611b14a0e95?tpId=195&tags=&title=&difficulty=0&judgeStatus=0&rp=1&sourceUrl=%2Fexam%2Foj%3Fpage%3D1%26tab%3DSHELL%25E7%25AF%2587%26topicId%3D195)。

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
    # 倒序输出每位字符
    for (i=NF; i>0; i--) {
        k++
        # 拼接之前的字符串
        str = sprintf("%s%s", $i, str)
        # 每三位添加一个千位分隔符
        if (k%3 == 0 && i>=2 && NF > 3) {
            str = sprintf(",%s", str)
        }
    }
    print(str)
    str=""
}' nowcoder.txt
```