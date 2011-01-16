#! /bin/bash
echo "USE: $0 [AnonOS.iso]"
CURDIR=`pwd`

echo "Installing required tools..."
echo "Benötigte Tools auf dem Ubuntu-Arbeitssystem installieren"
sudo -H aptitude -y install squashfs-tools genisoimage

echo "Loading the squashfs module..."
echo "Das squashfs Modul laden..."
sudo -H modprobe squashfs

echo "Mounting the .iso..."
echo "Das .iso mounten"
mkdir -p mnt
sudo -H mount -o loop $1 mnt

echo "Extracting contents of the iso except filesystem.squashfs to 'extract-cd'"
echo "Inhalt des .iso nach 'extract-cd' extrahieren (außer filesystem.squashfs)"
mkdir -p extract-cd
rsync --exclude=/casper/filesystem.squashfs -a mnt/ extract-cd 


echo "Extracting the squashfs contents to 'edit'"
echo "Das squashfs nach 'edit' entpacken"
sudo -H unsquashfs -f -d $CURDIR/edit mnt/casper/filesystem.squashfs 
sudo -H umount mnt
