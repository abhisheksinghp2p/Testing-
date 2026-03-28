
# Linux
Linux is a **free and open-source operating system** based on Unix. It was created by **Linus Torvalds** in 1991.
1. FREE      → You don't pay anything (Windows costs money)
2. OPEN SOURCE → Anyone can see and modify the code
3. SECURE    → Very hard to hack compared to Windows
4. STABLE    → Servers run for YEARS without restarting
5. FAST      → Works great even on old computers
## Key Components of Linux

### The Linux Architecture
```
┌─────────────────────────────────────┐
│         User Applications           │  Layer 4
├─────────────────────────────────────┤
│            Shell/CLI                │  Layer 3
├─────────────────────────────────────┤
│         System Libraries            │  Layer 2
├─────────────────────────────────────┤
│          Linux Kernel               │  Layer 1
├─────────────────────────────────────┤
│           Hardware                  │  Layer 0
└─────────────────────────────────────┘
```

```
┌──────────────────────────────────────────────────────────┐
│  User Applications (Layer 4)                             │
│  Examples:                                               │
│   • Firefox, Chrome                                      │
│   • VS Code                                              │
│   • Nmap, Wireshark                                      │
│   • Python apps, Docker, PostgreSQL                      │
├──────────────────────────────────────────────────────────┤
│  Shell / CLI (Layer 3)                                   │
│  Examples:                                               │
│   • bash, zsh, fish                                      │
│   • Commands: ls, cd, grep, chmod, ssh, curl             │
│   • Scripts: .sh files                                   │
├──────────────────────────────────────────────────────────┤
│  System Libraries (Layer 2)                              │
│  Examples:                                               │
│   • glibc (GNU C library)                                │
│   • OpenSSL (crypto/TLS)                                 │
│   • libpthread (threads)                                 │
│   • libpcap (packet capture)                             │
├──────────────────────────────────────────────────────────┤
│  Linux Kernel (Layer 1)                                  │
│  Examples:                                               │
│   • Process scheduling (runs programs)                   │
│   • Memory management (RAM, paging)                      │
│   • Networking stack (TCP/IP)                            │
│   • Filesystems (ext4, btrfs)                            │
│   • Drivers (Wi-Fi, GPU, USB)                            │
├──────────────────────────────────────────────────────────┤
│  Hardware (Layer 0)                                      │
│  Examples:                                               │
│   • CPU, RAM, SSD/HDD                                    │
│   • Network card (NIC)                                   │
│   • GPU, keyboard, mouse                                 │
└──────────────────────────────────────────────────────────┘

```
### 1. Kernel
The Kernel is the CORE (heart) of the Operating System. It is the part that directly talks to your hardware.

**The kernel manages:**
- **Process Management:** Scheduling, creation, termination
- **Memory Management:** RAM allocation, virtual memory
- **Device Drivers:** Hardware communication
- **System Calls:** Interface for applications
- **Security:** Access controls, permissions
  
```bash
  # Multiple ways to check kernel
uname -r                    # Kernel release
uname -a                    # All system info
```

### 2. Shell
A shell is the program that lets you talk to the operating system using commands.

**It’s basically a command interpreter:**
```bash
ls
```
The shell understands it, and tells the OS:
- “Hey, list the files in this folder.”
- Then it prints the result back to you.

**Uses:**
- Command-line interface for interacting with the system
- Interprets and executes user commands
- Bash (Bourne Again Shell) is the default in RHEL
- Enables powerful scripting and automation

**Common Shells:**

| Shell    | Path        | Description        | VAPT Use           |
| :------- | :---------- | :----------------- | :----------------- |
| **Bash** | `/bin/bash` | Default RHEL shell | Scripting exploits |
| **Sh**   | `/bin/sh`   | POSIX shell        | Reverse shells     |
| **Zsh**  | `/bin/zsh`  | Enhanced shell     | Advanced features  |
| **Dash** | `/bin/dash` | Debian shell       | Minimal shells     |
```bash
# Check available shells
cat /etc/shells

# Current shell
echo $SHELL
echo $0
```



_____

# 3. File System
A filesystem is how Linux stores and organizes data on disk (SSD/HDD/USB).

**It controls:**
- folders + files structure
- file permissions (read/write/execute)
- where system files live
- how devices get mounted

# / (root)
The top of everything. Every folder starts from here.

- Hierarchical structure starting from / (root)
- Everything in Linux is treated as a file
- Directories, devices, sockets, processes are all files
- Case-sensitive naming

```
cd /
ls
```

```
bin  boot  dev  etc  home  root  tmp  usr  var
```


## 1) /home
Where user files live.
This is where normal users keep their personal files.

**Example:**
- /home/username/Documents
- /home/username/Downloads

## 2) /root
Home folder for the root user (admin).
A private Folder For Admin.

==where / = Its a directory(folder storing file)==
example:  **/root/etc** 
Linux use **Absolute path** that's why it use (/) in every directory 

## 3) ==/etc==
It store **System configuration files**.
**/etc** is the folder where Linux keeps its settings and rules.

**It stores configuration files that tell the system:**

- Who can log in
- What password rules to use
- How network works
- Which services should start
- Who has admin (sudo) access

**So basically:**
 /etc = Linux control center for system settings
 
**Examples:**
- /etc/passwd      (user account Info)
- /etc/ssh/sshd_config     (ssh server config)
- /etc/hosts     (local host mapping)

## 4) /bin and /usr/bin
- Essential commands and programs needed by User and System
- Essential user binaries

#### ==**/bin**== → Contains basic system commands needed for Linux to run.
**Examples:**
- ls
- cat
- bash
- python3

#### ==**/usr/bin**== → Contains most of the user-level programs and applications.

**Examples:**
- nmap
- curl
- wget
- python

## 5) /sbin and /usr/sbin
Contain important system **Admin**/system commands.

##### ==**/sbin**== → Contains important system administration commands.
Contains essential system management commands needed for booting and repairing the system.

**Examples:**
- reboot
- shutdown
- fdisk
- fsck
- iptables

#### ==/usr/sbin== -> Contains more advanced admin and service-related programs.

**Contains:**
- Service management tools
- Network service binaries
- Server-related programs

**Examples:**
- sshd
- apache2
- nginx
- useradd
- adduser


## ==***6) /var  (is the folder where Linux stores changing data.)***==
“Variable” data (logs, cache, changing stuff)

**Examples:**
- /var/log/auth.log
- /var/log/syslog

#### ==**/var/log**==
**Common log files:**
- /var/log/auth.log → Login attempts (Debian/Ubuntu)
- /var/log/secure → Login logs (RHEL/CentOS)
- /var/log/syslog → General system logs
- /var/log/messages → System messages
- /var/log/apache2/ → Web server logs
- /var/log/nginx/ → Web server logs

#### **/var/lib**
- Application state data
- Databases
- Package information

#### **/var/cache**
Cached files from applications


## 7) /tmp
Temporary files (often cleared on reboot)/Often writable
==every user can work in this directory==

#### ==**/var/tmp**==
- Temporary files
- Similar to /tmp
- Files may persist after reboot ==(the file will still be there even after you restart the system.)==


## 8) /dev
Devices treated like files / Device files

**Examples:**
- /dev/sda (disk)
- /dev/null
- /dev/tty

### /mnt 
- Used as a temporary mount point.
- Admins often mount disks here manually.

**Example:**
```Bash
mount /dev/sdb1 /mnt
```

### /media
Where drives get mounted (USB, external disks)
Used for removable media **Automatically**

**Examples:**

- USB drives
- DVD/CD



## 9) /boot
This contains files needed to start Linux.

**Examples:**

- kernel files
- initramfs
- bootloader-related files

Without this, **system booting is affected.**


## 10) /proc
Virtual filesystem showing running system info.
It Does not store normal files like Document.

**It gives info about:-**
- Running process
- Kernel
- Memory
- CPU

**Examples:**
```
cat /proc/cpuinfo
cat /proc/meminfo
```

## 11) /opt 
Used for **optional** or **third party software**.

If you install Some extra Application manually, it may go here.

## 12) /run
- Stores runtime info 
- current running system data 


```bash
/                   # Root directory
├── /bin           # Essential user binaries
├── /boot          # Boot loader files
├── /dev           # Device files
├── /etc           # System configuration file ⚠️ 
├── /home          # User home directories
├── /lib           # Essential libraries
├── /media         # Removable media mount points
├── /mnt           # Temporary mount points
├── /opt           # Optional software
├── /proc          # Process information (virtual)
├── /root          # Root user home
├── /sbin          # System binaries
├── /srv           # Service data
├── /sys           # Kernel and system info (virtual)
├── /tmp           # Temporary files ⚠️ Often writable
├── /usr           # User programs
├── /var           # Variable data (logs, mail, etc.)
```



### 4. Userspace
- All applications and utilities running outside kernel
- Includes system tools, libraries, and user programs


## What is a Distribution (Distro)

A Linux Distribution (distro) = Linux Kernel + GNU Tools + Package Manager + Desktop Environment + Pre-configured Software

A Linux distribution is a complete operating system built around the Linux kernel with:
- Package management system
- Default applications
- Desktop environment (optional)
- Configuration tools

```
Linux Distributions Family Tree
================================
         Debian Based                 RHEL Based               Others
         ────────────                 ──────────               ──────
         │                            │                        │
    ┌────┴────┐                  ┌────┴────┐            ┌─────┴─────┐
    │ Debian  │                  │  RHEL   │            │ Arch Linux│
    └────┬────┘                  └────┬────┘            └───────────┘
         │                            │                        │
    ┌────┴────┐                  ┌────┴────┐            ┌─────┴─────┐
    │ Ubuntu  │                  │ CentOS  │            │ Slackware │
    └────┬────┘                  └─────────┘            └───────────┘
         │                            │                        │
    ┌────┴────┐                  ┌────┴────┐            ┌─────┴─────┐
    │  Kali   │                  │ Fedora  │            │  Gentoo   │
    └─────────┘                  └─────────┘            └───────────┘
```

| Distro            | Base        | Use Case              |
| :---------------- | :---------- | :-------------------- |
| **RHEL**          | Independent | Enterprise servers    |
| **CentOS Stream** | RHEL        | Development/Testing   |
| **Rocky Linux**   | RHEL        | Free RHEL alternative |
| **Ubuntu**        | Debian      | Desktops/Servers      |
| **Kali Linux**    | Debian      | Penetration Testing   |
| **Fedora**        | Independent | Cutting-edge features |

**Package manager:**
Debian/Ubuntu= apt (file extension .deb)
RHEL = yum/dnf
## Hidden Files

Files starting with . are hidden.
Example:
`.bashrc`
`.ssh/`

```bash
ls -la
```