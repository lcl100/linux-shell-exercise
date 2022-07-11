# script071
## 题目

写一个 bash 脚本以实现一个需求，去掉输入中含有 `this` 的语句，把不含 `this` 的语句输出。

示例，假设输入如下：
```text
that is your bag
is this your bag?
to the degree or extent indicated.
there was a court case resulting from this incident
welcome to nowcoder
```

你的脚本获取以上输入应当输出：
```text
that is your bag
to the degree or extent indicated.
welcome to nowcoder
```

> 说明：你可以不用在意输出的格式，包括空格和换行





## 脚本一

`grep "this"` 命令会检索只包含 `"this"` 的行，而 `-v` 选项会显示相反的结果，即不包含 `"this"` 的行。

```shell
grep -v "this" nowcoder.txt
```





## 脚本二

使用 `sed` 命令的 `d` 选项删除包含 `"this"` 的行，显示的就只有包含 `"this"` 的行了。

```shell
sed '/this/d' nowcoder.txt
```





## 脚本三

`awk '/this/'` 表示匹配包含 `"this"` 的行，而 `!` 表示非，即不包含 `"this"` 的行。

```shell
awk '!/this/' nowcoder.txt
```





## 脚本四

使用 `awk` 命令的 `index()` 函数查找每行 `"this"` 字符串出现没，如果没有出现则打印该行。

```shell
awk '{if(index($0,"this")==0) print $0}' nowcoder.txt
```





## 脚本五

`awk` 命令的 `!~` 表示不包含。`$0!~/this/` 表示当前行（`$0`）不包含（`!~`）指定正则表达式（ `/this/`） 的匹配。

```shell
awk '$0!~/this/ {print $0}' nowcoder.txt
```