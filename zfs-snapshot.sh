#!/bin/bash

TIMESTAMP=`/bin/date --iso-8601`
if [ -z $ZFS_KEEP_SNAPSHOTS ]
then
  ZFS_KEEP_SNAPSHOTS=7
fi

for ZPOOL in `/sbin/zpool list -H -o name | sort`
do
  for ZFS in `/sbin/zfs list -H -r -o name "$ZPOOL" | sort`
  do
    ZFS_MOUNTPOINT=/`/sbin/zfs get -H -o name mountpoint "$ZFS"`
    # Take a snapshot
    if [ ! -e "$ZFS_MOUNTPOINT/.zfsignore" ]
    then
      /sbin/zfs snapshot "$ZFS@$TIMESTAMP"
    fi

    # Remove old snapshots
    if [ -e "$ZFS_MOUNTPOINT/.zfskeep" ]
    then
      if [ ! -s "$ZFS_MOUNTPOINT/.zfskeep" ]
      then
        ZFS_KEEP_SNAPSHOTS_="ALL"
      elif [[ `echo "$ZFS_MOUNTPOINT/.zfskeep"` =~ ^-?[0-9]+$ ]]
      then
        ZFS_KEEP_SNAPSHOTS_=`echo "$ZFS_MOUNTPOINT/.zfskeep"`
      else
        ZFS_KEEP_SNAPSHOTS_=$ZFS_KEEP_SNAPSHOTS
      fi
    else
      ZFS_KEEP_SNAPSHOTS_=$ZFS_KEEP_SNAPSHOTS
    fi

    if [[ $ZFS_KEEP_SNAPSHOTS_ != "ALL" ]]
    then
      /sbin/zfs list -H -o name -t snapshot -r -d 1 "$ZFS" \
      | sort -r | tail -n +$(($ZFS_KEEP_SNAPSHOTS + 1)) | while read ZFS_SNAPSHOT
      do
        /sbin/zfs destroy "$ZFS_SNAPSHOT"
      done
    fi
  done
done
