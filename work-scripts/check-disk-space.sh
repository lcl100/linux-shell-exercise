#!/bin/bash


###################################################################
# Script Name : check-disk-space.sh
# Description : Allows you to check local disk space and remote disk space, and clean up log file space in time.
# Note: Allows you to modify some configuration items, such as `MAX_WARNING_LIMIT`, `MAX_CLEAR_LIMIT`, `CLEAR_DIRS`, `CLEAR_STRATEGY`, `HOSTS_PATH`, `LOG_PATH`.
# Args : No any parameters.
# Usage : ./check-disk-space.sh
# Author : lcl100
# Website : https://github.com/lcl100
# Create Time : 2022-06-22
# Last Alter Time : 2022-06-22
###################################################################


# 设定最大警告限制，如果超过 MAX_WARNING_LIMIT 则判定它达到阈值，需要提示清理
MAX_WARNING_LIMIT=70
# 设定最大清理限制，如果超过 MAX_CLEAR_LIMIT 则判断它达到阈值，则自动进行清理
MAX_CLEAR_LIMIT=85
# 指定目录，通常是日志文件所在目录，如 tomcat 下的 log 目录，可以设置多个路径，之间通过分号分隔
CLEAR_DIRS="/home/logs/;/home/apache-tomcat-8.5.13/logs/"
# 如果设置为 true 表示清除指定目录下的所有文件，如果设置为 false 表示仅清除最大文件
CLEAR_STRATEGY=false
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
    echo "${date} ${username} [INFO] ${script_name}: $*" | tee -a "$LOG_PATH"
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
    echo -e "${date} ${username} \e[1;41m [ERROR] \e[0m ${script_name}: $*" | tee -a "$LOG_PATH"
}

function get_local_disk_max_usage() {
    # 获取当前系统中硬盘空间最大使用率
    local max_usage
    max_usage=$(df -P | awk '{print $5}' | egrep '[0-9]{1,3}' | tr -d "%" | sort -nr | head -n 1)
    echo "$max_usage";
}

function get_remote_disk_max_usage() {
    # 获取远程系统中硬盘空间最大使用率
    local remote_host
    remote_host="$1"
    local max_usage
    max_usage=$(ssh root@"${remote_host}" df -P | awk '{print $5}' | egrep '[0-9]{1,3}' | tr -d % | sort -nr | head -n 1)
    echo "$max_usage"
}

function check_local_disk(){
    # 调用函数获取当前磁盘空间最大使用率
    local max_usage
    max_usage=$(get_local_disk_max_usage)

    LOG_INFO "The current disk space maximum usage is ${max_usage}%"

    if [ -z "${max_usage}" ]; then
        LOG_ERROR "Failed to get the current maximum usage of disk space."
        exit 1
    fi

    # 判断如果超过 MAX_WARNING_LIMIT 则给出警告
    if [ "${max_usage}" -ge "${MAX_WARNING_LIMIT}" -a "${max_usage}" -lt "${MAX_CLEAR_LIMIT}" ]; then
        # 发出广播通知各个用户当前磁盘空间已经超过 MAX_WARNING_LIMIT，提示用户主动清理
        wall "The current maximum disk space usage has exceeded ${MAX_WARNING_LIMIT}, please clean up the disk space in time, if it exceeds ${MAX_CLEAR_LIMIT}, it will be cleaned up automatically."
    fi

    # 判断如果超过 MAX_CLEAR_LIMIT 则根据清除策略删除文件
    while [ "$(get_local_disk_max_usage)" -ge "${MAX_CLEAR_LIMIT}" ]; do
        # 如果清除策略为 true 则表示清除指定目录下的所有文件
        if [ "${CLEAR_STRATEGY}" = "true" ]; then
            # 用换行符分隔每个目录路径
            paths=$(echo "${CLEAR_DIRS}" | tr -s ";" "\n")
            # 循环每个目录路径
            for path in $paths ; do
                # 如果该目录存在才进行下一步操作
                if [ -d "${path}" ]; then
                    # 删除该目录下的所有文件
                    if rm -rf "${path}/*"; then
                        LOG_INFO "All files deleted: ${path}"
                    else
                        LOG_ERROR "Failed to delete all files: ${path}"
                    fi
                else
                    LOG_ERROR "The directory does not exist: ${path}"
                fi
            done
        # 如果清除策略为 false 则表示清除指定目录下的最大文件
        elif [ "${CLEAR_STRATEGY}" = "false" ]; then
            # 用换行符分隔每个目录路径
            paths=$(echo "${CLEAR_DIRS}" | tr -s ";" "\n")
            # 循环每个目录路径
            for path in $paths ; do
                # 如果该目录存在才进行下一步操作
                if [ -d "${path}" ]; then
                     # 找到当前目录下的最大文件，包括子目录
                    max_file=$(find "${path}" -type f -printf "%s\t%p\n" | sort -n | tail -n 1 | cut -f 2)
                    # 删除最大文件
                    if rm -rf "${max_file}"; then
                        LOG_INFO "The largest file has been successfully deleted: ${max_file}"
                    else
                        LOG_ERROR "Failed to delete largest file: ${max_file}"
                    fi
                else
                    LOG_ERROR "The directory does not exist: ${path}"
                fi
            done
        # 如果是其他字符串则提示错误信息
        else
            LOG_ERROR "The CLEAR_STRATEGY can only be true or false."
            exit 1
        fi
    done
}

function check_remote_disk() {
    # 参数校验
    if [ $# -ne 1 ]; then
        LOG_ERROR "A parameter must be given."
        exist 1;
    fi

    # 获取传入的 IP 地址
    local remote_host
    remote_host="$1"
    # 测试 IP 是否可以连通
    if ! ping -c 1 "${remote_host}" &> /dev/null; then
        LOG_ERROR "Connection to this host failed: ${remote_host}"
        exist 1;
    fi

    # 调用函数获取远程磁盘空间最大使用率
    local max_usage
    max_usage=$(get_remote_disk_max_usage "${remote_host}")

    LOG_INFO "The remote(${remote_host}) disk space maximum usage is ${max_usage}%"

    if [ -z "${max_usage}" ]; then
        LOG_ERROR "Failed to get the remote(${remote_host}) maximum usage of disk space."
        exit 1
    fi

    # 判断如果超过 MAX_WARNING_LIMIT 则给出警告
    if [ "${max_usage}" -ge "${MAX_WARNING_LIMIT}" -a "${max_usage}" -lt "${MAX_CLEAR_LIMIT}" ]; then
        # 发出广播通知各个用户当前磁盘空间已经超过 MAX_WARNING_LIMIT，提示用户主动清理
        wall "The remote(${remote_host}) maximum disk space usage has exceeded ${MAX_WARNING_LIMIT}, please clean up the disk space in time, if it exceeds ${MAX_CLEAR_LIMIT}, it will be cleaned up automatically."
    fi

    # 判断如果超过 MAX_CLEAR_LIMIT 则根据清除策略删除文件
    while [ "$(get_remote_disk_max_usage "${remote_host}")" -ge "${MAX_CLEAR_LIMIT}" ]; do
        # 如果清除策略为 true 则表示清除指定目录下的所有文件
        if [ "${CLEAR_STRATEGY}" = "true" ]; then
            # 用换行符分隔每个目录路径
            paths=$(echo "${CLEAR_DIRS}" | tr -s ";" "\n")
            # 循环每个目录路径
            for path in $paths ; do
                # 如果该目录存在才进行下一步操作
                if [ -d "${path}" ]; then
                    # 删除该目录下的所有文件
                    if ssh root@"${remote_host}" rm -rf "${path}/*"; then
                        LOG_INFO "All files deleted: ${path}"
                    else
                        LOG_ERROR "Failed to delete all files: ${path}"
                    fi
                else
                    LOG_ERROR "The directory does not exist: ${path}"
                fi
            done
        # 如果清除策略为 false 则表示清除指定目录下的最大文件
        elif [ "${CLEAR_STRATEGY}" = "false" ]; then
            # 用换行符分隔每个目录路径
            paths=$(echo "${CLEAR_DIRS}" | tr -s ";" "\n")
            # 循环每个目录路径
            for path in $paths ; do
                # 如果该目录存在才进行下一步操作
                if [ -d "${path}" ]; then
                     # 找到当前目录下的最大文件，包括子目录
                    max_file=$(ssh root@"${remote_host}" find "${path}" -type f -printf "%s\\\t%p\\\n" | sort -n | tail -n 1 | cut -f 2)
                    # 删除最大文件
                    if ssh root@"${remote_host}" rm -rf "${max_file}"; then
                        LOG_INFO "The largest file has been successfully deleted: ${max_file}"
                    else
                        LOG_ERROR "Failed to delete largest file: ${max_file}"
                    fi
                else
                    LOG_ERROR "The directory does not exist: ${path}"
                fi
            done
        # 如果是其他字符串则提示错误信息
        else
            LOG_ERROR "The CLEAR_STRATEGY can only be true or false."
            exit 1
        fi
    done
}

function main() {
    # 检查本地的磁盘
    LOG_INFO "=========================local:"
    check_local_disk
    echo
    # 检查远程主机的磁盘
    if [ -f "${HOSTS_PATH}" ]; then
        local hosts
        hosts=$(cat "$HOSTS_PATH")
        for host in $hosts; do
            echo
            LOG_INFO "=========================remote: ${host}"
            check_remote_disk "${host}"
            echo
        echo
  done
    fi
}

main