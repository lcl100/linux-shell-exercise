#!/bin/bash

awk -F ":" '{print $2":"$3}' nowcoder.txt | sort | uniq -c | sort -nr | sed 's/[ \t]*//'