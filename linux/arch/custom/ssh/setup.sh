#!/bin/sh

echo "Configuring SSH"
[ ! -e ~/.ssh/id_rsa ] && ssh-keygen -t rsa -b 4096 -a 100

read -p "Enable sshd? [y/N]" -n 1 -r && echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    read -p "Disable SSH password login and root login? [y/N]" -n 1 -r && echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        sudo sed \
            -e '/^#\?PermitRootLogin prohibit-password$/c PermitRootLogin no' \
            -e '/^#\?PasswordAuthentication yes$/c PasswordAuthentication no' \
            -e '/^#\?KbdInteractiveAuthentication yes$/c KbdInteractiveAuthentication no' \
            -e '/^#\?UsePAM yes$/c UsePAM no' \
            -i /etc/ssh/sshd_config
        systemctl is-active --quiet sshd.service && sudo systemctl reload sshd.service
    fi

    sudo systemctl enable sshd.service
    sudo systemctl start sshd.service
fi
