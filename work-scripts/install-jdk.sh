#!/bin/bash


###################################################################
# Script Name : install-jdk.sh
# Description : Allows you to quickly install and configure the JDK.
# Note: No any notes.
# Args : "$1" - JDK installation directory.
# Usage : ./install-jdk.sh  /opt/jdk8/jdk1.8.0_291
# Author : lcl100
# Website : https://github.com/lcl100
# Create Time : 2022-06-22
# Last Alter Time : 2022-06-22
###################################################################


# 参数校验
if [ $# -ne 1 ]; then
  echo "请输入一个参数！"
  exit 1
fi

# 获取传入的 JDK 安装目录
JDK_INSTALL_PATH="$1"
# 环境变量的配置文件，写入才会永久有效
ENV_CONFIG_FILE="/etc/profile"

# 校验传入的路径是否是一个目录
if [ ! -d "${JDK_INSTALL_PATH}" ]; then
  echo "${JDK_INSTALL_PATH} 不是一个目录！"
  exit 1
fi

# 校验传入的路径是否是 JDK 的安装目录
jdk_version=$("${JDK_INSTALL_PATH}/bin/java" -version)
status_code="$?"
if [ ${status_code} -ne 0 ]; then
  echo "${JDK_INSTALL_PATH} 不是 JDK 的安装目录！"
  exit 1
fi

# 如果传入的路径中最后一个字符是斜杠，则删除掉最后一个斜杆字符
last_char=${JDK_INSTALL_PATH: -1}
if [ "$last_char" = "/" ]; then
  JDK_INSTALL_PATH=${JDK_INSTALL_PATH%?}
fi

# 校验环境变量文件 /etc/profile 中是否已经配置了 JDK 的环境变量信息
grep "${JDK_INSTALL_PATH}" "${ENV_CONFIG_FILE}"
status_code="$?"
# 如果已经存在则删除相关行
if [ ${status_code} -eq 0 ]; then
  file_name=$(basename "${JDK_INSTALL_PATH}")
  sed -ri "/${file_name}/d" "${ENV_CONFIG_FILE}"
fi

# 校验如果环境变量 PATH 中已经存在该路径了则删除，否则后面会重复加入
PATH=$(echo "$PATH" | sed "s#${JDK_INSTALL_PATH}/bin:##g")

# 原环境变量值
ORIGIN_PATH="$PATH"

# 临时生效
export JAVA_HOME="${JDK_INSTALL_PATH}"
export JRE_HOME="${JAVA_HOME}/jre"
export CLASSPATH=".:${JAVA_HOME}/lib:${JRE_HOME}/lib"
export PATH="${JAVA_HOME}/bin:${ORIGIN_PATH}"

# 将 JDK 的安装路径写入环境变量中，永久生效
echo "export JAVA_HOME=${JDK_INSTALL_PATH}" >>"${ENV_CONFIG_FILE}"
echo "export JRE_HOME=${JAVA_HOME}/jre" >>"${ENV_CONFIG_FILE}"
echo "export CLASSPATH=.:${JAVA_HOME}/lib:${JRE_HOME}/lib" >>"${ENV_CONFIG_FILE}"
echo "export PATH=${JAVA_HOME}/bin:${ORIGIN_PATH}" >>"${ENV_CONFIG_FILE}"
# 使文件生效
source "${ENV_CONFIG_FILE}"

# 进行测试，查看是否配置环境变量成功
java -version
status_code="$?"
if [ ${status_code} -eq 0 ]; then
  echo "安装 JDK 成功！"
  exit 0
else
  echo "安装 JDK 失败！"
  exit 1
fi