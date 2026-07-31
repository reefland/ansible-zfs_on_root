# Swap Partition Settings

[Back to README.md](../README.md)

* For a `single device`, swap will use the devices `-part2` partition.
* For `two devices` the swap partition will be joined into a `mdadm` based `mirror` (fixed size) across both devices (meaning if you define 4096 MB then it will be that size).  
* For `three or more devices` the swap partitions will be joined into a `mdadm` based `RAID10 stripe` across the disk devices.
  * The swap size can be estimated to be `((number of devices-1) x raidz_swap_partition_size_mb)`

_NOTE: Per ZFS on Root recommendations for Ubuntu swap partitions should not reside on ZFS partitions or zvols due to reports of ZFS deadlocks with swap.  Thus `mdadm` will be used for multiple device based swap configurations._

```yaml
###############################################################################
# Swap Partition Settings
###############################################################################
# Create Swap Partitions
enable_swap_partitions: false

# Swap partition size when one or two devices are used
single_or_mirror_swap_partition_size_mb: "4096"

# Swap partition size, per device, when three or more devices are used.
# Estimated size in MB is:  #devices-1 * size_MB
raidz_swap_partition_size_mb: "1024"
```

[Back to README.md](../README.md)
