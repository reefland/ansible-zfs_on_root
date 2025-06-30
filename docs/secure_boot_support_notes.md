# UEFI Secure Boot Support

[Back to README.md](../README.md)

When UEFI Secure Boot Support is enabled packages for signing rEFInd and ZFSbootMenu EFI images will be installed and the image files will be signed to support Secure Boot.  You will not have to manually enroll EFI images / keys into your UEFI BIOS and you would not have to disable Secure Boot.  In addition you would not have to enroll images again when rEFInd or ZFSBootMenu updates are applied.  A watcher service is installed to automatically resign these updated EFI images.

For this to work during the ZFS on Root installation process, you must put your computer into UEFI _Setup Mode_ which is enabled within your UEFI Secure Boot screen.  You would typically delete any existing keys and enable setup mode within the UEFI and then boot the Ubuntu LiveCD image to start the ZFS on Root process.

When enabled, the following process happens:

  1. `create-keys` will generate the local set of keys.
  2. `enroll-keys` will enroll the new keys and the default Microsoft keys into the UEFI SecureBoot EFI variables
  3. Sign `refind_x64.efi` and `zfsbootmenu.efi` and if EFI Fallback is enaBLED enabled `bootx64.efi`.

A **systemd-path** config is put in place for `/etc/systemd/system/zfsbootmenu-update*` and `/etc/systemd/system/refind-update*` to watch the ZFSbootMenu and rEFInd files. If they are changed (eg. upgraded) then a new efi bundle is created and signed. You don't have to remember to re-create and sign when you upgrade.

---

## Troubleshooting Secure Boot Support

### Disabled in UEFI/BIOS

If Secure Boot Support is set to `true`, but Secure Boot is disabled within the UEFI/BIOS Secure Boot menu screen, the Ansible Process will detect this and fail with a message such as:

```text
TASK [ansible-zfs_on_root : Confirm Secure Boot is in Setup Mode] *************

fatal: [mycomputer.localdomain]: FAILED! => changed=false
  assertion: secure_boot_setup_mode_check.stdout == "true"
  evaluated_to: false
  msg: |-
    ERROR: UEFI Secure Boot is not in Setup Mode.
     Please set it to Setup Mode in the BIOS/UEFI settings,
     or set variable `efi_secure_boot_enabled` to false to disable.

     Status:
    Installed:      ✗ sbctl is not installed
    Setup Mode:     ✓ Disabled
    Secure Boot:    ✗ Disabled
    Vendor Keys:    microsoft builtin-PK
```

* You need to go into your UEFI/BIOS and Enable Secure Boot.  Also put it into Setup Mode to avoid the failure message shown below.
* On AMI/Aptio UEFI/BIOS this is often under:
  * `Security` > `Secure Boot` > `Secure Boot Enabled: [Enabled]`.

## Enabled Secure Boot Setup Mode

If Secure Boot Support is set to `true` and Secure Boot is enabled within the UEFI/BIOS but Secure Boot has not been placed into _Setup Mode_, the Ansible Process will detect this and fail with a message such as:

```text
TASK [ansible-zfs_on_root : Confirm Secure Boot is in Setup Mode] *************

fatal: [acepc01.rich-durso.us]: FAILED! => changed=false
  assertion: secure_boot_setup_mode_check.stdout == "true"
  evaluated_to: false
  msg: |-
    ERROR: UEFI Secure Boot is not in Setup Mode.
     Please set it to Setup Mode in the BIOS/UEFI settings,
     or set variable `efi_secure_boot_enabled` to false to disable.

     Status:
    Installed:      ✗ sbctl is not installed
    Setup Mode:     ✓ Disabled
    Secure Boot:    ✓ Enabled
    Vendor Keys:    microsoft builtin-PK
```

* You need to go into your UEFI/BIOS and Enable Setup Mode.
  1. Confirm you can see the Ubuntu USB key as a boot option, typically under:
      * `Boot` > `Boot Options` or
      * `Save & Exit` > `Boot Override`
      * If you can't find the Ubuntu USB, power off, change USB ports and try again. Don't proceed until you know its available.
  2. Enable Setup Mode in UEFI/BIOS this is often under:
      * `Security` > `Secure Boot` > `Secure Boot Mode: [Custom]`
      * Then `Security` > `Secure Boot` > `Reset to Setup Mode`, acknowledge any warning or notices to proceed (this will erase EFI variables and any existing keys).
        * Note: you can always use the option to Restore Factory Keys to go beck to the default EFI configuration.
  3. Enroll the Ubuntu USB UEFI boot image. This step is now required to boot the USB as the previous step deleted all keys.
      * Look for something like `Security` > `Secure Boot` > `Key Management`.
      * Typically you will find an option to `Restore Factor Keys` here, but look for the option to `Enroll EFI Image` and select that.
      * You should see a dialog box of some type allowing you to select a device or browse file systems.
        * Find the USB Key; hopefully "USB" is somewhere in the name as it will show all EFI volumes it can detect and you have to pick the correct one.
      * After selecting the device, you should then be able to browse it, navigate as follows and add images:
        * `<EFI>/boot/bootx64.efi`
        * Other `*.efi` images can be ignored.
      * Confirm you wish to enroll Efi image, you should get a "Success" message.
        * A "Failed!" message often means this is a duplicate Efi image, are you sure you Rest to Setup Mode?
      * Go back to `Save & Exit`.
  4. Upon reboot the Ubuntu USB should start booting.

[Back to README.md](../README.md)
