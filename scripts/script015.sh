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
