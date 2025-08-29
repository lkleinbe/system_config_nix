# lkleinbe's Nix Configs

This repository contains my nixos configs.

There are multiple ways to install this system based on if you are trying to change an existing system or you want to install from a new life-cd.
I don't know yet which version is preferable so I just list everything I know

## Existing System default
This will install the configs in /etc/nixos/
```
cd /etc/nixos
sudo git init
sudo git remote add remote <repository-url>
sudo git fetch remote
sudo git reset --hard remote/<branch-name>
sudo nixos-rebuild switch --flake ./#<systems_name> --impure
```
Remember to set the users password with 
```
sudo passwd <username>
```

## Existing System with same User

For just trying out this system I suggest
```
git clone <repository-url>
cd <repository>
sudo nixos-rebuild switch --flake .#<systems_name> --impure
sudo systemctl restart display-manager.service
```
This will build the system from the existing repository in the users repository. It will not change anything in /etc/nixos/.
This will cause problems if the user is changed during this process so be careful

Remember to set the users password with 
```
sudo passwd <username>
```


## Fresh Install using Live-CD

This is not tested so execute with care.
```
parted -l
parted /dev/sda -- mklabel gpt
parted /dev/sda -- mkpart root ext4 512MB -8GB
parted /dev/sda -- mkpart ESP fat32 1MB 512MB
parted /dev/sda -- set 3 esp on
mkfs.ext4 -L nixos /dev/sda1
mkfs.fat -F 32 -n boot /dev/sda3
mount /dev/disk/by-label/nixos /mnt
mkdir -p /mnt/boot
mount -o umask=077 /dev/disk/by-label/boot /mnt/boot
git clone <repository-url> /mnt/etc/nixos
nixos-generate-config --root /mnt
nixos-install --flake /mnt/etc/nixos#<systems-name>
```
