#!/bin/sh

echo "Configuring password menu"

pip install git+https://github.com/siikamiika/firefox-login-decryptor.git
sudo cp ./password_menu.py /usr/local/bin/
sudo cp ./password_menu_firefox.py /usr/local/bin/
