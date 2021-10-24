#!/bin/sh

# copy efi vars to tmp so that they can be written to
cp /usr/share/edk2.git/ovmf-x64/OVMF_VARS-pure-efi.fd /tmp/my_vars.fd

# i guess this used to fix some nvidia gpu issues
# -M q35,kernel_irqchip=on \

qemu-system-x86_64 \
    -enable-kvm \
    -M pc-q35-3.1 \
    -display none \
    -monitor stdio \
    -vga none \
    -qmp unix:/tmp/qmp-sock,server,nowait \
    -m 8G \
    -smp 6,cores=6 \
    -cpu host,kvm=off \
    -net nic,model=virtio -net bridge,br=br0 \
    -device intel-hda \
    -device hda-duplex \
    -usb \
    -device usb-host,id=antlion,vendorid=0x0d8c,productid=0x002b \
    -device usb-host,id=dualshock4,vendorid=0x054c,productid=0x09cc \
    -object input-linux,id=kbd,evdev=/dev/input/by-id/windows-virt-kbd,repeat=on,grab_all=yes \
    -object input-linux,id=mouse,evdev=/dev/input/by-id/windows-virt-mouse \
    -device virtio-mouse-pci \
    -device virtio-keyboard-pci \
    -device ioh3420,id=root_port1,chassis=0,slot=0,bus=pcie.0 \
    -device vfio-pci,host=26:00.0,bus=root_port1,addr=0x00,multifunction=on \
    -device vfio-pci,host=26:00.1,bus=root_port1,addr=0x00.1 \
    -drive if=pflash,format=raw,readonly=on,file=/usr/share/edk2.git/ovmf-x64/OVMF_VARS-pure-efi.fd \
    -drive if=pflash,format=raw,file=/tmp/my_vars.fd \
    -device virtio-scsi-pci,id=scsi \
    -drive file=/dev/sdx,id=disk,format=raw,if=none,cache=writeback -device scsi-hd,drive=disk

#-display none \
#-monitor stdio \

#-device usb-host,id=kbd,vendorid=0x04d9,productid=0x4545 \
#-device usb-host,id=mouse,vendorid=0x1af3,productid=0x0001 \
#-device usb-host,id=gamepad,vendorid=0x046d,productid=0xc21d \
#-device usb-host,id=dualshock4,vendorid=0x054c,productid=0x09cc \
#-device usb-host,id=antlion,vendorid=0x0d8c,productid=0x002b \
#-device usb-host,id=gomic,vendorid=0x17a0,productid=0x0302 \
#-device usb-host,id=mediakeyboard,vendorid=0x046d,productid=0xc52b \
#-device usb-host,id=phone,vendorid=0x12d1,productid=0x108a \
#-object input-linux,id=kbd,evdev=/dev/input/by-id/usb-04d9_USB_Keyboard-event-kbd,repeat=on,grab_all=yes \
#-object input-linux,id=mouse,evdev=/dev/input/by-id/usb-Kingsis_Peripherals_ZOWIE_Gaming_mouse-event-mouse \
#-object input-linux,id=mouse2,evdev=/dev/input/by-id/usb-Logitech_G500_5B78C0A5180018-event-mouse \
#-object input-linux,id=mousekbd2,evdev=/dev/input/by-id/usb-Logitech_G500_5B78C0A5180018-if01-event-kbd \
#-object input-linux,id=jesari,evdev=/dev/input/by-id/usb-Logitech_USB_Keyboard-event-kbd \
#-device virtio-mouse-pci \
#-device virtio-keyboard-pci \

#-object memory-backend-file,id=ivshmem,share=on,mem-path=/dev/shm/looking-glass,size=32M \
#-device ivshmem-plain,memdev=ivshmem \

# -device virtio-balloon-pci,id=balloon \

#-net nic -net tap,ifname=tap0,script=no,downscript=no \
#-redir tcp:24800::24800 \
#-redir tcp:9874::9874 \
#-redir tcp:9873::9873 \

#-device vfio-pci,host=00:1b.0 \

#-drive file=/home/siikamiika/kvm/w10.iso,id=isocd,format=raw,if=none -device scsi-cd,drive=isocd \
#-drive file=/home/siikamiika/kvm/virt.iso,id=virtiocd,if=none,format=raw -device ide-cd,bus=ide.1,drive=virtiocd \

#-qmp unix:/tmp/qmp-sock,server,nowait \
