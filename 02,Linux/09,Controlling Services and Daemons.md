# Service/Daemon



**Daemon=**	==A daemon is a background process that runs continuously and performs tasks without direct user interaction.==

**Examples:**
- sshd - SSH server (lets you connect remotely)
- httpd - Apache web server
- nginx - Nginx web server
- mysqld - MySQL database
- crond - Run Scheduled tasks
- firewalld - Firewall
Note: ==Many daemon names end with d (for daemon).==

**Service=**       Program that runs in background
==A service is a managed instance of a daemon, controlled by the system.==

#### Service vs Regular Process

| Feature        | Regular Process       | Service/Daemon       |
| :------------- | :-------------------- | :------------------- |
| **Startup**    | You start it          | Starts automatically |
| **Visibility** | Runs in foreground    | Runs in background   |
| **Lifespan**   | Stops when you logout | Keeps running        |
| **Terminal**   | Has a terminal (TTY)  | No terminal (`?`)    |



## Identify Automatically Started System Processes
### systemd?
systemd is the system manager in RHEL.

**It controls:**
- Starting/stopping services
- Boot process
- System logging
- And much more


#### List All Services

**All services:**
```
systemctl list-units --type=service
```


#### Difference: Start vs Enable
**Command**                	**What It Does**
___
`start`                      	Runs service now
`enable`	                        Runs service at boot
`stop`                         	Stops service now
`disable`	                        Prevents starting at boot

___ 
**Enable** (start automatically at boot)
```
sudo systemctl enable ssh
```

**Disable** (do not start at boot)
```
sudo systemctl disable ssh
```

# Control System Services
