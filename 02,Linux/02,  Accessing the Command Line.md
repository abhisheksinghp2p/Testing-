
#  Command Line
The command line (also called terminal, console, or shell) is a text-based interface to interact with the Linux operating system. Instead of clicking icons, you type commands.

- Faster than GUI for repetitive tasks
- Can be scripted and automated
- Works over remote connections (SSH)
- Many security tools are CLI-only
- Less resource intensive
- Available on all Linux systems including servers


## Accessing the Command Line

### 1. Physical Console
- Direct keyboard and monitor connection
- Used for server rooms and local access
- Login prompt appears after boot

### 2. Virtual Consoles (TTY)
- RHEL provides multiple virtual consoles
- Switch between them using keyboard shortcuts
- Ctrl + Alt + F1 to F6 for text consoles
- Ctrl + Alt + F1 or F2 usually returns to GUI (if installed)

**TTY originally means Teletypewriter (old physical terminals).**

**TTY usually refers to:**
- physical console
- virtual console like Ctrl+Alt+F1

**Examples:**
- /dev/tty1
- /dev/tty2
### 3. Terminal Emulator (GUI)
- Application within desktop environment
- GNOME Terminal is default in RHEL
- Access via Applications menu or right-click desktop


### **PTY (Pseudo Terminal)**
Used when you open terminals inside GUI or SSH sessions.

**Examples:**
/dev/pts/0
/dev/pts/1
### 4. Remote Access (SSH)
- Secure Shell protocol
- Access from another machine over network
- Most common method for servers
- Command: ssh username@hostname


#### After login, you see the shell prompt:
```
[user@hostname ~]$
```

| Part       | Meaning                            |
| :--------- | :--------------------------------- |
| `user`     | Current username                   |
| `@`        | Separator                          |
| `hostname` | System name                        |
| `~`        | Current directory (`~` means home) |
| `$`        | Regular user prompt                |
| `#`        | **Root** user prompt               |

```
[john@server1 ~]$        # Regular user john in home directory
[root@server1 /etc]#     # Root user in /etc directory
[admin@webserver logs]$  # User admin in logs directory
```

---

#  Execute Commands with the Bash Shell
Bash (Bourne Again Shell) is the default shell in RHEL. 
- Interprets and executes commands
- Provides scripting capabilities
- Maintains command history
- Supports tab completion
- Allows command chaining and redirection


#### Basic Command Structure
```
command [options] [arguments]
```

| Component     | Description                              | Example        |
| :------------ | :--------------------------------------- | :------------- |
| **Command**   | The program to run                       | `ls`           |
| **Options**   | Modify behavior (start with `-` or `--`) | `-l`, `--help` |
| **Arguments** | What the command acts on                 | `/etc`         |

```
ls                      # Command only
ls -l                   # Command + option
ls /etc                 # Command + argument
ls -la /etc             # Command + options + argument
```

## Essential Commands 
#### 1. Navigation Commands

| Command | Purpose                 | Example       |
| :------ | :---------------------- | :------------ |
| **pwd** | Print working directory | `pwd`         |
| **cd**  | Change directory        | `cd /var/log` |
| **ls**  | List directory contents | `ls -la`      |
#### cd shortcut
```
cd          # Go to home directory
cd ~        # Go to home directory
cd -        # Go to previous directory
cd ..       # Go up one directory
cd ../..    # Go up two directories
```

#### System Information Commands

| Command               | Purpose            |
| :-------------------- | :----------------- |
| `whoami`              | Current username   |
| `id`                  | User and group IDs |
| `hostname`            | System name        |
| `uname -a`            | Kernel info        |
| `cat /etc/os-release` | OS version         |

#### User Information Commands

| Command | Purpose                | VAPT Use             |
| :------ | :--------------------- | :------------------- |
| `who`   | Logged in users        | See active sessions  |
| `w`     | Detailed user activity | Monitor user actions |
| `last`  | Login history          | Investigate access   |
| `users` | List logged in users   | Quick user check     |
#### Command History

| Action                | Method                   |
| :-------------------- | :----------------------- |
| View history          | `history`                |
| Run last command      | `!!`                     |
| Run command by number | `!42`                    |
| Search history        | `Ctrl` + `R` (then type) |
| Clear history         | `history -c`             |


==~/.bash_history==:
sensitive information like passwords, commands, and accessed files.

### Running Multiple Commands
#### Sequential Execution (;)

Run commands one after another regardless of success:
```
cd /tmp; ls; pwd
```

#### Conditional AND (&&)

Run next command only if previous succeeds:
```
cd /etc && cat passwd
```

#### Conditional OR (||)

Run next command only if previous fails
```
cd /nonexistent || echo "Directory not found"
```


### Getting Help
| Method     | Usage                | Example        |
| :--------- | :------------------- | :------------- |
| **--help** | Quick help           | `ls --help`    |
| **man**    | Full manual          | `man ls`       |
| **info**   | Detailed info        | `info ls`      |
| **whatis** | One-line description | `whatis ls`    |
| **which**  | Command location     | `which python` |
| **type**   | Command type         | `type cd`      |

## cyber
#### System Enumeration:
```
uname -a                    # Kernel version
cat /etc/os-release         # OS details
cat /proc/version           # Kernel and compiler info
hostname                    # System name
hostnamectl                 # Detailed host info
```

#### User Enumeration:
```
whoami                      # Current user
id                          # User ID and groups
cat /etc/passwd             # All users
cat /etc/group              # All groups
cat /etc/shadow             # Password hashes (needs root)
```

#### Network Enumeration:
```
ip a                        # Network interfaces
ip route                    # Routing table
cat /etc/resolv.conf        # DNS servers
ss -tulnp                   # Open ports
```