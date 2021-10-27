#!/bin/sh

# TODO distro independent

install_yay ()
{
    sudo pacman -S fakeroot
    local dir=/tmp/yaybuild
    mkdir -p "$dir"
    curl -o "$dir/PKGBUILD" 'https://aur.archlinux.org/cgit/aur.git/plain/PKGBUILD?h=yay'
    (cd "$dir" && makepkg -si)
    rm -rf "$dir"
}

setup_software ()
{
    echo "TODO setup_software"
}

fzf_prompt()
{
    tac | fzf --prompt="$1> "
}

pacinstall()
{
    pacman -S --noconfirm --needed "$@"
}

get_partition_by_label()
{
    disk="$1"
    label="$2"
    lsblk -po PARTLABEL,KNAME -n "$disk" | grep "^$label\s" | awk '{print $2}'
}

install_partitions()
{
    # choose disk
    local disk=$(while true; do
        d="$(lsblk -p | fzf_prompt 'choose disk to use for installation' | awk '{print $1}')"
        if [ -z "$d" ]; then
            continue
        fi
        read -p "Installing on $d. All data will be deleted. OK? [y/N]"
        [[ $REPLY =~ ^[Yy]$ ]] && echo $d && break
    done)

    # fill the disk with random data
    read -p "Write random data to $disk? [y/N]"
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        cryptsetup open --type plain -d /dev/urandom "$disk" to_be_wiped
        dd if=/dev/zero of=/dev/mapper/to_be_wiped status=progress
        cryptsetup close to_be_wiped
    fi

    # physical partitioning
    echo "Partitioning $disk: adding esp and crypto-luks"
    parted --script "$disk" \
        mklabel gpt \
        mkpart esp fat32 1MiB 261MiB \
        set 1 esp on \
        mkpart crypto-luks 261MiB 100%
    # TODO while
    sleep 5

    # Create EFI system partition
    echo "Creating EFI system partition"
    local efi_system_partition="$(get_partition_by_label "$disk" "esp")"
    mkfs.fat -F32 "$efi_system_partition"

    # LUKS encryption
    local luks_partition="$(get_partition_by_label "$disk" "crypto-luks")"
    echo "Encrypting $luks_partition using LUKS"
    cryptsetup luksFormat "$luks_partition"
    echo "Opening encrypted partition and mapping it to /dev/mapper/cryptlvm"
    cryptsetup open "$luks_partition" cryptlvm

    # LVM partitioning inside LUKS
    echo "Initializing LVM on /dev/mapper/cryptlvm"
    pvcreate /dev/mapper/cryptlvm
    echo "Creating volume group on /dev/mapper/cryptlvm"
    read -p "Volume group name: " -i "ArchVolumeGroup" -e VOLUME_GROUP
    vgcreate "$VOLUME_GROUP" /dev/mapper/cryptlvm
    # swap size
    grep MemTotal /proc/meminfo | awk '$3=="kB"{$2=$2/1024/1024;$3="GB"} 1'
    local swap_size=$(while true; do
        read -p "Swap size (G is implied): "
        [ ! -z "${REPLY##*[!0-9]*}" ] && echo $REPLY && break
    done)
    echo "Creating swap partition on /dev/mapper/cryptlvm"
    lvcreate -L "${swap_size}G" "$VOLUME_GROUP" -n swap
    echo "Creating root partition on /dev/mapper/cryptlvm"
    lvcreate -l 100%FREE "$VOLUME_GROUP" -n root
    echo "Creating filesystems on partitions"
    mkfs.ext4 "/dev/$VOLUME_GROUP/root"
    mkswap "/dev/$VOLUME_GROUP/swap"

    # mount partitions
    echo "Mounting partitions to /mnt"
    mount "/dev/$VOLUME_GROUP/root" /mnt
    swapon "/dev/$VOLUME_GROUP/swap"
    mkdir -p /mnt/boot
    mount "$efi_system_partition" /mnt/boot

    # save variables for later
    mkdir -p /mnt/root/tmp_install_variables
    echo "$luks_partition" > /mnt/root/tmp_install_variables/luks_partition
    echo "$VOLUME_GROUP" > /mnt/root/tmp_install_variables/VOLUME_GROUP
}

install_base_system()
{
    pacstrap /mnt base linux linux-firmware
    genfstab -U /mnt >> /mnt/etc/fstab
}

configure_shell()
{
    pacinstall fish
    pacinstall neovim
    pacinstall ssh
    echo 'EDITOR=/usr/bin/nvim' >> /etc/environment
}

configure_location()
{
    ln -sf "$(find /usr/share/zoneinfo | fzf)" /etc/localtime
    hwclock --systohc
    # fuck yeah
    sed -e '/^#\?en_US.UTF-8 UTF-8$/c en_US.UTF-8 UTF-8' -i /etc/locale.gen
    locale-gen
    echo "LANG=en_US.UTF-8" > /etc/locale.conf
}

configure_network()
{
    while true; do
        read -p "Hostname: "
        [ ! -z "$REPLY" ] && echo "$REPLY" > /etc/hostname && break
    done
    pacinstall networkmanager
    systemctl enable NetworkManager.service
}

configure_encryption()
{
    pacinstall lvm2
    sed -e '/^HOOKS=/c HOOKS=(base udev autodetect keyboard keymap consolefont modconf block encrypt lvm2 filesystems fsck)' -i /etc/mkinitcpio.conf
    mkinitcpio -P
}

configure_users()
{
    echo "Configuring root user"
    passwd
    echo "Configuring regular user"
    regular_user=$(while true; do
        read -p "Enter regular user name: "
        [ ! -z "$REPLY" ] && echo "$REPLY" && break
    done)
    useradd -m -G wheel -s /bin/fish "$regular_user"
    passwd "$regular_user"
    pacinstall sudo
    EDITOR=/usr/bin/nvim visudo
}

configure_bootloader()
{
    # systemd-boot
    bootctl install
    mkdir -p /etc/pacman.d/hooks
    echo "\
[Trigger]
Type = Package
Operation = Upgrade
Target = systemd

[Action]
Description = Updating systemd-boot
When = PostTransaction
Exec = /usr/bin/bootctl update" \
    > /etc/pacman.d/hooks/100-systemd-boot.hook

    echo "\
default  arch.conf
timeout  4
console-mode max
editor   no" \
    > /boot/loader/loader.conf

    local cpu_vendor="$(grep vendor_id /proc/cpuinfo | head -1 | awk '{print $3}')"
    local initrd_ucode=""
    if [ "$cpu_vendor" = "AuthenticAMD" ]; then
        pacinstall amd-ucode
        initrd_ucode='initrd	/amd-ucode.img'
    elif [ "$cpu_vendor" = "GenuineIntel" ]; then
        pacinstall intel-ucode
        initrd_ucode='initrd	/intel-ucode.img'
    fi
    local luks_partition="$(< /root/tmp_install_variables/luks_partition)"
    local VOLUME_GROUP="$(< /root/tmp_install_variables/VOLUME_GROUP)"
    local uuid="$(basename "$(find -L /dev/disk/by-uuid/ -xtype l -samefile "$luks_partition")")"
    echo "\
title	Arch Linux
linux	/vmlinuz-linux
$initrd_ucode
initrd	/initramfs-linux.img
options	cryptdevice=UUID=$uuid:cryptlvm	root=/dev/$VOLUME_GROUP/root	resume=/dev/$VOLUME_GROUP/swap"\
    > /boot/loader/entries/arch.conf
}

configure_system()
{
    configure_shell
    configure_location
    configure_network
    configure_encryption
    configure_users
    configure_bootloader
}

pre_install()
{
    if ! ls /sys/firmware/efi/efivars > /dev/null; then
        echo "Only UEFI is supported"
        exit 1
    fi
    pacman -Sy
    pacinstall fzf
    timedatectl set-ntp true
    install_partitions
    install_base_system
    echo "Congratulations! You can now arch-chroot into /mnt and continue with post-installation"
}

post_install()
{
    pacinstall fzf
    configure_system
    exit # TODO
    install_yay
    yay --editmenu -S --needed - < linux/arch/pkglist.txt
    setup_software
}

trap 'exit 0' SIGINT

read -p "pre-install or post-install? [pre/post] "
case $REPLY in
    pre)
        pre_install
        ;;
    post)
        post_install
        ;;
    *)
        echo "Unrecognized option: $REPLY"
        exit 1;
        ;;
esac
