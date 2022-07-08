# script060
## 题目

经常查看日志的时候，会从文件的末尾往前查看，于是请你写一个 bash 脚本以输出一个文本文件 `nowcoder.txt` 中的最后 `5` 行

示例，假设 `nowcoder.txt` 内容如下：

```c
#include<iostream>
using namespace std;
int main()
{
int a = 10;
int b = 100;
cout << "a + b:" << a + b << endl;
return 0;
}
```

你的脚本应当输出：

```c
int a = 10;
int b = 100;
cout << "a + b:" << a + b << endl;
return 0;
}
```


## 脚本一

```shell
tail -n 5 nowcoder.txt
```

## 脚本二
```shell
awk 'BEGIN{x=1} {arr[x]=$0;x++} END{for(i=NR-4;i<=NR;i++) print arr[i]}' nowcoder.txt
```

## 脚本三
```shell
sed -n '5,$p' nowcoder.txt
```

## 脚本四
```shell
awk 'NR>=5{print $0}' nowcoder.txt
```

## 脚本五
```shell
tac nowcoder.txt | head -n 5 | tac
```