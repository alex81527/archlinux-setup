# Archlinux Installation Walkthrough  
Refer to [Official Archlinux Installation Guide](https://wiki.archlinux.org/index.php/installation_guide) for details.  

+ Verify boot mode, if it exits, you are booted in EFI mode.  
`# ls /sys/firmware/efi/efivars`  
+ Connect to Internet (e.g. WiFi)  
`# wifi-menu`  
`# ping -c 3 www.google.com`  
+ Update the system clock  
`# timedatectl set-ntp true`
+ Partition the disks ([Example layout schemes](https://wiki.archlinux.org/index.php/Partitioning#Example_layouts))  
UEFI+GPT:  
`# parted /dev/sda`  
`(parted) mklabel gpt`  
`(parted) mkpart ESP fat32 1MiB 513MiB`//the recommended size is 512MiB  
`(parted) set 1 boot on`  
`(parted) mkpart primary linux-swap 513MiB 4.5GiB`//swap space  
`(parted) mkpart primary ext4 4.5GiB 100%`  
`(parted align-check optimal N)`// N=1,2,... For performance concern, check if each partition is aligned.  
`(parted) quit`   
BIOS+MBR:  
`# parted /dev/sda`  
`(parted) mklabel msdos`  
`(parted) mkpart primary linux-swap 1MiB 4GiB` //swap space  
`(parted) mkpart primary ext4 4GiB 100%` //root mount point  
`(parted) set 2 boot on`  
`(parted align-check optimal N)`// N=1,2,... For performance concern, check if each partition is aligned.  
`(parted) quit`  
+ Format the partitions  
`# mkswap /dev/sda1`  
`# swapon /dev/sda1`  
`# mkfs.ext4 /dev/sda2`  
For UEFI:  
`# mkfs.fat -F32 /dev/sdxY`  
If you get `WARNING: Not enough clusters for a 32 bit FAT!`, reduce cluster size with mkfs.fat -s2 -F32 ... or -s1;  
+ Mount the file systems  
`mount /dev/sda2 /mnt`  
For UEFI:  
`mount /dev/sdxY /boot`  
+ Install Archlinux (zsh for later use of `useradd`)  
`# pacstrap -i /mnt base base-devel vim zsh`  
+ Configuration  
> `# genfstab -U /mnt > /mnt/etc/fstab`  
> `# arch-chroot /mnt`  
> `# vim /etc/locale.gen`  
>> uncomment the following:  
>> en_US.UTF-8 UTF-8  
>> zh_TW.UTF-8 UTF-8 (gcin needs LC_CTYPE=zh_TW.UTF-8, and gnome-terminal will have locale issues if this line is commented)  
>> zh_TW BIG5  

`# locale-gen`  
> `# echo "LANG=en_US.UTF-8" > /etc/locale.conf`  
> `# ln -sf /usr/share/zoneinfo/<yourtimezone> /etc/localtime`  
> `# hwclock --systohc`  
> `# mkinitcpio -p linux` create /boot/initramfs-linux.img  
> `# pacman -S grub os-prober`  
> `# grub-install --recheck /dev/sda`  
> `# grub-mkconfig -o /boot/grub/grub.cfg`  
> `# echo "<yourhostname>" > /etc/hostname`  
> `# vim /etc/hosts` add _yourhostname_  
> `# pacman -S dialog wpa_supplicant iw` so we can use wifi-menu at next boot  
> `# passwd` change passwd for root  
> `# useradd -m -s $(which zsh) -G wheel <username>` Add your user account  
> `# passwd <username>` change passwd  
> `# visudo` uncomment wheel, giving it root privilege  
> `# exit`  
+ Reboot  
`# umount -R /mnt && reboot`  

# Archlinux Postinstallation Setup  
+ Check if all devices have their kernel modules in use  
`# lspci -v`  
+ Automatic setup script  
`sudo sh -c "$(curl -fsSL https://raw.githubusercontent.com/alex81527/archlinux-setup/master/arch-post-setup.sh)"`  





