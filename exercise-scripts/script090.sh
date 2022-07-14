#!/bin/bash

server_version=$(grep "Server version:" nowcoder.txt | sed 's/.*Server version://')
server_name=$(grep "Server number:" nowcoder.txt | sed 's/.*Server number://')
os_name=$(grep "OS Name:" nowcoder.txt | sed 's/.*OS Name://' | sed 's/,.*//')
os_version=$(grep "OS Version:" nowcoder.txt | sed 's/.*OS Version://')

echo "serverVersion:${server_version}"
echo "serverName:${server_name}"
echo "osName:${os_name}"
echo "osVersion:${os_version}"