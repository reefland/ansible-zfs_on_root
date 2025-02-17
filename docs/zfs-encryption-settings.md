# ZFS Encryption Settings

[Back to README.md](../README.md)

## Force ZFS Encryption Passphrase Required

Within the `defaults/main.yml` you can make ZFS Native Encryption password required.  If this option is set to `true` and one as a command line variable `passphrase` is not provided, then you will be prompted to enter a passphrase.

```yaml
# Prompt for Native ZFS Encryption Passphrase.
prompt_for_zfs_passphrase: true
```

If a passphrase is provided (see below) it will be used.  This settings is only making it required (ask if not provided).

---

## How to Supply ZFS Encryption Passphrase

If a ZFS password is required per above, but you don't want to be prompted for a passphrase for the ZFS encryption, a passphrase can be specified using the Ansible command line parameter `--extra-vars` such as:

```bash
ansible-playbook -i inventory ./zfs_on_root.yml --extra-vars='{passphrase: "mySecr3tPa55"}'

```

The specified `passphrase` will define the boot password needed to decrypt the root pool.  The system is not bootable until the correct password is entered to decrypt the pool.

_NOTE: Any Ansible method to define the variable `passphrase` will be enough to trigger the script to reconfigure to support ZFS Native Encryption._

[Back to README.md](../README.md)
