
# Linux
Linux is a **free and open-source operating system** based on Unix. It was created by **Linus Torvalds** in 1991.
1. FREE      → You don't pay anything (Windows costs money)
2. OPEN SOURCE → Anyone can see and modify the code
3. SECURE    → Very hard to hack compared to Windows
4. STABLE    → Servers run for YEARS without restarting
5. FAST      → Works great even on old computers

#### UNIX
- UNIX is an operating system (like Linux, Windows)
- UNIX = a powerful, multi-user, multitasking operating system
- It is **Closed source** and **paid OS**.
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
- A shell is the program that lets you talk to the operating system using commands.
- ==A shell is a program that acts as an interface between you (the user) and the operating system’s kernel.==

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
RHEL = yum/dnf (file extension .dnf)
## Hidden Files

Files starting with . are hidden.
Example:
`.bashrc`
`.ssh/`

```bash
ls -la
```