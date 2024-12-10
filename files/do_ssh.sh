#!/bin/bash
#
# This is a helper script to reduce the amount of cut & paste 
# needed to get Live CD ready for ansible.
###############################################################

ANSIBLE_USER=ansible

# Create ansible account and a home directory to store SSH keys
echo
echo "-----------------------------------------------------------------------------"
sudo useradd -m $ANSIBLE_USER
if [[ $? -ne 0 ]]; then 
  echo ERROR: was unable to add $ANSIBLE_USER user, already created?
else
  echo Created user: $ANSIBLE_USER
fi

# Add user to sudoers file 
sudo bash -c "echo \"$ANSIBLE_USER ALL=(ALL) NOPASSWD:ALL\" >> /etc/sudoers.d/99_sudo_include_file"

# Validate sudoers file update
sudo visudo -cf /etc/sudoers.d/99_sudo_include_file
if [[ $? -ne 0 ]]; then 
  #Must return:   /etc/sudoers.d/99_sudo_include_file: parsed OK
  echo
  echo "ERROR: sudoers validation failed, something went wrong updating sudoers file."
  echo "Unable to continue."
  exit
fi

# Updated package repositories
sudo apt-get -qq update
if [[ $? -ne 0 ]]; then
  echo
  echo "ERROR: while updating package repositories (apt update), unable to continue."
  exit
fi

# install SSH Server and Python to allow ansible to connect
sudo apt-get --no-install-recommends --yes install openssh-server vim python3 python3-apt mdadm
if [[ $? -ne 0 ]]; then
  echo
  echo "ERROR: while installing required packages (apt install), unable to continue."
  exit
fi

# Disable swap partitions, we don't want them in use when partitions are removed.
sudo swapoff -a

# Disable automounting, if disk has been used before it will be mounted if not disabled
gsettings set org.gnome.desktop.media-handling automount false

# See if we are in a terminal or pipe
if [[ ! -p /dev/stdin ]]; then
  # In terminal ask user to define remote user password
  echo
  echo "-----------------------------------------------------------------------------"
  echo "Enter a temporary password for Ansible account. You will be prompted for this"
  echo "password when you attempt to push a generated SSH key to this account."
  echo
  echo "When installation is complete, the Ansible account will be password disabled,"
  echo "Only SSH key based login will be allowed."
  echo
  sudo passwd $ANSIBLE_USER
  while [ $? -ne 0 ]; do
      echo
      sleep 1
      sudo passwd $ANSIBLE_USER
  done
  echo
  echo "-----------------------------------------------------------------------------"
  echo "Completed.  Now push your ansible ssh key to this instance from the Ansible"
  echo "Control node."
else
  # Running in a pipe, remind user to change remote user password
  echo "-----------------------------------------------------------------------------"
  echo "IMPORTANT: You need to set a temporary password for the user: $ANSIBLE_USER"
  echo
  echo "Such as:    sudo passwd $ANSIBLE_USER"
  echo
  echo "Once that has been completed, you can push your ansible ssh key to this"
  echo "instance from the Ansible Control node."
fi 
# Done
