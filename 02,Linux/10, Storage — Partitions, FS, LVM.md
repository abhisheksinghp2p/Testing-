

What is partition?
= Dividing disk into parts

What is filesystem?
= Structure to store files

What is mount?
= Attach disk to directory

What is fstab?
= Permanent mount config

What is LVM?
= Flexible storage system


# Linux Storage 

```
Disk → Partition → Filesystem → Mount → Use
```

Example:

```
/dev/sdb → /dev/sdb1 → xfs → /mnt/data → files stored
```

```
Physical Disks → Partitions → Filesystem → Mount Point
   /dev/sdb   →  /dev/sdb1  →   ext4     →  /mnt/data

With LVM (adds flexibility):
Physical Disks → PV → VG → LV → Filesystem → Mount Point
   /dev/sdb   →  PV → VG → LV →    xfs     →  /mnt/data
```
## Disk  = storage device

**Examples:**
- /dev/sda → main disk
- /dev/sdb → extra disk

**Check:**
```
lsblk
```

## Partition = a slice of disk

**One disk → divided into parts**

**Example:**
- /dev/sdb1
- /dev/sdb2



# Create Partition `fdisk`

#### Using fdisk (most common)
```
sudo fdisk /dev/sdb
```

**Then:**
- n → new partition
- w → save

**After this:**
```
lsblk

```

**You’ll see:**
```
sdb1
```

```
Modern fdisk commands:
┌─────────┬────────────────────────────────┐
│ Command │ What it does                   │
├─────────┼────────────────────────────────┤
│ m       │ Help menu                      │
│ p       │ Print partition table          │
│ n       │ New partition                  │
│ d       │ Delete partition               │
│ t       │ Change partition type          │
│ g       │ Create NEW GPT table           │
│ o       │ Create NEW MBR (dos) table     │
│ w       │ Write and exit                 │
│ q       │ Quit without saving            │
│ l       │ List known partition types     │
└─────────┴────────────────────────────────┘
```

# Filesystem

Create filesystem
==Without this → disk is unusable==

| Filesystem | Use                                         |
| ---------- | ------------------------------------------- |
| **XFS**    | Default in RHEL, fast, good for large files |
| **EXT4**   | Older, stable, widely used                  |


```
mkfs.xfs /dev/sdb1
```
**mkfs = Make File System**
- Before using a disk, you must format it (like formatting a USB drive).

**or**

```
mkfs.ext4 /dev/sdb1
```


# Mounting (Connecting storage)
Mount = attach storage to directory

#### Manual mount
```
mkdir /mnt/data
mount /dev/sdb1 /mnt/data
```

**Now you can use it:**
```
cd /mnt/data
touch file.txt
```

### Persistent Mount ==(/etc/fstab)==

Manual mount disappears after reboot ❌

#### Permanent mount

**Edit:**
```
nano /etc/fstab
```

**Add:**
```
/dev/sdb1   /mnt/data   xfs   defaults   0 0
```

**Apply:**
```
mount -a
```
Mount everything listed in /etc/fstab

_____________

# Practice 1: MBR Partitions on nvme or sda

**MBR = Master Boot Record**
MBR is a method that stores partition information in the first part of a disk.


```
MBR (Master Boot Record):
- OLD partitioning scheme (1983)
- Max disk size: 2 TB
- Max 4 primary partitions (or 3 primary + 1 extended)
- Extended partition can hold many logical partitions

Partition Table Layout:
┌─────────────────────────────────────────────┐
│  MBR (512 bytes)                            │
├───────────┬───────────┬───────────┬─────────┤
│ Primary 1 │ Primary 2 │ Primary 3 │Extended │
│ /dev/sdb1 │ /dev/sdb2 │ /dev/sdb3 │/dev/sdb4│
│           │           │           │┌───────┐│
│           │           │           ││Logic 5││
│           │           │           │├───────┤│
│           │           │           ││Logic 6││
│           │           │           │└───────┘│
└───────────┴───────────┴───────────┴─────────┘
```

##### Where is MBR located?
 At the very beginning of the disk

First 512 bytes of disk

**It contains:**

- Bootloader
- Partition table

```
fdisk /dev/nvme0n2
```

```
Command: n                        ← New partition
Select: p                        ← Primary
Partition number: 1               ← First partition
First sector: [press Enter]       ← Accept default (start)
Last sector: +1G                  ← 1 GB size

# Output: Created a new partition 1 of type 'Linux' and of size 1 GiB

w to save
```




## Part 2: GPT Partitions on nvme or sda


- It is the modern way to manage disk partitions.
- GPT is a partition table that allows large disks, many partitions, and better reliability.

```
GPT (GUID Partition Table):
- MODERN partitioning scheme
- Max disk size: 9.4 ZB (practically unlimited)
- Up to 128 partitions (no extended/logical needed!)
- Each partition gets a unique GUID (ID)
- Has backup partition table at end of disk (safer!)

GPT Layout:
┌──────────────────────────────────────────────────────────┐
│ Protective MBR │ GPT Header │ Partition Entries          │
├────────────────┼────────────┼────────────────────────────┤
│  Partition 1   │ Partition 2│ Partition 3 │ ... │ P 128  │
├────────────────┴────────────┴────────────────────────────┤
│ Backup Partition Entries │ Backup GPT Header              │
└──────────────────────────────────────────────────────────┘
```


####  Where is GPT stored?
Unlike MBR (only at start):

**GPT stores:**

- Primary table at beginning
- Backup table at end
```
[ Primary GPT | Partitions | Backup GPT ]
```


```
fdisk /dev/nvme0n3
```

```
Command: g                    ← Create GPT table (not 'o' for MBR!)
# Created a new GPT disklabel

Command: p
# Disklabel type: gpt         ← Confirmed GPT

# Create partition 1 (500MB)
Command: n
Partition number: 1 [Enter]
First sector: [Enter]
Last sector: +500M
# Note: fdisk may ask "Remove ext4 signature?" → Yes

# Create partition 2 (remaining, for LVM)
Command: n
Partition number: 2 [Enter]
First sector: [Enter]
Last sector: [Enter]           ← All remaining

# Change partition 2 type to LVM
Command: t
Partition number: 2
# In GPT mode, fdisk shows type list differently
Partition type or alias: 30    ← Linux LVM
# OR type: lvm                 ← Some versions accept alias

# If unsure of type number:
Command: l                     ← List all GPT types
# Look for "Linux LVM" — note its number

# Verify
Command: p
# Device           Start     End Sectors  Size Type
# /dev/nvme0n3p1    2048 1026047 1024000  500M Linux filesystem
# /dev/nvme0n3p2 1026048 2097118 1071071  523M Linux LVM

Command: w
```





# LVM 

**LVM = flexible storage system**

**Instead of fixed partitions:**
```
Disk → PV → VG → LV → Mount
```

| Term | Meaning          |
| ---- | ---------------- |
| PV   | Physical disk    |
| VG   | Pool of storage  |
| LV   | Usable partition |

### Basic LVM Steps
##### 1. Create PV
```
pvcreate /dev/sdb
```
**PV = Physical Volume**

**Means:**
"Convert this disk into LVM usable disk"

#### 2. Create VG
```
vgcreate myvg /dev/sdb
```
**VG = Volume Group**

**Means:**
"Create a storage pool using one or more disks"

**Example:**
- You have 1 disk → 10GB
- VG = pool of 10GB


#### 3. Create LV
```
lvcreate -L 1G -n mylv myvg
```
**LV = Logical Volume**

**Means:**
"Create a partition-like thing from VG"

**Example:**
- VG = 10GB
- LV = 5GB (like a partition)

#### 4. Format
```
mkfs.xfs /dev/myvg/mylv
```

#### 5. Mount
```
mount /dev/myvg/mylv /mnt/data
```

### Why LVM?
- Easy to extend storage
- Combine multiple disks
- Flexible resizing

### Basic commands
```
lsblk          # view disks
fdisk          # create partition
mkfs.xfs       # create filesystem
mount          # mount disk               
df -h          # check usage
free -h        # check memory/swap
```