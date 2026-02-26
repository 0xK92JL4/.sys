#!/bin/bash
set -eu

# Chad-OS version
VERSION="d25m02_2026"

#**************************************************************#
#                           SETTINGS                           #
#**************************************************************#

# Partition
DEVICE="sdX"
BOOT_SIZE="512MiB"
ROOT_SIZE="24GiB"
HOME_SIZE="64GiB"

# System
HOST_NAME="chad"
NUSER="ugo"
EDITOR="vim"


#**************************************************************#
#                                                              #
#                      CHAD-OS INSTALLER                       #
#                                                              #
#**************************************************************#


LOGFILE="/tmp/installation.log"
exec > >(tee -a "$LOGFILE") 2>&1


#**************************************************************#
#                        PREREQUISITES                         #
#**************************************************************#

# Passwords
read -rsp "Enter root password: " ROOT_PASSWORD ; echo
read -rsp "Enter user password: " NUSER_PASSWORD ; echo

# Partition confirmation
lsblk -f
echo "WARNING: All data on $DEVICE will be erased!"
read -rp "Type ERASE to continue: " CONFIRM
if [ "$CONFIRM" != "ERASE" ]; then
    echo "Aborting installer. filesystem preserved."
    exit 1
fi

#**************************************************************#
#                         PARTITIONING                         #
#**************************************************************#

echo "Partitioning $DEVICE..."
parted /dev/$DEVICE mklabel gpt
parted /dev/$DEVICE mkpart primary 1MiB $BOOT_SIZE
parted /dev/$DEVICE set 1 boot on
parted /dev/$DEVICE mkpart primary $BOOT_SIZE $ROOT_SIZE
parted /dev/$DEVICE mkpart primary $ROOT_SIZE $HOME_SIZE

# Partition names
if [[ "$DEVICE" == nvme* ]]; then
    BOOT_PART="${DEVICE}p1"
    ROOT_PART="${DEVICE}p2"
    HOME_PART="${DEVICE}p3"
else
    BOOT_PART="${DEVICE}1"
    ROOT_PART="${DEVICE}2"
    HOME_PART="${DEVICE}3"
fi

# Formatting
mkfs.fat -F32 /dev/$BOOT_PART
mkfs.ext4 /dev/$ROOT_PART
mkfs.ext4 /dev/$HOME_PART

# Mounting
mount /dev/$ROOT_PART /mnt
mount --mkdir -o fmask=0137,dmask=0027 /dev/$BOOT_PART /mnt/boot
mount --mkdir /dev/$HOME_PART /mnt/home

mkdir -p /mnt/tmp
chmod 1777 /mnt/tmp

#**************************************************************#
#                     PACKAGES INSTALLATION                    #
#**************************************************************#

echo "Installation of the base packages..."
pacstrap /mnt base linux linux-firmware base-devel networkmanager git

#**************************************************************#
#                     SYSTEM CONFIGURATION                     #
#**************************************************************#

echo "Chad-OS Configuration..."

# Fstab
genfstab -U -p /mnt >> /mnt/etc/fstab
echo "tmpfs /tmp tmpfs defaults,noatime,mode=1777 0 0" >> /mnt/etc/fstab

# Chroot
SYS_DIR="/home/$NUSER/.sys"
HOME_DIR="/home/$NUSER"
arch-chroot /mnt /bin/bash << CHROOT_END

# Time
ln -sf /usr/share/zoneinfo/Europe/Paris /etc/localtime
hwclock --systohc

# Locale
echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf

# Network
echo "$HOST_NAME" > /etc/hostname
cat >> /etc/hosts << HOSTS
127.0.0.1   localhost
::1         localhost
127.0.1.1   $HOST_NAME.localdomain $HOST_NAME
HOSTS
systemctl enable NetworkManager.service

# Bootloader
bootctl --path=/boot install
cat > /boot/loader/loader.conf <<-LOADER
	default arch.conf
	timeout 3
	editor 0
LOADER
cat > /boot/loader/entries/arch.conf <<-ENTRY
	title   Chad-OS
	linux   /vmlinuz-linux
	initrd  /initramfs-linux.img
	options root=PARTUUID=\$(blkid -s PARTUUID -o value /dev/$ROOT_PART) rw
ENTRY

# Root password
echo "root:$ROOT_PASSWORD" | chpasswd

# User
useradd -m -G wheel $NUSER
echo "$NUSER:$NUSER_PASSWORD" | chpasswd
echo "%wheel ALL=(ALL) ALL" >> /etc/sudoers

# Pacman keyring
pacman-key --init
pacman-key --populate archlinux

# Install programs
pacman -Syu --noconfirm \
    alsa-utils arch-install-scripts cmake cmus ctags \
    discord dunst firefox fontconfig freetype2 glfw htop \
    libmad libreoffice-fresh libx11 libxft libxinerama \
    lldb man-db man-pages mupdf noto-fonts-cjk noto-fonts-emoji \
    ntfs-3g numlockx openssh pavucontrol picard playerctl \
    pulseaudio pulseaudio-alsa pulseaudio-bluetooth \
    tree unclutter unzip valgrind vim xbindkeys xclip \
    xf86-video-vesa xorg xorg-xinit xwallpaper zip zoxide

# Audio
pactl set-sink-mute 0 0

# Custom files
cd $HOME_DIR
git clone https://github.com/0xK92JL4/.sys.git

mkdir -p $HOME_DIR/.local/bin $HOME_DIR/.local/app $HOME_DIR/.config
cd $HOME_DIR/.local/app
git clone https://github.com/trapd00r/vidir.git

ln -sf $SYS_DIR/dotfiles/.* $HOME_DIR
ln -sf $SYS_DIR/dotfiles/.* /root
ln -f $SYS_DIR/binfiles/* $HOME_DIR/.local/bin
ln -sf $SYS_DIR/config/* $HOME_DIR/.config
ln -f $HOME_DIR/.local/app/vidir/bin/vidir $HOME_DIR/.local/bin

touch $HOME_DIR/.notes

# cmus theme
mkdir -p /usr/share/cmus
cp $SYS_DIR/other/*.theme /usr/share/cmus

# ENV variable
cat >> /etc/environment <<-ENVIRONMENT
	NUSER="$NUSER"
	CHAD_OS="$VERSION"
	EDITOR="$EDITOR"
ENVIRONMENT

# install font
mkdir -p /home/$NUSER/Downloads
curl -L -o /home/$NUSER/Downloads/Hack.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.0/Hack.zip
unzip /home/$NUSER/Downloads/Hack.zip -d /usr/share/fonts/

# Suckless build
cd "$SYS_DIR/suckless/dwm" && make clean install
cd "$SYS_DIR/suckless/st" && make clean install
cd "$SYS_DIR/suckless/dmenu" && make clean install
cd "$SYS_DIR/suckless/slock" && make clean install
chown -R "$NUSER:$NUSER" /home/$NUSER/
groupadd -f nogroup

# X11 configuration
touch /etc/X11/xorg.conf
cat >> /etc/X11/xorg.conf << XCONF
Section "ServerFlags"
    Option "DontZap" "True"
EndSection
XCONF

# Enable system request
echo "kernel.sysrq = 1" >> /etc/sysctl.d/99-sysrq.conf

exit
CHROOT_END

# Logs
cp "$LOGFILE" /mnt/home/$NUSER/

# Finalizing
umount -R /mnt
reboot
