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
        mkpart primary 0% 261MiB \
        name 1 esp \
        mkpart primary 261MiB 100% \
        name 2 crypto-luks
    # synchronize cached writes to make the partitions visible
    sync

    # prepare mount points
    mkdir -p /mnt/boot

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
    mount "$efi_system_partition" /mnt/boot
    mount "/dev/$VOLUME_GROUP/root" /mnt
    swapon "/dev/$VOLUME_GROUP/swap"
}

pre_install()
{
    if ! ls /sys/firmware/efi/efivars > /dev/null; then
        echo "Only UEFI is supported"
        exit 1
    fi
    if ! pacman -Qi fzf > /dev/null 2>&1; then
        pacman -Sy
        pacman -S fzf
    fi
    timedatectl set-ntp true
    install_partitions
}

post_install()
{
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
