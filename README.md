# Simix

A minimal bootable **x86_64 Linux environment** built with a custom root filesystem, GRUB boot setup, initramfs generation, and QEMU execution.

Simix is a small learning project for understanding how a Linux-based system boots: from bootloader configuration, to kernel loading, to initramfs creation, to starting a minimal user-space environment.

---

## Overview

Simix builds a bootable ISO image from:

```text
custom rootfs → initramfs.cpio.gz → GRUB boot image → simix.iso → QEMU
```

The project is useful for experimenting with:

- Linux boot process
- initramfs generation
- minimal root filesystem design
- GRUB boot configuration
- x86_64 system booting
- QEMU-based OS testing

---

## Features

- Minimal custom Linux root filesystem
- GRUB-based boot setup
- Initramfs generation with `cpio` and `gzip`
- Bootable ISO creation with `grub-mkrescue`
- QEMU support for testing
- Simple shell-based build script
- x86_64 architecture target

---

## Project Structure

```text
Simix/
├── rootfs/                 # Minimal root filesystem
│   ├── bin/
│   ├── etc/
│   ├── sbin/
│   ├── usr/
│   └── init                # Early userspace init script
├── setup/
│   └── boot/
│       ├── grub/           # GRUB configuration
│       └── simix-kernel    # Kernel image
├── build.sh                # Build and run script
└── README.md
```

---

## Requirements

Simix is intended to be built on a Linux system.

Install the required packages:

```bash
sudo apt update
sudo apt install build-essential grub-pc qemu-kvm xorriso mtools -y
```

Required tools:

| Tool | Purpose |
|---|---|
| `cpio` | Create initramfs archive |
| `gzip` | Compress initramfs |
| `grub-mkrescue` | Build bootable ISO |
| `qemu-system-x86_64` | Run the ISO in a virtual machine |
| `xorriso` | ISO image generation backend |
| `mtools` | GRUB ISO build support |

---

## Build and Run

Run:

```bash
bash build.sh
```

The script will:

1. Remove old build outputs
2. Create required rootfs directories
3. Pack `rootfs/` into `initramfs.cpio.gz`
4. Build `simix.iso`
5. Boot the ISO using QEMU

Generated files:

```text
setup/boot/initramfs.cpio.gz
simix.iso
```

---

## Boot Flow

The boot process is:

```text
QEMU
  ↓
GRUB
  ↓
simix-kernel
  ↓
initramfs.cpio.gz
  ↓
rootfs/init
  ↓
/sbin/init
```

The `rootfs/init` script prepares the early user-space environment by mounting important virtual filesystems:

```sh
mount -t proc none /proc
mount -t sysfs none /sys
mount -t devtmpfs none /dev
```

Then it starts the system init process:

```sh
exec sbin/init
```

---

## Root Filesystem

The `rootfs/` directory represents the minimal filesystem that will be packed into the initramfs.

Important directories:

```text
rootfs/
├── bin/       # Essential binaries
├── etc/       # Configuration files
├── sbin/      # System binaries
├── usr/       # User-space programs
└── init       # Early boot init script
```

During build, additional standard directories are created automatically, such as:

```text
home/
lib/
lib64/
proc/
root/
run/
sys/
tmp/
var/
usr/bin/
usr/sbin/
```

---

## GRUB Configuration

The GRUB configuration is located at:

```text
setup/boot/grub/grub.cfg
```

It loads:

```text
/boot/simix-kernel
/boot/initramfs.cpio.gz
```

and creates a boot menu entry for Simix.

---

## Default User

The init script creates a default demo user:

```text
username: mahdi
password: mahdi
```

For real usage, change this before publishing or distributing an image.

---
