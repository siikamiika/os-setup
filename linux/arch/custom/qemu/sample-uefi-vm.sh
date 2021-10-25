#!/bin/sh

# create drive:
# qemu-img create drive.img 20G

qemu-system-x86_64 \
    -enable-kvm \
    -m 1G \
    -net user,hostfwd=tcp::2222-:22 \
    -net nic \
    -drive if=pflash,format=raw,readonly=on,file=/usr/share/edk2-ovmf/x64/OVMF.fd \
    -drive format=raw,file=./drive.img \
    -cdrom ./os.iso \
    -boot d
