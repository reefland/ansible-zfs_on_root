# Customize ZFS Datasets to Create

[Back to README.md](../README.md)

Within file `vars/main.yml` is a yaml section named `datasets_to_create:`. This section lists the individual ZFS datasets to be created. Many of the traditional lesser used datasets have been commented out to reduce the number of zfs datasets being managed and respective number of zfs snapshots created. You can enable some or all as you see fit.

* NOTE: Even without the dataset being created, the respective directories will still be created as needed. They just will not be dedicated datasets.

```yaml
datasets_to_create:
  # - "{{ root_pool_dataset_path }}/srv"
  - "-o canmount=off {{ root_pool_dataset_path }}/usr"
  - "{{ root_pool_dataset_path }}/usr/local"
  - "-o canmount=off {{ root_pool_dataset_path }}/var"
  - "-o com.sun:auto-snapshot=false {{ root_pool_dataset_path }}/var/cache"
  # - "{{ root_pool_dataset_path }}/var/games"
  - "-o canmount=off {{ root_pool_dataset_path }}/var/lib"
  # - "{{ root_pool_dataset_path }}/var/lib/AccountsService"
  # - "{{ root_pool_dataset_path }}/var/lib/apt"
  # - "{{ root_pool_dataset_path }}/var/lib/dpkg"
  - "-o com.sun:auto-snapshot=false {{ root_pool_dataset_path }}/var/lib/docker"
  # - "{{ root_pool_dataset_path }}/var/lib/NetworkManager"
  - "{{ root_pool_dataset_path }}/var/log"
  # - "{{ root_pool_dataset_path }}/var/mail"
  # - "{{ root_pool_dataset_path }}/var/snap"
  # - "{{ root_pool_dataset_path }}/var/spool"
  - "-o com.sun:auto-snapshot=false {{ root_pool_dataset_path }}/var/tmp"
  # - "{{ root_pool_dataset_path }}/var/www"
```

* To uncomment remove the leading `#` and save the file.
* The variable `{{ root_pool_dataset_path }}` is a placeholder for root dataset aka `/` directory.
* The option `-o com.sun:auto-snapshot=false` indicates that the respective dataset should not have snapshots enabled (it is up to your snapshot generator to respect this value.)

[Back to README.md](../README.md)
