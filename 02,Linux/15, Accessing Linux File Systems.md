#  Identify File Systems and Devices
## File System
File System = How data is organized on a disk.

Like organizing papers in folders in a filing cabinet.

#### Common File Systems
| File System | Used By              | Notes                       |
| :---------- | :------------------- | :-------------------------- |
| `ext4`      | Linux (default)      | Most common on Linux        |
| `ext3`      | Linux (older)        | Older Linux systems         |
| `xfs`       | Linux (RHEL default) | Good for large files        |
| `btrfs`     | Linux (modern)       | Advanced features           |
| `ntfs`      | Windows              | Windows drives              |
| `fat32`     | USB drives           | Universal, older            |
| `exfat`     | USB drives           | Large files, cross-platform |
| `iso9660`   | CD/DVD               | Optical discs               |
| `nfs`       | Network              | Linux network shares        |
| `cifs/smb`  | Network              | Windows shares              |


## Device
Device = Hardware component.

In Linux, everything is a file - including devices!

Devices are in /dev/ directory.

#### Device Naming

| Device           | Meaning                        |
| :--------------- | :----------------------------- |
| `/dev/sda`       | First hard disk (SATA/SCSI)    |
| `/dev/sdb`       | Second hard disk               |
| `/dev/sdc`       | Third hard disk (or USB)       |
| `/dev/sda1`      | First partition on first disk  |
| `/dev/sda2`      | Second partition on first disk |
| `/dev/nvme0n1`   | NVMe SSD drive                 |
| `/dev/nvme0n1p1` | First partition on NVMe        |
| `/dev/sr0`       | CD/DVD drive                   |
| `/dev/loop0`     | Loop device (mounted image)    |


---

# Mount and Unmount File Systems

## Mounting
Mounting = Connecting a file system to a directory.
```
USB Drive → Mount → /media/usb
                         ↓
                    Access files here
```

You can't access files on a disk until it's mounted!

### Mount Points
Mount point = Directory where file system is attached.

Common mount points:

| Mount Point | Purpose                   |
| :---------- | :------------------------ |
| `/`         | Root file system          |
| `/boot`     | Boot files                |
| `/home`     | User home directories     |
| `/mnt`      | Temporary mounts (manual) |
| `/media`    | Removable media (auto)    |
| `/tmp`      | Temporary files           |

## Mount a Device
**Basic syntax:**
```
sudo mount device mountpoint
```

**example:**
```
# Create mount point
sudo mkdir /mnt/usb

# Mount the device
sudo mount /dev/sdb1 /mnt/usb

# Access files
ls /mnt/usb
```

## Unmount a Device
**Basic syntax:**
```
sudo umount mountpoint
```

**example:**
```
sudo umount /mnt/usb
sudo umount /dev/sdb1
```