#!/bin/bash

total_ip_count=$(grep ":3306" nowcoder.txt | awk '{print $5}' | sed 's/:3306//' | sort | uniq | wc -l)
established_count=$(grep -E ":3306.*ESTABLISHED" nowcoder.txt | awk '{print $5}' | wc -l)
total_link_count=$(grep -E ":3306.*ESTABLISHED" nowcoder.txt | wc -l)

echo "TOTAL_IP ${total_ip_count}"
echo "ESTABLISHED ${established_count}"
echo "TOTAL_LINK ${total_link_count}"