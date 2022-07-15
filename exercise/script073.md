# script073
## 题目

> 注：题目来源于 [SHELL15 去掉不需要的单词 ](https://www.nowcoder.com/practice/838a3acde92c4805a22ac73ca04e503b?tpId=195&tags=&title=&difficulty=0&judgeStatus=0&rp=1&sourceUrl=%2Fexam%2Foj%3Fpage%3D1%26tab%3DSHELL%25E7%25AF%2587%26topicId%3D195)。

写一个 bash脚本以实现一个需求，去掉输入中的含有 B 和 b 的单词。示例：

假设输入如下：
```text
big
nowcoder
Betty
basic
test
```

你的脚本获取以上输入应当输出：
```text
nowcoder test
```

> 说明：你可以不用在意输出的格式，空格和换行都行。





## 脚本一

即用 `grep -v` 命令匹配不包含正则表达式 `[Bb]` 的行。

```shell
grep -v "[Bb]" nowcoder.txt
```





## 脚本二

`awk` 命令的 `!~` 表示不包含，即匹配不包含正则表达式 `[Bb]` 的行。

```shell
awk '$0!~/[Bb]/{print $0}' nowcoder.txt
```





## 脚本三

使用 `sed` 命令的 `d` 可以删除指定匹配正则表达式的行。

```shell
sed '/[Bb]/d' nowcoder.txt
```





## 脚本四

`grep` 命令的 `-i` 选项表示忽略大小写，就后面的正则表达式只需要用一个小写的 `"b"` 就可以了。

```shell
grep -iv "b" nowcoder.txt
```