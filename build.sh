sudo rm -f setup/boot/initramfs.cpio.gz simix.iso
sudo apt install build-essential grub-pc qemu-kvm xorriso mtools -y

if [ -d "rootfs" ]; then
    cd rootfs/ && mkdir -p {home,lib,lib64,proc,root,run,sys,tmp,var/cache,var/log,var/run,var/tmp,usr/bin,usr/sbin}
    find . | cpio -o -H newc | gzip > ../setup/boot/initramfs.cpio.gz && cd ..
else
    echo "rootfs file not found !!"
fi
grub-mkrescue -o simix.iso ./setup
qemu-system-x86_64 -cdrom simix.iso