#!/bin/bash

# Warning message
dialog --defaultno --title "Are you sure ?" --yesno "This is my personnal arch linux install. \n\n\
    It will just DESTROY EVERYTHING on your hard disk (/dev/sda). \n\n\
    Don't say YES if you are not sure about what your are doing ! \n\n\
    Are you sure ?"  15 60 || exit

# Ask for some config params
dialog --no-cancel --inputbox "Enter a name for your computer." 10 60 2> comp

hderaser=$(dialog --no-cancel \
--title "!!! DELETE EVERYTHING !!!" \
--menu "Choose the way to destroy everything on your hard disk (/dev/sda)" 15 60 4 \
1 "Use dd (wipe all disk)" \
2 "Use schred (slow & secure)" \
3 "No need - my hard disk is empty" --output-fd 1)

dialog --no-cancel --inputbox "You need four partitions : Boot, Swap, Root and Home. \n\n\
    Boot will be 200M. \n\n\
    Enter partitionsize in GB, separated by space for root & swap. \n\n\
    If you dont enter anything: \n\
    root -> 40G \n\
    swap -> 16G \n\n\
    Home will take the rest of the space available" 20 60 2> psize

IFS=' ' read -ra SIZE <<< $(cat psize)

re='^[0-9]+$'
if ! [ ${#SIZE[@]} -eq 2 ] || ! [[ ${SIZE[0]} =~ $re ]] || ! [[ ${SIZE[1]} =~ $re ]] ; then
    SIZE=(40 16);
fi

dialog --infobox "Formatting /dev/sda..." 4 40

case $hderaser in
	1) dd if=/dev/zero of=/dev/sda status=progress;;
	2) shred -v /dev/sda;;
    3) ;;
esac

dialog --infobox "Creating partitions..." 4 40

# Use network time sync
timedatectl set-ntp true

#o - create a new MBR partition table
#n - create new partition
#p - primary partition
#e - extended partition
#w - write the table to disk and exit
cat <<EOF | fdisk /dev/sda
o
n
p


+200M
n
p


+${SIZE[1]}G
n
p


+${SIZE[0]}G
n
p


w
EOF
partprobe

# Create filesystems & swap
# sda1 : boot
# sda2 : swap
# sda3 : root
# sda4 : home
mkfs.ext4 /dev/sda1
mkfs.ext4 /dev/sda3
mkfs.ext4 /dev/sda4
mkswap /dev/sda2
swapon /dev/sda2
mkdir /mnt/boot
mount /dev/sda1 /mnt/boot
mount /dev/sda3 /mnt
mkdir /mnt/home
mount /dev/sda4 /mnt/home

# Select appropriate mirror
pacman -Syy --noconfirm
pacman -S --noconfirm reflector
cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak
reflector -c "FR" -f 12 -l 10 -n 12 --save /etc/pacman.d/mirrorlist

# Install Arch Linux
pacstrap /mnt base base-devel linux linux-firmware 

# Configure Arch system
genfstab -U /mnt >> /mnt/etc/fstab

### Continue installation
#curl https://raw.githubusercontent.com/Awkan/ArchInstall/master/install_chroot.sh > /mnt/install_chroot.sh \
#    && arch-chroot /mnt bash install_chroot.sh \
#    && rm /mnt/install_chroot.sh

cat comp > /mnt/etc/hostname \
    && rm comp

dialog --title "Reboot time" \
--yesno "Congrats ! The install is done ! \n\nTo run the new graphical environment, you need to restart your computer, log in and type \"startx\" \n\n You should restart your computer before trying your new shiny system. Do you want to restart now ?" 20 60

response=$?
case $response in
   0) reboot;;
   1) clear;;
esac

clear

