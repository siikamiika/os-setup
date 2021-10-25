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

install_partitions()
{
    local disk="$(lsblk -p | fzf | awk '{print $1}')"
    read -p "Installing on $disk. OK? [y/N]" -n 1 -r && echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
    grep MemTotal /proc/meminfo | awk '$3=="kB"{$2=$2/1024/1024;$3="GB"} 1'
    local swap_size=$(while true; do
        read -p "Swap size (G is implied): "
        [ ! -z "${REPLY##*[!0-9]*}" ] && echo $REPLY && break
    done)
    # TODO gdisk
    # Linux LUKS 	Any 	8309 	CA7D7CCB-63ED-4C53-861C-1742536059CC
    (
        #################################
        # create partition table
        #################################
        echo g                   # create a new empty GPT partition table
        #################################
        # add EFI System Partition
        #################################
        echo n                   # add a new partition
        echo                     # accept default partition number
        echo                     # accept default first sector
        echo +512M               # partition size
        echo t                   # change partition type
        echo uefi                # set type to EFI System Partition
        ##################################
        ## create swap (not here when using LUKS)
        ##################################
        #echo n                   # add a new partition
        #echo                     # accept default partition number
        #echo                     # accept default first sector
        #echo "+${swap_size}G"    # partition size
        #echo t                   # change partition type
        #echo                     # accept default partition number
        #echo swap                # set type to Linux swap
        ##################################
        # create Linux filesystem
        ##################################
        echo n                   # add a new partition
        echo                     # accept default partition number
        echo                     # accept default first sector
        echo                     # accept default partition size (everything that's left)
        echo t                   # change partition type
        echo                     # accept default partition number
        echo linux               # set type to Linux filesystem
        ##################################
        # persist changes
        ##################################
        echo w                   # write table to disk and exit
    ) | fdisk "$disk"
    read -p "Choose LUKS partition" -n 1 && echo
    local luks_partition="$(lsblk -po KNAME,SIZE -n "$disk" | grep -v "^$disk\s" | fzf | awk '{print $1}')"
    echo $luks_partition
}

pre_install()
{
    if ! ls /sys/firmware/efi/efivars > /dev/null; then
        echo "Only UEFI is supported"
        exit 1
    fi
    pacman -Sy
    pacman -S fzf
    timedatectl set-ntp true
    install_partitions
}

post_install()
{
    install_yay
    yay --editmenu -S --needed - < linux/arch/pkglist.txt
    setup_software
}

read -p "preinstall or post-install? [pre/post] "
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
