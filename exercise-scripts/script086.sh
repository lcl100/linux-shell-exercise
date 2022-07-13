#!/bin/bash

grep "tcp" nowcoder.txt | awk '{print $6}' | sort | uniq -c | sort -nr | awk '{print $2,$1}'