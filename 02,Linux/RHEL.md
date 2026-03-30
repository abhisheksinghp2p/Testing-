---
tags: [RHEL, Linux, study-plan, 2-week, checklist]
created: 2025-01-01
status: in-progress
---

# 🐧 RHEL 2-Week Study Plan Checklist

---

## 🗓️ WEEK 1: Foundations & Core Skills

---

### 📅 Day 1: Setup & Linux Basics

- [x] Install RHEL 9 on VM (VirtualBox/KVM)
- [x] Register with developer subscription
- [x] Explore the desktop & terminal
- [x] Practice: `ls`, `cd`, `pwd`, `mkdir`, `cp`, `mv`, `rm`, `touch`
- [x] Practice: `cat`, `less`, `head`, `tail`, `wc`, `grep`
- [x] Understand FHS — navigate every major directory
- [x] Practice: I/O redirection (`>`, `>>`, `|`, `2>`, `&>`, `tee`)
- [x] Practice: `find` and `locate` with various options
- [x] Read `man` pages for 5 commands

> [!done] Day 1 Goal
> Comfortable navigating filesystem and using 20+ basic commands.

---

### 📅 Day 2: Users, Groups & Permissions

- [x] Study `/etc/passwd`, `/etc/shadow`, `/etc/group`
- [x] Create 5 users with various options (`useradd`)
- [x] Create 3 groups, assign users to groups
- [ ] Practice `passwd`, `chage`, `usermod`, `userdel`
- [x] Understand permission bits (`rwx`, numeric)
- [ ] Practice `chmod` (both numeric and symbolic)
- [x] Practice `chown`, `chgrp`
- [ ] Set up SUID, SGID, and Sticky bit — test each
- [ ] Practice ACLs: `setfacl`, `getfacl`
- [x] Understand and modify `umask`
- [ ] Lab: Create shared directory for a team with SGID

> [!done] Day 2 Goal
> Can manage users/groups and set complex permissions confidently.

---

### 📅 Day 3: SSH, Software Management & Vi/Vim

- [ ] Master `vi`/`vim` — practice modes and commands
  - [ ] Insert, Command, Visual, Ex modes
  - [ ] `dd`, `yy`, `p`, `u`, `/`, `:wq`, `:q!`, `:%s/old/new/g`
  - [ ] `set number`, cursor movement, copy/paste blocks
- [ ] Set up SSH key-based authentication between 2 VMs
- [ ] Configure `/etc/ssh/sshd_config` (disable root login)
- [ ] Practice RPM commands (`rpm -qa`, `-qi`, `-ql`, `-qf`, `-V`)
- [ ] Configure a local repo from ISO
- [ ] Practice DNF: `install`, `remove`, `search`, `update`, `history`
- [ ] Install and explore `dnf module` commands

> [!done] Day 3 Goal
> Efficient in vim, can manage packages and repos.

---

### 📅 Day 4: Processes, Services & Systemd

- [ ] Practice `ps aux`, `ps -ef`, `top`, `pgrep`, `pkill`
- [ ] Run background jobs (`&`, `jobs`, `fg`, `bg`, `nohup`)
- [ ] Practice signals (`kill -9`, `kill -15`, `kill -1`)
- [ ] Understand nice values; practice `nice` and `renice`
- [ ] Master `systemctl` — start/stop/enable/disable/mask
- [ ] Understand systemd targets, switch between them
- [ ] Check and make `journald` persistent
- [ ] Practice `journalctl` with filters
- [ ] Create a custom systemd service unit file
- [ ] Lab: Write a script, create a service for it, enable at boot

> [!done] Day 4 Goal
> Can manage any process/service and troubleshoot with logs.

---

### 📅 Day 5: Storage — Partitions, FS, LVM

- [ ] Add 3 virtual disks to your VM
- [ ] Practice `fdisk` — create MBR partitions
- [ ] Practice `gdisk` — create GPT partitions
- [ ] Create XFS and ext4 filesystems
- [ ] Mount manually and persist in `/etc/fstab`
- [ ] Create and activate swap partition and swap file
- [ ] LVM Deep Dive:
  - [ ] Create PV → VG → LV
  - [ ] Format and mount LV
  - [ ] Extend VG (add PV)
  - [ ] Extend LV + resize filesystem
  - [ ] Practice `pvs`, `vgs`, `lvs`, `pvdisplay`, `vgdisplay`, `lvdisplay`
- [ ] Lab: Create LVM setup, extend it, add to fstab

> [!done] Day 5 Goal
> Can partition disks, create LVM, and manage filesystems.

---

### 📅 Day 6: Networking & Firewall

- [ ] Examine current network with `ip a`, `ip r`, `ss`
- [ ] Set hostname with `hostnamectl`
- [ ] Configure static IP using `nmcli`
- [ ] Practice `nmcli` connection add/modify/up/down/delete
- [ ] Use `nmtui` for quick network config
- [ ] Configure DNS in `/etc/hosts` and via `nmcli`
- [ ] Troubleshoot: `ping`, `traceroute`, `dig`, `curl`
- [ ] Firewalld:
  - [ ] Add/remove services and ports
  - [ ] Practice zones
  - [ ] Add rich rules
  - [ ] Make changes permanent + reload
- [ ] Lab: Configure static IP, open HTTP/HTTPS, block specific IP

> [!done] Day 6 Goal
> Can configure networking and firewalls from scratch.

---

### 📅 Day 7: SELinux + Week 1 Review

- [ ] Understand SELinux modes and check status
- [ ] Practice `setenforce`, edit `/etc/selinux/config`
- [ ] View contexts with `ls -Z` and `ps -eZ`
- [ ] Change file contexts with `chcon` and `restorecon`
- [ ] Set permanent contexts with `semanage fcontext`
- [ ] Practice SELinux booleans
- [ ] Add custom port with `semanage port`
- [ ] Troubleshoot SELinux denials with `sealert`, `ausearch`
- [ ] Lab: Set up Apache on non-standard port with correct SELinux
- [ ] 🔄 Week 1 Review:
  - [ ] Redo 5 challenging tasks from the week
  - [ ] Create flashcards for key commands
  - [ ] Take practice quiz

> [!done] Day 7 Goal
> SELinux is no longer scary. Week 1 fundamentals solid.

---

## 🗓️ WEEK 2: Advanced Topics & Exam Prep

---

### 📅 Day 8: Scheduling, Logging & Time

- [ ] Practice `crontab -e` — create 5 different cron jobs
- [ ] Understand cron special strings (`@reboot`, `@hourly`)
- [ ] Practice `at` for one-time scheduling
- [ ] Configure `rsyslog` basics (`/etc/rsyslog.conf`)
- [ ] Navigate and analyze `/var/log/` files
  - [ ] `messages`
  - [ ] `secure`
  - [ ] `boot.log`
  - [ ] `audit/audit.log`
- [ ] Advanced `journalctl` filtering
- [ ] Configure time sync:
  - [ ] `timedatectl`
  - [ ] `timedatectl set-timezone Asia/Kolkata`
  - [ ] `timedatectl set-ntp true`
  - [ ] `chronyc sources`
  - [ ] `/etc/chrony.conf`
- [ ] Lab: Schedule backup script with cron, verify in logs

> [!done] Day 8 Goal
> Can schedule tasks and analyze system logs effectively.

---

### 📅 Day 9: Boot Process & Troubleshooting

- [ ] Study the full boot sequence (BIOS → GRUB → kernel → systemd)
- [ ] Examine GRUB config files
- [ ] Modify kernel parameters in GRUB temporarily
- [ ] Practice root password reset 3 times (critical!)
- [ ] Boot into emergency and rescue targets
- [ ] Practice fixing broken `/etc/fstab` entries
- [ ] Rebuild initramfs: `dracut -f`
- [ ] Regenerate GRUB config
- [ ] Lab: Break fstab intentionally, then fix from rescue mode

> [!done] Day 9 Goal
> Can troubleshoot any boot issue and reset root password.

---

### 📅 Day 10: NFS, Autofs & Advanced Storage

- [ ] Set up NFS server on VM1
- [ ] Mount NFS share on VM2 (manual + fstab)
- [ ] Configure Autofs for NFS auto-mounting
- [ ] Practice Stratis:
  - [ ] Create pool
  - [ ] Create filesystem
  - [ ] Create snapshot
- [ ] Practice VDO:
  - [ ] Create VDO volume
  - [ ] Check dedup stats
- [ ] Lab: NFS server sharing `/data`, client auto-mounts via Autofs

> [!done] Day 10 Goal
> Can set up network storage and use advanced storage tools.

---

### 📅 Day 11: Containers (Podman)

- [ ] Install Podman, explore commands
- [ ] Pull and run containers from registry
- [ ] Practice: `run`, `stop`, `start`, `rm`, `exec`, `logs`, `inspect`
- [ ] Map ports: `-p 8080:80`
- [ ] Mount volumes: `-v /host:/container:Z`
- [ ] Run rootless containers as normal user
- [ ] Generate and enable systemd service for container
- [ ] Enable linger for rootless persistent containers
- [ ] Lab: Run web server container, persist data, auto-start at boot

> [!done] Day 11 Goal
> Can deploy and manage containers with Podman confidently.

---

### 📅 Day 12: Shell Scripting & Automation

- [ ] Write script: create multiple users from a file
- [ ] Write script: backup with timestamp + rotation
- [ ] Write script: system health check (CPU, memory, disk)
- [ ] Practice: variables, conditionals, loops, functions
- [ ] Practice: `$?`, `$1`, `$#`, `$@`, `$0`
- [ ] Use `test` / `[ ]` conditions
- [ ] Error handling with `set -e`, `trap`
- [ ] Make scripts executable, add to cron
- [ ] Lab: Complete automation script that:
  - [ ] Creates users
  - [ ] Sets passwords
  - [ ] Configures SSH keys
  - [ ] Sets permissions

> [!done] Day 12 Goal
> Can write practical bash scripts for system administration.

---

### 📅 Day 13: Full Practice Exam Simulation

- [ ] Set up 2 fresh VMs
- [ ] Complete these tasks under time pressure (3.5 hours):
  - [ ] Configure hostname, networking, static IP
  - [ ] Create users/groups with specific requirements
  - [ ] Set up LVM with specific sizes
  - [ ] Configure permissions with ACLs
  - [ ] Set up cron jobs
  - [ ] Configure SSH key authentication
  - [ ] Install and configure Apache
  - [ ] Configure SELinux for custom web directory
  - [ ] Set up firewall rules
  - [ ] Configure NFS + Autofs
  - [ ] Reset root password
  - [ ] Run a Podman container with systemd integration
  - [ ] Configure persistent journal
  - [ ] Add swap space
  - [ ] Extend existing LV
  - [ ] Write a scheduled backup script

> [!done] Day 13 Goal
> Complete mock exam with 80%+ tasks done correctly.

---

### 📅 Day 14: Review, Weak Areas & Final Prep

- [ ] Review notes and flashcards
- [ ] Redo any failed tasks from Day 13
- [ ] Focus on weak areas identified during mock exam
- [ ] Review all key config file locations:
  - [ ] `/etc/fstab`
  - [ ] `/etc/hosts`
  - [ ] `/etc/hostname`
  - [ ] `/etc/selinux/config`
  - [ ] `/etc/ssh/sshd_config`
  - [ ] `/etc/exports`
  - [ ] `/etc/auto.master`
  - [ ] `/etc/crontab`
  - [ ] `/etc/default/grub`
  - [ ] `/etc/yum.repos.d/`
  - [ ] `/etc/passwd`, `/etc/shadow`, `/etc/group`
  - [ ] `/etc/login.defs`
- [ ] Speed-run common tasks:
  - [ ] User creation → 1 minute
  - [ ] LVM setup → 5 minutes
  - [ ] Firewall rules → 2 minutes
  - [ ] SELinux context fix → 3 minutes
  - [ ] Root password reset → 5 minutes
- [ ] Create personal cheat sheet of commands
- [ ] Rest well — confidence is key! 💪

> [!done] Day 14 Goal
> Fully prepared. All topics reviewed. Ready for real-world or exam.

---

## 📊 Progress Tracker

| Day       | Topic                       | Tasks    | Done  | Status |
| --------- | --------------------------- | -------- | ----- | ------ |
| 1         | Setup & Linux Basics        | 9        | 0     | ⬜      |
| 2         | Users, Groups & Permissions | 11       | 0     | ⬜      |
| 3         | SSH, Software & Vim         | 10       | 0     | ⬜      |
| 4         | Processes & Systemd         | 10       | 0     | ⬜      |
| 5         | Storage & LVM               | 12       | 0     | ⬜      |
| 6         | Networking & Firewall       | 13       | 0     | ⬜      |
| 7         | SELinux + Review            | 12       | 0     | ⬜      |
| 8         | Scheduling & Logging        | 12       | 0     | ⬜      |
| 9         | Boot & Troubleshooting      | 9        | 0     | ⬜      |
| 10        | NFS, Autofs & Storage       | 8        | 0     | ⬜      |
| 11        | Containers (Podman)         | 9        | 0     | ⬜      |
| 12        | Shell Scripting             | 12       | 0     | ⬜      |
| 13        | Practice Exam               | 17       | 0     | ⬜      |
| 14        | Final Review                | 22       | 0     | ⬜      |
| **TOTAL** |                             | **~166** | **0** | **0%** |

> [!tip] Status Key
> ⬜ Not Started | 🟡 In Progress | ✅ Completed

---


---

#RHEL #Linux #RHCSA #study-plan #2-week #checklist