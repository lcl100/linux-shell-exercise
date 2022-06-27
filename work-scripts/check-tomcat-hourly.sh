#!/bin/bash

##
# 每小时检测一次当前服务器的 tomcat 运行状态，如果停止，则启动它
##

# tomcat的安装路径，务必保证本地服务器和远程服务器上的 tomcat 路径一致
TOMCAT_PATH=/opt/tomcat8/apache-tomcat-8.5.65
# 日志文件的路径
LOG_PATH=/root/.ssh/log/script.log

function create_empty_file() {
    if [ $# -ne 1 ]; then
        exit 1
    fi
    local path="$1"
    if [ ! -f "${path}" ]; then
        local parent_dir
        parent_dir=$(dirname "${path}")
        if [ -d "${parent_dir}" ]; then
            touch "${path}"
        else
            mkdir -p "${parent_dir}"
            touch "${path}"
        fi
    fi
}

function LOG_INFO() {
    local date
    date=$(date "+%Y-%m-%d %H:%M:%S")
    local username
    username=$(whoami)
    local script_name
    script_name="$(basename $0)"
    create_empty_file "$LOG_PATH"
    echo "${date} ${username} [INFO] ${script_name}: $*"
}

function LOG_ERROR() {
    local date
    date=$(date "+%Y-%m-%d %H:%M:%S")
    local username
    username=$(whoami)
    local script_name
    script_name="$(basename $0)"
    create_empty_file "$LOG_PATH"
    echo -e "${date} ${username} \e[1;31m[ERROR]\e[0m ${script_name}: $*"
}

# 函数：获取 tomcat 的进程号。如果传入远程服务器的IP地址则获取远程服务器的tomcat进程号；如果没有则获取本服务器的tomcat进程号。
# 参数：
#   - host：远程服务器的 IP 地址。可选参数。
# 使用：`get_tomcat_process_id` 或 `get_tomcat_process_id 1.123.34.68`
# 注意：如果服务器中启动了多个 tomcat 进程，那么该函数并不适合
function get_tomcat_process_id() {
  local host="$1"
  local id
  # 获取tomcat路径中的名字，用于匹配找到tomcat进程
  local tomcat_name
  tomcat_name=$(basename "${TOMCAT_PATH}")
  # 如果没有传入IP地址参数则表示获取本服务器的tomcat进程号；如果传入了IP地址参数则表示获取远程服务器的tomcat进程号
  if [ -n "$host" ]; then
    # 使用 pgrep java 命令会查找出所有的 java 进程，包括 tomcat 进程
    id=$(ssh root@"$host" ps -ef | grep tomcat | grep -w "${tomcat_name}" | grep -v 'grep' | awk '{print $2}')
  else
    id=$(ps -ef | grep tomcat | grep -w "${tomcat_name}" | grep -v 'grep' | awk '{print $2}')
  fi
  echo "$id"
}

# 函数：启动 tomcat。如果传入远程服务器的 IP 地址则启动远程服务器上的 tomcat；如果没有则启动当前服务器上的 tomcat。
# 参数：
#   - path：指的是tomcat的安装目录，不包括 /bin/startup.sh。必选参数。
#   - host：远程服务器的IP地址。可选参数。
# 使用：`start_tomcat /home/apache-tomcat-8.5.13` 或 `start_tomcat /home/apache-tomcat-8.5.13 1.123.34.68`
# 注意：如果 tomcat 处于启动状态则不会进行任何操作
function start_tomcat(){
  # 参数校验
  if [ $# -lt 1 ]; then
      LOG_ERROR "Please input at least one parameter."
      exit 1
  fi
  # 获取待启动的tomcat的路径
  local path="$1"
  # 校验输入路径是否为空
  if [ -z "$path" ]; then
      LOG_ERROR "Please input the path of tomcat."
      exit 1
  fi
  # 校验路径是否真实存在
  if [ ! -d "${path}" ]; then
      LOG_ERROR "Please input a valid tomcat path."
      exit 1
  fi
  # 获取远程主机 IP 地址，可能不存在
  local host="$2"
  local tomcat_process_id
  # 如果 host 为空则启动本地 tomcat
  if [ -z "$host" ]; then
      tomcat_process_id="$(get_tomcat_process_id)"
      # 先判断tomcat是否处于启动状态
      if [ -n "${tomcat_process_id}" ]; then
          LOG_INFO "The local tomcat is starting."
      else
          # 如果没有启动则启动当前tomcat
          path="${path}/bin/startup.sh"
          "${path}" > /dev/null
          if [ -n "$(get_tomcat_process_id)" ]; then
               LOG_INFO "Start local tomcat successfully."
          else
               LOG_ERROR "Failed to start local tomcat."
          fi
      fi
  # 如果不为空则启动远程 tomcat
  else
      tomcat_process_id="$(get_tomcat_process_id "$host")"
      # 先判断tomcat是否处于启动状态
      if [ -n "${tomcat_process_id}" ]; then
          LOG_INFO "The remote(${host}) tomcat is starting."
      else
          # 如果没有启动则启动远程tomcat
          path="${path}/bin/startup.sh"
          ssh root@"${host}" "${path}"  > /dev/null
          if [ -n "$(get_tomcat_process_id "${host}")" ]; then
               LOG_INFO "Start remote(${host}) tomcat successfully."
          else
               LOG_ERROR "Failed to start remote(${host}) tomcat."
          fi
      fi
  fi
}

function main() {
    local result
    result=$(get_tomcat_process_id)
    if [ -n "${result}" ]; then
        LOG_INFO "The tomcat is running."
    else
        LOG_ERROR "The tomcat has stopped."
        start_tomcat "${TOMCAT_PATH}"
        if [ $? -eq 0 ]; then
            LOG_INFO "Restart the tomcat successfully."
        else
            LOG_ERROR "Failed to restart the tomcat."
        fi
    fi
}

main 2>&1 | tee -a "$LOG_PATH"