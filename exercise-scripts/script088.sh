#!/bin/bash

awk '/tcp/{
  split($5, a, ":")
  map[a[1]]++
} END{
  for(k in map)
    print k,map[k]
}' nowcoder.txt | sort -nr -k 2