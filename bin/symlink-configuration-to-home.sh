#!/bin/sh

# run this after login

cp -r /etc/nixos ~/nixos
sudo rm -rf /etc/nixos
sudo ln -sf ~/nixos /etc/nixos
echo 'done'
