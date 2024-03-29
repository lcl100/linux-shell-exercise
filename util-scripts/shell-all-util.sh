#!/bin/bash

## 日志文件的路径
LOG_PATH="/root/.ssh/log/script.log"


# 函数：根据指定路径创建空文件。如果路径不存在则先创建路径所表示的目录再创建文件；如果已经存在则不进行任何操作。
# 参数：
#   - path: 空文件路径。必选。
# 使用：`create_empty_file /root/.ssh/log/script.log`
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

# 函数：在当前服务器下创建空目录，如果目录存在则不进行任何操作，否则创建空目录
# 参数：
#   - path: 目录路径。必选。
# 使用：`mkdir /root/.ssh/backup`
function mkdir_local() {
    if [ $# -ne 1 ]; then
        LOG_ERROR "Please input a parameter."
        return 1
    fi
    local path="$1"
    # 如果路径已经存在并且是一个目录则不做任何操作
    if [ -d "${path}" ]; then
        LOG_INFO "The directory(${path}) already exists."
        return 0
    fi
    # 如果路径不存在，则创建为目录
    mkdir -p "${path}"
}

# 函数：在远程服务器下创建空目录，如果目录存在则不进行任何操作，否则创建空目录
# 参数：
#   - host: 远程服务器IP地址。必选。
#   - path: 目录路径。必选。
# 使用：`mkdir 192.168.3.3 /root/.ssh/backup`
function mkdir_remote() {
    if [ $# -ne 2 ]; then
        LOG_ERROR "Please input two parameters."
        return 1
    fi
    local host="$1"
    local path="$2"
    # 测试IP地址是否可用
    local ip_result
    ip_result=$(ping_ip "${host}")
    if [ "${ip_result}" -eq 1 ]; then
        LOG_ERROR "The host(${host}) is unavailable."
        return 1
    fi
    # 如果在远程服务器中该路径已经存在并且是一个目录则不做任何操作
    ssh root@"${host}" ls "${path}" > /dev/null
    if [ $? -eq 0 ]; then
        LOG_INFO "The directory(${path}) already exists on remote(${host}) server."
        return 0
    else
        # 如果路径不存在，则创建为目录
        ssh root@"${host}" mkdir -p "${path}"
        if [ $? -eq 0 ]; then
            LOG_INFO "Created successfully: ${host}"
            return 0
        else
            LOG_ERROR "Failed to create: ${host}"
            return 1
        fi
    fi
}

# 函数：测试指定IP是否有效
# 参数：
#   - ip: 指定主机的IP地址。必选。
# 返回值：
#   - status_code: 状态码，如果返回 0 表示可用；返回 1 表示不可用。
# 使用：`ping_ip 192.168.3.3`
function ping_ip() {
    if [ $# -ne 1 ]; then
        LOG_ERROR "Please input a parameter."
        return 1
    fi
    local ip="$1"
    ping -W 4 -c 2 "${ip}" > /dev/null
    if [ $? -eq 0 ]; then
        return 0
    else
        return 1
    fi
}

# 函数：输出INFO级别的日志。不会输出到文件，如果想要同时输出到屏幕和文件中建议在主函数上使用 tee 命令。
# 参数：
#   - $*: 任何内容。可选。
# 使用：`LOG_INFO "hello world"`
function LOG_INFO() {
    # 时间日期
    local date
    date=$(date "+%Y-%m-%d %H:%M:%S")
    # 当前用户
    local username
    username=$(whoami)
    # 脚本名
    local script_name
    script_name="$(basename $0)"
    # 如果日志文件的路径不存在，则创建
    create_empty_file "$LOG_PATH"
    # 输出日志到指定文件中
    echo "${date} ${username} [INFO] ${script_name}: $*"
}

# 函数：输出ERROR级别的日志。不会输出到文件，如果想要同时输出到屏幕和文件中建议在主函数上使用 tee 命令。
# 参数：
#   - $*: 任何内容。可选。
# 使用：`LOG_ERROR "hello world"`
function LOG_ERROR() {
    # 时间日期
    local date
    date=$(date "+%Y-%m-%d %H:%M:%S")
    # 当前用户
    local username
    username=$(whoami)
    # 脚本名
    local script_name
    script_name="$(basename $0)"
    # 如果日志文件的路径不存在，则创建
    create_empty_file "$LOG_PATH"
    # 输出日志到指定文件中
    echo -e "${date} ${username} \e[1;31m[ERROR]\e[0m ${script_name}: $*"
}

# 函数：输出日期和时间
# 返回值：
#   - date_time: 当前日期和时间
# 使用：`dt=$(date_time)`
function date_time() {
    local dt
    dt=$(date "+%Y-%m-%d %H:%M:%S")
    echo "${dt}"
}

# 函数：判断当前登录用户是否是root用户
# 返回值：
#   - code: 如果是超级用户则返回 0，否则返回 1 表示不是
# 使用：`result=$(is_root_user)`
function is_root_user() {
    if [ $UID -eq 0 ]; then
        return 0
    else
        return 1
    fi
}

# 函数：获取 tomcat 的进程号。如果传入远程服务器的IP地址则获取远程服务器的tomcat进程号；如果没有则获取本服务器的tomcat进程号。
# 参数：
#   - host：远程服务器的 IP 地址。可选参数。
# 返回值：
#   - process_id: 启动的tomcat进程id
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
        close_tomcat > /dev/null
        start_tomcat "$path" > /dev/null
      else
        # 如果tomcat处于关闭状态则启动
        start_tomcat "$path" > /dev/null
      fi
      # 判断是否重启成功
      if [ -n "$(get_tomcat_process_id)" ]; then
        LOG_INFO "Restart local tomcat successfully."
      else
        LOG_ERROR "Failed to restart local tomcat."
      fi
  # 如果不为空则重启远程的 tomcat
  else
      # 先判断远程tomcat是否处于启动状态
      if [ -n "$(get_tomcat_process_id "${host}")" ]; then
        # 如果tomcat处于启动状态则先关闭再启动
        close_tomcat "${host}" > /dev/null
        start_tomcat "${path}" "${host}" > /dev/null
      else
        # 如果tomcat处于关闭状态则启动
        start_tomcat "${path}" "${host}" > /dev/null
      fi
      # 判断是否重启成功
      if [ -n "$(get_tomcat_process_id "${host}")" ]; then
        LOG_INFO "Restart remote(${host}) tomcat successfully."
      else
        LOG_ERROR "Failed to restart remote(${host}) tomcat."
      fi
  fi
}

# 函数：获取当前系统中硬盘空间最大使用率
# 返回值：
#   - max_usage: 当前系统中硬盘空间最大使用率
# 使用：`max_usage=$(get_local_disk_max_usage)`
function get_local_disk_max_usage() {
    # 获取当前系统中硬盘空间最大使用率
    local max_usage
    max_usage=$(df -P | awk '{print $5}' | grep -E '[0-9]{1,3}' | tr -d "%" | sort -nr | head -n 1)
    echo "$max_usage";
}

# 函数：获取远程服务器系统中硬盘空间最大使用率
# 参数：
#   - remote_host: 远程服务器的IP地址，保证是可用的。即在调用该函数之前先校验IP地址是否有效。
# 返回值：
#   - max_usage: 远程服务器中硬盘空间最大使用率
# 使用：`max_usage=$(get_remote_disk_max_usage)`
function get_remote_disk_max_usage() {
    # 获取远程系统中硬盘空间最大使用率
    local remote_host
    remote_host="$1"
    local max_usage
    max_usage=$(ssh root@"${remote_host}" df -P | awk '{print $5}' | grep -E '[0-9]{1,3}' | tr -d % | sort -nr | head -n 1)
    echo "$max_usage"
}

# 函数：获取当前主机的外网IP
# 返回值：
#   - external_ip: 当前主机的外网IP
# 使用：`external_ip=$(get_local_external_ip)`
function get_local_external_ip() {
    local external_ip
    external_ip=$(curl -s ip.sb)
    echo "${external_ip}"
}

# 函数：获取远程主机的外网IP
# 参数：
#   - remote_ip: 远程主机的内网IP
# 返回值：
#   - external_ip: 远程主机的外网IP
# 使用：`external_ip=$(get_remote_external_ip)`
function get_remote_external_ip() {
    if [ $# -ne 1 ]; then
        LOG_ERROR "Please input a parameter."
        exit 1
    fi
    local remote_host
    remote_host="$1"
    local external_ip
    external_ip=$(ssh root@"${remote_host}" curl -s ip.sb)
    echo "${external_ip}"
}