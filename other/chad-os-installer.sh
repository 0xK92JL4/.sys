#!/bin/bash

# Partition
DEVICE="sdX"
BOOT_SIZE="512MiB"
ROOT_SIZE="100GiB"

# System 
HOST_NAME="chad"
NUSER="ugo"
EDITOR="vim"

# Temp passwords
ROOT_PASSWORD="root"
NUSER_PASSWORD="$NUSER"

### Installation

# Partitioning
echo "Partitioning the disk..."
parted /dev/$DEVICE mklabel gpt
parted /dev/$DEVICE mkpart primary 1MiB $BOOT_SIZE
parted /dev/$DEVICE set 1 boot on
parted /dev/$DEVICE mkpart primary $BOOT_SIZE $ROOT_SIZE

# Format partitions
mkfs.fat -F32 /dev/${DEVICE}1
mkfs.ext4 /dev/${DEVICE}2

# Mounting partitions
mount /dev/${DEVICE}2 /mnt
mount --mkdir -o fmask=0137,dmask=0027 /dev/${DEVICE}1 /mnt/boot

# System installation
echo "Installing the base system..."
pacstrap /mnt base linux linux-firmware base-devel networkmanager git

# Fstab config
echo "Configuring fstab..."
genfstab -U -p /mnt >> /mnt/etc/fstab

# Chroot in
echo "Chrooting into the new environment..."
arch-chroot /mnt /bin/bash << EOF

# Time Config
echo "Configuring the clock..."
ln -sf /usr/share/zoneinfo/Europe/Paris /etc/localtime
hwclock --systohc

# Locale Gen
echo "Generating the locale..."
echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf

# Network Config
echo "Configuring the network..."
echo "$HOST_NAME" > /etc/hostname
echo "127.0.0.1   localhost" >> /etc/hosts
echo "::1         localhost" >> /etc/hosts
echo "127.0.1.1   $HOST_NAME.localdomain $HOST_NAME" >> /etc/hosts
systemctl enable NetworkManager.service

# Bootloader
echo "Installing systemd-boot..."
bootctl --path=/boot install
cat << EOF2 > /boot/loader/loader.conf
default arch.conf
timeout 3
editor 0
EOF2

cat << EOF2 > /boot/loader/entries/arch.conf
title   Arch Linux
linux   /vmlinuz-linux
initrd  /initramfs-linux.img
options root=PARTUUID=$(blkid -s PARTUUID -o value /dev/${DEVICE}2) rw
EOF2

# Root password configuration
echo "Setting up the root password..."
echo "root:$ROOT_PASSWORD" | chpasswd

# Adding new user
echo "Adding new user: $NUSER..."
useradd -m -G wheel $NUSER

# User password configuration
echo "Setting up the password for user $NUSER..."
echo "$NUSER:$NUSER_PASSWORD" | chpasswd

# Sudoers
echo "Adjusting sudoers permissions..."
echo "%wheel ALL=(ALL) ALL" >> /etc/sudoers

# Set keyrings
pacman-key --init
pacman-key --populate archlinux

# Programs installing
pacman -Syu --noconfirm \
  alsa-utils \
  cmus \
  discord \
  dunst \
  firefox \
  fontconfig \
  freetype2 \
  htop \
  libreoffice-fresh \
  libx11 \
  libxft \
  libxinerama \
  man-db \
  man-pages \
  mupdf \
  noto-fonts-cjk \
  noto-fonts-emoji \
  ntfs-3g \
  numlockx \
  openssh \
  pavucontrol \
  playerctl \
  pulseaudio \
  pulseaudio-alsa \
  pulseaudio-bluetooth \
  unclutter \
  unzip \
  vim \
  xbindkeys \
  xclip \
  xorg \
  xorg-xinit \
  xwallpaper \
  zip \
  zoxide

# setting pulseaudio
systemctl --user enable pulseaudio.socket
systemctl --user start pulseaudio.socket
systemctl --user enable pulseaudio.service
systemctl --user start pulseaudio.service
pactl set-sink-mute 0 0

# install custom system files + suckless softwares
cd /home/$NUSER
git clone https://github.com/0xK92JL4/.sys.git

######### not tested yet #########
# Git Programs installing
cd /opt
git clone https://github.com/trapd00r/vidir.git
######### not tested yet #########
EOF

# install custom system files
SYS_DIR="/home/$NUSER/.sys"
arch-chroot /mnt /bin/bash << EOF
ln -sf $SYS_DIR/dotfiles/.* /home/$NUSER/
ln -sf $SYS_DIR/dotfiles/.* /root
ln -f $SYS_DIR/binfiles/* /usr/local/bin/
mkdir -p /home/$NUSER/.config
ln -sf $SYS_DIR/config/* /home/$NUSER/.config/
touch /home/$NUSER/.notes

######### not tested yet #########
ln -f /opt/vidir/bin/vidir /usr/local/bin/
######### not tested yet #########

# define ENV variable
echo NUSER=\"$NUSER\" >> /etc/environment
echo EDITOR=$EDITOR >> /etc/environment

# install cmus theme
mkdir -p /usr/share/cmus
cp $SYS_DIR/other/* /usr/share/cmus/

# install font
mkdir -p /home/$NUSER/Downloads
curl -L -o /home/$NUSER/Downloads/Hack.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.0/Hack.zip
sudo unzip /home/$NUSER/Downloads/Hack.zip -d /usr/share/fonts/

# install suckless softwares
cd "$SYS_DIR/suckless/dwm" && make clean install
cd "$SYS_DIR/suckless/st" && make clean install
cd "$SYS_DIR/suckless/dmenu" && make clean install
cd "$SYS_DIR/suckless/slock" && make clean install
chown -R "$NUSER:$NUSER" /home/$NUSER/
groupadd nogroup
touch /etc/X11/xorg.conf
cat >> /etc/X11/xorg.conf << EOF2
Section "ServerFlags"
    Option "DontZap" "True"
EndSection
EOF2

# Chroot out
exit
EOF

# Finalizing installation 
umount -R /mnt
reboot
