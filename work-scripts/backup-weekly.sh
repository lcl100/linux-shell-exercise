#!/bin/bash


###################################################################
# Script Name : backup-weekly.sh
# Description : Allows you to backup file or directory every week.
# Note: By `crontab -e` command to set the weekly schedule to execute the script.
# Args : "$1" - The source file or directory; "$2" - The target directory.
# Usage : ./backup-weekly.sh /home/apache-tomcat-8.5.13/webapps/student-management-system /root/backup
# Author : lcl100
# Website : https://github.com/lcl100
# Create Time : 2022-06-23
# Last Alter Time : 2022-06-23
###################################################################


# 最大保存文件数目，每周备份一次的话，即只保留三个月内的压缩包
MAX_FILE_COUNT=12
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

# 参数校验
if [ $# -ne 2 ]; then
    LOG_ERROR "Please input tow parameters."
    exit 1
fi

src_path="$1"
dest_path="$2"
if [ ! -e "${src_path}" ]; then
    LOG_ERROR "Path ${src_path} must exist."
    exit 1
fi
if [ ! -d "${dest_path}" ]; then
    # 如果目标目录不存在则进行创建
    mkdir -p "${dest_path}"
fi

# 在备份之前如果目标目录下的备份文件个数已经满 MAX_FILE_COUNT 个了，则清除最久时间的那个文件
count=$(ls "${dest_path}" | wc -l)
if [ "${count}" -ge ${MAX_FILE_COUNT} ]; then
    # 获取最老的文件
    oldest_file=$(ls -t "${dest_path}" | tail -n 1)
    # 删除它
    if rm -rf "${dest_path:?}/${oldest_file:?}"; then
      # 打印提示
      LOG_INFO "The oldest file(${oldest_file}) has been deleted"
    else
      LOG_ERROR "Failed to delete the oldest file(${oldest_file})."
    fi
fi

# 备份文件
# 获取文件名
name=$(basename "${src_path}")
date=$(date "+%Y%m%d%H%M")
tar -czvPf "${dest_path}/${name}-${date}.tar.gz" "${src_path}" > /dev/null

if [ "$?" -eq 0 ]; then
    LOG_INFO "Backup file ${name}-${date}.tar.gz succeeded."
else
    LOG_ERROR "Backup file ${name}-${date}.tar.gz failed."
fi