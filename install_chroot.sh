# Set the root password
passwd

# Set the timezone
ln -sf /usr/share/zoneinfo/Europe/Paris /etc/localtime

# Set hardware clock from system clock
hwclock --systohc

# Configure locale
echo "fr_FR.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=fr_FR.UTF-8" >> /etc/locale.conf

# Install dialog for chroot
pacman --noconfirm --needed -S dialog

dialog --infobox "Install grub for boot..." 4 40

# Install boot
pacman --noconfirm --needed -S grub
grub-install /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg

#dialog --title "Continue installation" --yesno "Do you want to install all the softwares and the dotfiles ?" 15 60 \
#    && curl -LO https://raw.githubusercontent.com/Awkan/ArchInstall/master/install_root.sh \
#    && sh ./install_root.sh

