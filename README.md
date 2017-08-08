# zfs-snapshot

`zfs-snapshot` is a small tool to take snapshots of entire zfs volume mounted on the system.

## Usage

Add `zfs-snapshot` to your `/etc/cron.d`. Modify the script path to your installation directory.

The script takes a snapshot named `YYYY-MM-DD`, then deletes snapshots older than 7 days by default.
You can specify `ZFS_KEEP_SNAPSHOTS` environmental variable to change the number of snapshots to be kept.
Another way to specify its behaviour is to place a file `.zfskeep` under mount path of your zfs volume,
which keeps all your old snapshots when `.zfskeep` is empty, or keeps the number of snapshots specified in `.zfskeep`.
You can also put `.zfsignore` on the mount path of which the script stops taking any more snapshots for the zfs volume.

## LICENSE

MIT as provided in `LICENSE.txt`
