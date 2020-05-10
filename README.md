Arch Install
============

NOTE : This is a **Work In Progress**

Based on [Phantas0s ArchInstall](https://github.com/Phantas0s/ArchInstall/).

## Pre-requisites

Assuming you have boot on a live Arch Linux.

You may first do some things :
- Load keyboard in french : `loadkeys fr`
- Connect to Wifi thanks to `wifi-menu` (you can test connection with a `ping 8.8.8.8` command)

# Install

To install Arch, be sure to have made the pre-requisites

Then, you can start install

```bash
curl -LO https://raw.githubusercontent.com/Awkan/ArchInstall/master/install_sys.sh
sh ./install_sys.sh
```

## What's in there ? 

The first script `install_sys.sh` will :
1. Erase everything on `/dev/sda` **(!!!)**
2. Create partitions
    - Boot partition of 200M
    - Swap partition
    - Root partition
    - Home partition

The second script `install_chroot` will:
1. Set up locale / time
2. Set up Grub for the boot

