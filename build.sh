sudo apt install build-essential grub-pc qemu-kvm -y
cd rootfs/ && find . | cpio -o -H newc | gzip > ../setup/boot/initramfs.cpio.gz && cd ..
grub-mkrescue -o simix.iso ./setup
qemu-system-x86_64 -cdrom simix.iso
