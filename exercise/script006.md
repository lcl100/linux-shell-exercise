# script006 
## 题目

编写一个脚本，打印任何数的乘法表。如输入 3 则打印：

```text
1*1=1
2*1=2   2*2=4
3*1=3   3*2=6   3*3=9
```





## 分析 

本题考查的知识点：

- 自定义函数
- 函数传参
- `if` 条件语句
- 双层 `for` 循环语句
- `echo` 命令

思路：

- 打印九九乘法表不难，难的是如何用 Shell 编程。





## 脚本

```shell
#!/bin/bash

##
# 打印乘法表
# @param $1 第一个参数，表示传入的数字，从 [1, 9] 中任取一个整数表示输出几行的乘法表
##
function print_multiplication_table() {
  # 参数校验，如果参数个数为 0 则给出提示
  if [ $# -eq 0 ]; then
      echo "请输入一个参数！"
      exit
  fi

  # 接收一个参数表示几行乘法表
  local num=$1
  # 双层 for 循环打印乘法表
  for (( i = 1; i <= $num; i++ )); do
      for (( j = 1; j <= $i; j++ )); do
          # 计算 i*j 的结果
          local result=$[$i*$j]
          # -e 表示让制表符生效；-n 表示不换行
          echo -ne "$i*$j=$result\t"
      done
      # 换行
      echo
  done
}

##
# 主函数
##
function main() {
  # 在主函数中调用
  print_multiplication_table "$1"
}

# 调用主函数
main "$1"
```





## 测试

执行 `./script006.sh num` 脚本，其中 `num` 可以从 `[1, 9]` 中取任何一个整数。

![image-20220529195752697](image-script006/image-20220529195752697.png)

