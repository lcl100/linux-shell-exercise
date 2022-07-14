#!/bin/bash

vsz_sum=$(awk '{print $5}' nowcoder.txt | grep -E "[0-9]+" | awk '{sum+=$0} END{print sum/1024}')
rss_sum=$(awk '{print $6}' nowcoder.txt | grep -E "[0-9]+" | awk '{sum+=$0} END{print sum/1024}')

echo "MEM TOTAL"
echo "VSZ_SUM:${vsz_sum}M,RSS_SUM:${rss_sum}M"