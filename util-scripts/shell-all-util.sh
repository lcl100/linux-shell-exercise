#!/bin/bash

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

function date() {
    local d
    d=$(date "+%Y-%m-%d")
    echo "${d}"
}

function time() {
    local t
    t=$(date "+%H:%M:%S")
    echo "${t}"
}

function date_time() {
    local dt
    dt=$(date "+%Y-%m-%d %H:%M:%S")
    echo "${dt}"
}

function is_root_user() {
    if [ $UID -eq 0 ]; then
        return 1
    else
        return 0
    fi
}