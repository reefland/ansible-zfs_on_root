# super1.x cannot open / Device or resource busy

[Back to README.md](../README.md)

## mdadm: super1.x cannot open / Device or resource busy Error

This happened after multiple partition creation / partitions deletes / mdadm array stop / create sessions during Ansible script development.  This is not expected with a clean setup.

### Ansible Error Message

```text
mdadm: super1.x cannot open /dev/disk/by-id/ata-<disk_name>-part1: Device or resource busy
mdadm: /dev/disk/by-id/ata-<disk_name>-part1 is not suitable for this array.
```

From within the Ubuntu Live CD environment, I issued:

```shell
sudo mdadm --stop /dev/md127
```

* The `/dev/md127` is the default autogenerated name.
* Re-executed the Ansible playbook and it completed successfully.

[Back to README.md](../README.md)