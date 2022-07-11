#!/bin/bash

for (( i = 1; i <= 5; i++ )); do
	# 第一部分
    for (( j = 1; j <= 5-i; j++ )); do
        printf " "
    done
    # 第二部分
    for (( j = 1; j <= 2*${i}-1; j++ )); do
        if [ $[ ${j} % 2 ] -eq 0 ]; then
            printf " "
        else
            printf "*"
        fi
    done
    # 第三部分
    for (( j = 1; j <= 5-i; j++ )); do
        printf " "
    done
    printf "\n"
done