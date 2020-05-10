Arch Install
============

NOTE : This is a **Work In Progress**

Based on [Phantas0s ArchInstall](https://github.com/Phantas0s/ArchInstall/).

## Before using scripts

Assuming you have boot on a live Arch Linux.

You may first do some things :
- Load keyboard in french : `loadkeys fr`
- Connect to Wifi thanks to `wifi-menu` (you can test connection with a `ping 8.8.8.8` command)

## What's in there ? 

The first script `install_sys.sh` will :
1. Erase everything on `/dev/sda` **(!!!)**
2. Create partitions
    - Boot partition of 200M
    - Swap partition
    - Root partition
    - Home partition

