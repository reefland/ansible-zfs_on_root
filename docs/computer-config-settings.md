# Computer Configuration Settings

[Back to README.md](../README.md)

## UEFI or Legacy BIOS

Does not matter if UEFI or Legacy BIOS is used. When available UEFI will be used, if not available it will automatically fallback to BIOS.  You should be easily able to move between these options.

## Default Domain Name

The default domain name to assign to computers can be defined here.  This value can be overridden per host in the inventory file as needed.

```yaml
# Default domain hosts will use if not defined in inventory file
domain_name: "localdomain"
```

## rEFInd Boot Menu Timeout

By default rEFInd boot menu will wait 20 seconds for you take make a section.  This is a bit on the long side for most configurations.  This value will override this configuration:

```yaml
# rEFInd Boot Menu Timeout by default is 20 seconds.
refind_boot_menu_timeout: "10"
```

## rEFInd Boot Menu Logo / Background

By default the rEFInd boot menu configuration will enable a logo or custom background to be displayed.

```yaml
# Enables background image for refind / syslinux
refind_boot_menu_logo: true
```

An image can be specified for both UEFI or Syslinx (legacy) booting.  Two default images are provided. There are restrictions on format and size you need tro research if you want to change these.

```yaml
# Needs to be a JPG or PNG file.
refind_boot_menu_logo_filename: "ubuntu-style.png"

# Needs to be a JPG or PNG file at 640x48 for syslinux.
syslinux_boot_menu_logo_filename: "ubuntu-style-sm.png"
```

## ZFS Boot Menu Compile

Use the ZFSBootMenu Kernel binary or build from source? The Kernel binary does not enable networking support and is not compatible with Dropbear for entering ZFS encryption passwords.

The default value is set to the same value for Dropbear enabled or not.

```yaml
# Default: if "enable_dropbear_support" is true then "zfs_boot_menu_compile"
# is true.
zfs_boot_menu_compile: "{{ enable_dropbear_support }}"

```

## EFI Fallback

Required with some buggy UEFI BIOS which are hard coded to only look for a specific UEFI name such as `bootx64.efi` and do nt allow alternate names or locations. All my Minisforum computers have this limitation.

When enabled a copy of `refind_x64.efi` will be copied to `bootx64.efi` location.

```yaml
efi_fallback_enabled: false
```

## Take ZFS Base Install Snapshot

Take a ZFS snapshot of the base system install named "@base_install". This would be a "pristine" snapshot of the system after the initial install and configuration of the system.  This is useful for restoring the system to a known good state.

* This is performed as the last task in the "final_setup" task.

```yaml
take_base_install_snapshot: false
```

## UEFI Secure Boot Support

When enabled packages for signing rEFInd and ZFSbootMenu will be installed and the packages will be signed to support Secure Boot.  You will not have to manually enroll EFI images / keys into your UEFI BIOS.

For this to work, you must put your computer into UEFI Setup Mode which is enabled within your UEFI Secure Boot screen.  You would typically delete any existing keys and enable setup mode within the UEFI and then boot the Ubuntu LiveCD image to start the ZFS on Root process.

When enabled, the following process happens:

  1. `create-keys` will generate the local set of keys.
  2. `enroll-keys` will enroll the new keys and the default Microsoft keys into the UEFI SecureBoot EFI variables
  3. Sign `refind_x64.efi` and `zfsbootmenu.efi` and if EFI Fallback is enaBLED enabled `bootx64.efi`.
  4. Watcher services are install to resign files if they are updated in the future.

```yaml
efi_secure_boot_enabled: false
```

For more information see [Secure Boot Support Notes](secure_boot_support_notes.md).

## CLI or Full Desktop

Select if full graphical desktop or command-line server only.

```yaml
# For Full GUI Desktop installation (set to false) or command-line only server environment (set to true)
command_line_only: true
```

## Enable Ubuntu LTS Hardware Enablement Kernel

This provides newer kernels than the default LTS kernel.

```yaml
# The Ubuntu LTS enablement (also called HWE or Hardware Enablement) stacks
# provide newer kernel and X support for existing Ubuntu LTS releases.
enable_ubuntu_lts_hwe: false
```

## Define Locale and Timezone

Set your locale and timezone information.

```yaml
# Define the local pre-fix to enable in /etc/locale.gen
locale_prefix: "en_US"

# Define the timezone to be placed in /etc/timezone
timezone_value: "America/New_York"
```

## Disable IPv6 Networking

By default IPv6 networking will be disabled.  If you have a need for it, you can set `ipv6.disable: false`. You can also customize which settings are applied and how they are applied as well.

```yaml
# Disable IPv6 if you do not use it.  The "disable_settings" will be applied to
# "conf_file"
ipv6:
  disable: true
  conf_file: "/etc/sysctl.d/99-sysctl.conf"
  disable_settings:
    - "net.ipv6.conf.all.disable_ipv6 = 1"
    - "net.ipv6.conf.default.disable_ipv6 = 1"
    - "net.ipv6.conf.lo.disable_ipv6 = 1"
  apply_cmd: "sysctl -p"
```

## Additional Installed Packages

These are the packages to be be applied to the towards the end of the build process to be included as part of the base system installation.

```yaml
# Define additional packages to install once the build has completed.
additional_install_packages:
  - man
  - udisks2
  - pciutils
  - net-tools
  - ethtool
  - fonts-ubuntu-console
  - htop
  - pollinate
  - fwupd
  - needrestart
  - unattended-upgrades
  - lz4
```

## MSMTP SMTP Email Client

`msmtp` is a simple and easy to use SMTP client. This is intended for system SMTP notifications by the `root` user.  These variables are passed to an Ansible Galaxy role which can be reviewed at <https://github.com/chriswayg/ansible-msmtp-mailer>.

Multiple email accounts can be defined, along with a default account to use.  Below shows a `gmail.com` configuration.  

* Values for `from`, `user` and `password` are defined within `vars/secrets/main.yml`.
* See [MSMTP Configuration Settings](msmtp-settings.md) for more details.

```yaml
msmtp:
  enabled: true
  msmtp_domain: "gmail.com"
  # Default email alias name to sent alerts to (required)
  msmtp_alias_default: "{{ secret_msmpt_send_to_email | default('not defined within vars/secrets/main.yml') }}"
  # Optional Email alias address to redirect "root" emails to
  # msmtp_alias_root: "other.account.for.root@gmail.com"
  # Optional Email alias address to redirect "cron" emails to
  # msmtp_alias_cron: "other.account.for.cron@gmail.com"

  msmtp_default_account: "gmail"
  accounts:
    - account: "gmail"
      host: "smtp.gmail.com"
      port: "587"
      auth: "on"
      from: "{{ secret_msmtp_send_from_email | default('not defined within vars/secrets/main.yml') }}"
      user: "{{ secret_msmtp_auth_user | default('not defined within vars/secrets/main.yml') }}"
      password: "{{ secret_msmtp_auth_password | default('not defined within vars/secrets/main.yml') }}"
```

To send a test email once configured:

```shell
echo "test message" | sudo mailx -s "Test from $HOSTNAME" <somebody>@gmail.com
```

* Logs: `/var/log/msmtp.log`
* Config: `/etc/msmtprc`

[Back to README.md](../README.md)
