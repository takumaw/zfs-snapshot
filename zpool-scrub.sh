#!/bin/bash

for ZPOOL in `/sbin/zpool list -H -o name | sort`
do
    zpool scrub "$ZPOOL"
done
