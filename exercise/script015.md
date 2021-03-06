# script015 
## 题目

实现禁止和允许普通用户登录系统。





## 分析

本题考查的知识点：

- `/etc/nologin` 文件的作用
- `read` 命令
- `if...else` 和 `if...elif...else` 多分支条件语句
- `tr` 命令
- `echo` 命令
- `rm` 命令
- 字符串判断

思路：

- 如果系统中存在 `/etc/nologin` 文件则表示普通用户无法登录系统，而该文件的内容将会在普通用户被禁止登录时作为提示信息；如果系统中不存在该文件，表示普通用户可以登录。根据这一特性，可以用来实现禁止和允许普通用户登录。
- 如果 `/etc/nologin` 文件存在那么表示此时普通用户已经无法登录了，所以应该做的选项是是否恢复普通用户登录；如果 `/etc/nologin` 文件不存在那么表示此时普通用户可以登录系统，所以应该做的选项是是否禁止普通用户登录。
- 注意，用户可能输入大写字母，所以将其转换成小写字母方便比较。





## 脚本

```shell
#!/bin/bash

####################################
#
# 功能：实现禁止和允许普通用户登录
#
# 使用：直接执行，无须任何参数。
#
####################################

##
# 实现禁止和允许普通用户登录
##
function allow_or_forbid_login() {
  # 根据 /etc/nologin 文件是否存在，来判断是允许普通用户登录还是禁止普通用户登录
  if [ -f "/etc/nologin" ]; then
      read -n 1 -p "你是否想要允许普通用户登录[Y/N]：" is_allow
      echo
  else
      read -n 1 -p "你是否想要禁止普通用户登录[Y/N]：" is_forbid
      echo
  fi

  # 将输入的字母都转换成小写字母
  is_allow=$(echo "$is_allow" | tr 'A-Z' 'a-z')
  is_forbid=$(echo "$is_forbid" | tr 'A-Z' 'a-z')

  # 实现禁止普通用户登录
  if [ "$is_forbid" = "y" ]; then
      # 如果要禁止普通用户登录，只需要创建 /etc/nologin 文件即可
      echo "系统正在维护中，请过段时间再登录！" > /etc/nologin
      echo "现在普通用户将不能登录系统了！"
  elif [ "$is_forbid" = "n" ]; then
      echo "现在普通用户仍然可以登录！"
  fi

  # 实现允许普通用户登录
  if [ "$is_allow" = "y" ]; then
      # 只要删除掉 /etc/nologin 文件就可以让普通用户进行登录了
      rm -rf "/etc/nologin"
      echo "现在普通用户已经可以登录了！"
  elif [ "$is_allow" = "n" ]; then
      echo "现在普通用户仍然不允许登录！"
  fi
}

##
# 主函数
##
function main() {
  # 在主函数中调用
  allow_or_forbid_login
}

# 调用主函数
main

```





## 测试

第一次执行 `./script015.sh` 脚本，将会禁止普通用户登录，此时系统中有 `/etc/nologin` 文件存在。

![image-20220530215849299](image-script015/image-20220530215849299.png)

![image-20220530220027785](image-script015/image-20220530220027785.png)

恢复普通用户登录。

![image-20220530221101741](image-script015/image-20220530221101741.png)