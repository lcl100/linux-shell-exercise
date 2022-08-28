#!/bin/bash

# 重启当前消费者服务器的tomcat
# 注意，远程启动其他服务器上的tomcat可能会有环境变量的问题

# tomcat的安装路径，务必保证本地服务器和远程服务器上的 tomcat 路径一致
TOMCAT_PATH=/home/apache-tomcat-8.5.13
# 存有远程服务器IP地址列表的文件
HOSTS_PATH=/root/.ssh/hostlist
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

# 函数：关闭 tomcat。如果传入远程服务器的 IP 地址则关闭远程服务器上的 tomcat；如果没有则关闭当前服务器上的 tomcat。
# 参数：
#   - host：远程服务器的IP地址。可选参数。
# 使用：`close_tomcat` 或 `close_tomcat 1.123.34.68`
function close_tomcat(){
    local host="$1"
    local tomcat_process_id
    # 如果为空则关闭本地服务器的 tomcat
    if [ -z "${host}" ]; then
        # 获取tomcat进程id
        tomcat_process_id=$(get_tomcat_process_id)
        # 判断tomcat运行的进程id是否存在，如果存在则关闭
        if [ -n "${tomcat_process_id}" ]; then
          # 关闭tomcat，杀死进程
          kill -9 "${tomcat_process_id}"
          # 关闭之后检查是否关闭成功
          if [ -z "$(get_tomcat_process_id)" ]; then
            LOG_INFO "Close local tomcat successfully"
          else
            LOG_ERROR "Failed to close local tomcat."
          fi
        else
          LOG_INFO "The Local tomcat is currently shutting down."
        fi
    # 如果非空则关闭远程服务器的 tomcat
    else
        # 查询tomcat运行的进程id判断tomcat进程是否存在
        # 获取tomcat进程id
        tomcat_process_id=$(get_tomcat_process_id "${host}")
        if [ -n "${tomcat_process_id}" ]; then
          # 关闭tomcat
          ssh root@"$host" "kill -9 ${tomcat_process_id}"
          # 关闭之后检查是否关闭成功
          if [ -z "$(get_tomcat_process_id "${host}")" ]; then
            LOG_INFO "Close remote(${host}) tomcat successfully"
          else
            LOG_ERROR "Failed to close remote(${host}) tomcat."
          fi
        else
          LOG_INFO "The remote(${host}) tomcat is currently shutting down."
        fi
    fi
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

# 函数：重启远程的tomcat
# 参数：
#   - path：指的是tomcat的安装目录，不包括/bin/startup.sh。必选参数。
#   - host：指的是远程服务器的IP地址。可选参数。
# 使用：`restart_tomcat /home/apache-tomcat-8.5.13` 或 `restart_tomcat /home/apache-tomcat-8.5.13 1.123.34.68`
# 注意：如果 tomcat 处于启动状态则会先关闭原 tomcat 再启动
function restart_tomcat(){
  # 参数校验
  if [ $# -lt 1 ]; then
      LOG_ERROR "Please input at least one parameter."
      exit 1
  fi
  # 获取待启动的tomcat的路径和远程服务器的IP地址
  local path="$1"
  local host="$2"
  # 如果 IP 地址为空则重启本地的 tomcat
  if [ -z "${host}" ]; then
      # 先判断本地 tomcat 是否处于启动状态
      if [ -n "$(get_tomcat_process_id)" ]; then
        # 如果tomcat处于启动状态则先关闭再启动
        close_tomcat
        start_tomcat "$path"
      else
        # 如果tomcat处于关闭状态则启动
        start_tomcat "$path"
      fi
      # 判断是否重启成功
      if [ -n "$(get_tomcat_process_id)" ]; then
        LOG_INFO "Restart the local tomcat successfully."
      else
        LOG_ERROR "Failed to restart local tomcat."
      fi
  # 如果不为空则重启远程的 tomcat
  else
      # 先判断远程tomcat是否处于启动状态
      if [ -n "$(get_tomcat_process_id "${host}")" ]; then
        # 如果tomcat处于启动状态则先关闭再启动
        close_tomcat "${host}"
        start_tomcat "${path}" "${host}"
      else
        # 如果tomcat处于关闭状态则启动
        start_tomcat "${path}" "${host}"
      fi
      # 判断是否重启成功
      if [ -n "$(get_tomcat_process_id "${host}")" ]; then
        LOG_INFO "Restart the remote(${host}) tomcat successfully."
      else
        LOG_ERROR "Failed to restart remote(${host}) tomcat."
      fi
  fi
}

# 函数：脚本主启动函数
main() {
  # 重启本地服务器上的tomcat
  restart_tomcat "$TOMCAT_PATH"
  echo

  # 重启远程服务器上的tomcat
  if [ -f "${HOSTS_PATH}" ]; then
      local hosts
      hosts=$(cat "$HOSTS_PATH")
      for host in $hosts; do
        restart_tomcat "$TOMCAT_PATH" "$host"
        echo
      done
  fi
}
main 2>&1 | tee -a "$LOG_PATH"