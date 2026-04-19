
#  Command Line
The command line is a text-based interface to interact with the Linux operating system. Instead of clicking icons, you type commands.



==The command line is the interface inside the terminal where you type commands.==
- Shows a prompt ($, #)
- Accepts text input
- Displays output

- Faster than GUI for repetitive tasks
- Can be scripted and automated
- Works over remote connections (SSH)
- Many security tools are CLI-only
- Less resource intensive
- Available on all Linux systems including servers

## Terminal 
==A terminal is an application that gives you access to a text-based interface.==

- It’s a program/window (like GNOME Terminal or Konsole)
- It emulates old physical terminals
- It lets you interact with the system via a shell



## Console

==A console is a direct system interface, often tied to the machine itself.==

- Originally: physical keyboard + monitor
- In Linux: refers to virtual consoles (e.g., accessed with Ctrl + Alt + F3)
- Works without a graphical environment

### 1. Virtual Consoles (TTYs)
- Also called **TTY terminals**
- Accessed using keyboard shortcuts like:
- `Ctrl + Alt + F1` → `Ctrl + Alt + F6`
- Each opens a separate text-based login session
- Managed by the Linux kernel directly

**Example:**
You might log into one console as root and another as a normal user


**TTY originally means Teletypewriter (old physical terminals).**

**TTY usually refers to:**
- physical console
- virtual console like Ctrl+Alt+F1

**Examples:**
- /dev/tty1
- /dev/tty2

### 2. Terminal Emulator (GUI Console)
- A graphical application that behaves like a console
- Runs inside a desktop environment like GNOME or KDE Plasma

**Popular terminal emulators:**
- GNOME Terminal
- Konsole
- xterm


### 3. Serial Console
Used for low-level system access via serial ports (RS-232, USB serial)

**Common in:**
- Servers
- Embedded systems
- Network devices (**Router**)

**Useful when:**
No monitor or keyboard is attached


### 4. System/Kernel/Physical Console

The primary console used by the Linux kernel

**Displays:**
- Boot messages
- Kernel logs
- Usually mapped to the first ==**TTY (like /dev/tty1)**==

- Direct keyboard and monitor connection
- Used for server rooms and local access
- Login prompt appears after boot

### 5. Pseudo Terminals (PTY)
Used when you open terminals inside **GUI** or **SSH** sessions.
Virtual terminals created by software

**Used by:**
- SSH sessions
- Terminal multiplexers like tmux and GNU Screen

**Example:**
When you connect using SSH, you’re using a PTY

**Examples:**
/dev/pts/0
/dev/pts/1
### 6. Remote Console
Accessing a system from another machine over network

**Common tools:**
- OpenSSH
- Telnet (less secure, mostly outdated)



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

The semicolon (;) lets you execute commands in sequence, without stopping on errors.

Run commands one after another regardless of whether the previous command succeeds or fails.
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


## #Pipe( | ) - Connect Commands

- It passes the output of one command as input to another command.
- Send output of one command to another command.
```bash
cat /etc/passwd | grep root
```

**What happens:**
- cat /etc/passwd shows file content
- | sends that content to next command
- grep root finds lines with "root"

```bash
ls | head -5                    # Show first 5 files only
history | grep ssh              # Find ssh commands in history
cat /etc/passwd | wc -l         # Count total lines
```