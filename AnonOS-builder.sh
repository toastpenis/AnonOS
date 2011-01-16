#! /bin/bash
IMAGE_NAME="AnonOS `date`"
echo "Preparing to build AnonOS. This will probably require your sudo password. Make sure to not let it fuck with grub."
sudo chroot edit/ apt-get update	# Update the software in the chroot
sudo chroot edit/ apt-get upgrade -y	# Upgrade the software in the chroot
sudo chroot edit/ aptitude clean	# Clean up temporary files from aptitude
sudo chroot edit/ rm -rf /tmp/*		# Clean up other temporary files
sudo chroot edit/ rm /etc/resolv.conf	# Remove the networking capibilities of the chroot
sudo chroot edit/ umount /proc
sudo chroot edit/ umount /sys
sudo umount edit/dev

chmod +w extract-cd/casper/filesystem.manifest*
sudo chroot edit dpkg-query -W --showformat='${Package} ${Version}\n' > extract-cd/casper/filesystem.manifest
sudo cp extract-cd/casper/filesystem.manifest extract-cd/casper/filesystem.manifest-desktop
sudo sed -i '/ubiquity/d' extract-cd/casper/filesystem.manifest-desktop

sudo rm extract-cd/casper/filesystem.squashfs
echo "Preparing to squash the filesystem. This will probably take FOREVER:"
sudo mksquashfs edit extract-cd/casper/filesystem.squashfs

sudo nano extract-cd/README.diskdefines

rm -r extract-cd/dists extract-cd/pool

echo "Recalculating md5 checksums..."
sudo -s
rm extract-cd/md5sum.txt
(cd extract-cd && find . -not -name md5sum.txt -and -not -name boot.cat -and -not -name isolinux.bin -type f -print0 | xargs -0 md5sum > md5sum.txt)
exit

echo "Making the ISO"
cd extract-cd
sudo mkisofs -r -V "$IMAGE_NAME" -cache-inodes -J -l -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table -o "../AnonOS-`date`.iso" .
