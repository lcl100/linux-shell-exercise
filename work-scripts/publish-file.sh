#!/bin/bash

# 发布publish-files目录下的文件到指定服务器的同名文件处（即替换其他服务器上的同名文件）
# 第一步，获取存储在hosts文件中的远程服务器IP地址，循环远程服务器IP地址
# 第二步，获取publish-files目录下的所有待发布的文件名，循环
# 第三步，根据文件名去远程服务器中通过find命令查看文件是否存在于该远程服务器中（find命令查找效率太低已经更换为locate命令）
# 第四步，如果该文件存在于远程服务器中则进行删除，但保存该文件通过find命令查出来的路径
# 第五步，再通过scp命令将该文件复制到远程服务器指定路径中

# 如下配置项都是可以自定义进行修改的
# 设置存放待部署文件的文件夹名
PUBLISH_DIR="/root/.ssh/publish-files"
# 保存了远程服务器IP地址的文件路径
HOSTS_PATH="/root/.ssh/hostlist"
# 目标目录，通常是 tomcat 服务器中某个项目的根目录
DEST_DIR="/home/apache-tomcat-8.5.13/webapps/bill-system-1.0-SNAPSHOT"
# 日志文件的路径
LOG_PATH="/root/.ssh/log/script-test.log"
# 对部署文件进行备份的路径
BACKUP_PATH="/root/.ssh/backup/publish-file-backup"


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
#   - path: 目录路径
# 使用：`mkdir /root/.ssh/backup`
function mkdir_local() {
    if [ $# -ne 1 ]; then
        LOG_ERROR "Please input a parameter."
        exit 1
    fi
    local path="$1"
    # 如果路径已经存在并且是一个目录则不做任何操作
    if [ ! -d "${path}" ]; then
        # 如果路径不存在，则创建为目录
        mkdir -p "${path}"
    fi
}

# 函数：在远程服务器下创建空目录，如果目录存在则不进行任何操作，否则创建空目录
# 参数：
#   - host: 远程服务器IP地址
#   - path: 目录路径
# 使用：`mkdir 192.168.3.3 /root/.ssh/backup`
function mkdir_remote() {
    if [ $# -ne 2 ]; then
        LOG_ERROR "Please input two parameters."
        exit 1
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
#   - ip: 指定主机的IP地址
# 返回值：
#   - status_code: 状态码，如果返回 0 表示可用；返回 1 表示不可用。
# 使用：`ping_ip 192.168.3.3`
function ping_ip() {
    if [ $# -ne 1 ]; then
        LOG_ERROR "Please input a parameter."
        exit 1
    fi
    local ip="$1"
    ping -W 4 -c 2 "${ip}" > /dev/null
    if [ $? -eq 0 ]; then
        return 0
    else
        return 1
    fi
}

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

function get_local_path() {
    # 参数校验
    if [ $# -ne 2 ]; then
        LOG_ERROR "Please input tow parameters."
        exit 1
    fi
    if [ ! -d "$1" ]; then
        LOG_ERROR "\$1 is not a valid directory path: $1"
        exit 1
    fi
    if [ -z "$2" ]; then
        LOG_ERROR "\$2 can not be empty."
        exit 1
    fi
    local dest_dir="$1"
    local dest_name="$2"
    # 在指定目录 dest_dir 下查找指定文件名为 dest_name 的文件
    local search_result
    search_result=$(find "${dest_dir}" -type f -name "${dest_name}")
    # 在指定目录 dest_dir 下查找指定文件名为 dest_name 的文件数目，因为可能会出现同名文件
    local search_result_count
    search_result_count=$(find "${dest_dir}" -type f -name "${dest_name}" | wc -l)
    if [ "${search_result_count}" -gt 1 ]; then
        LOG_ERROR "Multiple query results: ${search_result}"
        exit 2
    elif [ "${search_result_count}" -eq 0 ]; then
        LOG_ERROR "Empty query result."
        exit 3
    else
        # 返回查找到的路径
        echo "${search_result}"
    fi
}

function publish_local_file() {
  # 参数校验
  if [ $# -ne 1 ]; then
      LOG_ERROR "Please input one parameter."
      exit 1
  fi
  local dir="$1"
  if [ ! -d "${dir}" ]; then
      LOG_ERROR "\$1 isn't a valid directory path: $1"
      exit 1
  fi
  # 获取指定目录下的所有文件
  local names
  names=$(ls "${dir}")
  # 循环所有文件
  for name in $names ; do
      # 指的是当前遍历文件的完整路径
      local src_path="${dir}/${name}"
      # 判断是否是目录，如果是目录则递归遍历，如果是文件则打印该文件的完整路径
      if [ -d "${src_path}" ]; then
          publish_local_file "${src_path}"
      else
          # 获取当前文件在指定目录下的绝对路径
          local dest_path
          dest_path=$(get_local_path "${DEST_DIR}" "${name}")
          # 如果状态码等于 0 才表示查找该路径，否则不是
          local status_code="$?"
          if [ ${status_code} -eq 0 ]; then
              # 在发布之前进行备份原文件
              local backup_file_name
              backup_file_name=$(date "+%Y%m%d-%H%M")
              local backup_path
              backup_path="${BACKUP_PATH}/${backup_file_name}"
              mkdir_local "${backup_path}"
              cp "${dest_path}" "${backup_path}"
              # 备份之后再发布文件
              rm -rf "${dest_path}"
              cp "${src_path}" "${dest_path}"
              if [ $? -eq 0 ]; then
                  LOG_INFO "本地服务器发布成功: ${name}"
              else
                  LOG_ERROR "本地服务器发布失败: ${name}"
              fi
          elif [ ${status_code} -eq 2 ]; then
              LOG_ERROR "有多个名字(${name})相同的文件位于(${DEST_DIR})目录下，请手动处理。"
          elif [ ${status_code} -eq 3 ]; then
              LOG_ERROR "文件(${name})不存在于特定目录(${DEST_DIR})，请在发布之前先部署一份到本地服务器中。"
          else
              LOG_ERROR "本地服务器发布失败: ${name}"
          fi
      fi
  done
}

function publish_remote_file() {
  # 参数校验
  if [ $# -ne 2 ]; then
      LOG_ERROR "Please input two parameters."
      exit 1
  fi
  local dir="$1"
  local remote_host="$2"
  if [ ! -d "${dir}" ]; then
      LOG_ERROR "\$1 is not a valid directory path: $1"
      exit 1
  fi
  # 获取指定目录下的所有文件
  local names
  names=$(ls "${dir}")
  # 循环所有文件
  for name in $names ; do
      # 指的是当前遍历文件的完整路径
      local src_path="${dir}/${name}"
      # 判断是否是目录，如果是目录则递归遍历，如果是文件则打印该文件的完整路径
      if [ -d "${src_path}" ]; then
          publish_remote_file "${src_path}" "${remote_host}"
      else
          # 获取当前文件在远程服务器指定目录下的绝对路径
          local remote_search_result
          remote_search_result=$(ssh root@"${host}" find "${DEST_DIR}" -type f -name "${name}")
          # 在远程服务器指定目录 DEST_DIR 下查找指定文件名为 dest_name 的文件数目，因为可能会出现同名文件
          local remote_search_result_count
          remote_search_result_count=$(ssh root@"${host}" find "${DEST_DIR}" -type f -name "${name}" | wc -l)
          # 如果查找结果为一个或者零个才是我们该找到的结果
          # 如果是零个，则查找该文件在本地服务器的完整路径，然后才能在远程服务器部署
          if [ ${remote_search_result_count} -eq 0 ]; then
              # 获取当前文件在本地服务器指定目录下的绝对路径
              local local_path
              local_path=$(get_local_path "${DEST_DIR}" "${name}")
              local status_code=$?
              if [ ${status_code} -eq 0 ]; then
                  # 检查待部署的文件所在目录在远程服务器上是否实际存在，如果不存在则进行创建
                  local path_dir
                  path_dir=$(ssh root@"${host}" dirname "${local_path}")
                  # 注，这里必须判断远程服务器上的路径是否是目录，如果是判断本地则会部署失败
                  if ssh root@"${host}" [ -d "${path_dir}" ]; then
                      scp "${local_path}" root@"${host}":"${path_dir}"
                  else
                      ssh root@"${host}" mkdir -p "${path_dir}"
                      scp "${local_path}" root@"${host}":"${path_dir}"
                  fi
                  if [ $? -eq 0 ]; then
                      LOG_INFO "远程服务器(${host})发布成功: ${name}"
                  else
                      LOG_ERROR "远程服务器(${host})发布失败: ${name}"
                  fi
              elif [ ${status_code} -eq 2 ]; then
                  LOG_ERROR "有多个名字(${name})相同的文件位于(${DEST_DIR})目录下，请手动处理。"
              elif [ ${status_code} -eq 3 ]; then
                  LOG_ERROR "文件(${name})不存在于特定目录(${DEST_DIR})，请在发布之前先部署一份到本地服务器中。"
              else
                  LOG_ERROR "远程服务器(${host})发布成功: ${name}"
              fi
          # 如果正好有 1 条，则删除远程服务器上的该文件，再进行部署
          elif [ ${remote_search_result_count} -eq 1 ]; then
              ssh root@"${host}" rm -rf "${remote_search_result}"
              # 检查待部署的文件所在目录在远程服务器上是否实际存在，如果不存在则进行创建
              local path_dir
              path_dir=$(ssh root@"${host}" dirname "${remote_search_result}")
              if ssh root@"${host}" [ -d "${path_dir}" ]; then
                  scp "${remote_search_result}" root@"${host}":"${path_dir}"
              else
                  ssh root@"${host}" mkdir -p "${path_dir}"
                  scp "${remote_search_result}" root@"${host}":"${path_dir}"
              fi
              if [ $? -eq 0 ]; then
                  LOG_INFO "远程服务器(${host})发布成功: ${name}"
              else
                   LOG_ERROR "远程服务器(${host})发布失败: ${name}"
              fi
          else
              LOG_ERROR "文件(${name})在远程服务器(${host})上发布失败，因为有多个同名文件(${name})位于目录(${dest_dir})中，请手动处理。"
          fi
      fi
  done
}

# 脚本入口函数
main() {
  # 调用函数，部署 ${PUBLISH_DIR} 中的文件到本地服务器指定目录下中
  publish_local_file "${PUBLISH_DIR}"

  # 部署到远程服务器上，循环 ${HOSTS_PATH} 中的所有远程服务器IP地址，一一调用函数进行部署
  if [ -f "${HOSTS_PATH}" ]; then
      local hosts
      hosts=$(cat "${HOSTS_PATH}")
      for host in ${hosts}; do
        # 调用函数，传入存有发布文件的目录和远程服务器IP地址
        publish_remote_file "${PUBLISH_DIR}" "${host}"
      done
  fi
}

# 启动入口函数
main 2>&1 | tee -a "$LOG_PATH"