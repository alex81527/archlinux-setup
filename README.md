# Archlinux Installation Walkthrough  
Refer to [Official Archlinux Installation Guide](https://wiki.archlinux.org/index.php/installation_guide) for details.  

+ Verify boot mode, if it exits, you are UEFI supported  
`# ls /sys/firmware/efi/efivars`  
+ Connect to Internet  
`# wifi-menu`  
`# ping -c 3 www.google.com`  
+ Update the system clock  
`# timedatectl set-ntp true`
+ Partition the disks (Using MBR for example)  
`# parted /dev/sda`  
`(parted) mklabel msdos`
`(parted) mkpart primary linux-swap 1MiB 4GiB` //swap space  
`(parted) mkpart primary ext4 4GiB 100%` //root mount point  
`(parted) set 2 boot on`  
`(parted) quit`  
+ Format the partitions  
`# mkswap /dev/sda1`  
`# swapon /dev/sda1`  
`# mkfs.ext4 /dev/sda2`  
+ Mount the file systems  
`mount /dev/sda2 /mnt`  
+ Install Archlinux  
`# pacstrap -i /mnt base base-devel`  
+ Configuration  
> `# genfstab -U /mnt > /mnt/etc/fstab`  
> `# arch-chroot /mnt`  
> `# vim /etc/locale.gen` //uncomment at least en_US.UTF-8  
> `# locale-gen`  
> `# echo "LANG=en_US.UTF-8" > /etc/locale.conf`  
> `# ln -sf /usr/share/zoneinfo/<yourtimezone> /etc/localtime`  
> `# hwclock --systohc`  
> `# mkinitcpio -p linux` //create a new initramfs  
> `# pacman -S grub os-prober`  
> `# grub-install --recheck /dev/sda`  
> `# grub-mkconfig -o /boot/grub/grub.cfg`  
> `# echo "<yourhostname>" > /etc/hostname`  
> `# vim /etc/hosts` //add _yourhostname_  
> `# pacman -S dialog wpa_supplicant iw` //so we can use wifi-menu at next boot  
> `# passwd` //change passwd for root  
> `# exit`  
+ Reboot  
`# umount -R /mnt && reboot`  

# Archlinux Postinstallation Setup  
+ Check if all devices are working  
`# lspci -v`  
+ Automatic setup script  
`bash -c "$(curl -fsSL https://raw.githubusercontent.com/alex81527/archlinux-setup/master/arch-post-setup.sh)"`  






