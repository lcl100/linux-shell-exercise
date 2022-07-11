#!/bin/bash

while read line; do
  num=$(echo -n ${line} | sed 's/\w/&\n/g' | grep -E -c "[0-9]")
  if [ ${num} -eq 1 ]; then
      echo ${line}
  fi
done < nowcoder.txt