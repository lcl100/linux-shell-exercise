#!/bin/bash

grep ":3306.*ESTABLISHED" nowcoder.txt | awk '{print $5}' | cut -d ":" -f 1 | sort | uniq -c | sort -nr | sed 's/[ \t]*//'