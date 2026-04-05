
#  Process States and Lifecycle

## Process?
A process is a running program.

When you open a program, it becomes a process.

**Examples:**
- You type ls → A process runs and shows files
- Firefox browser open → A process running
- Apache web server → A process running in background


#### Process vs Program

| Feature      | Program      | Process              |
| :----------- | :----------- | :------------------- |
| **Location** | File on disk | Running in memory    |
| **State**    | Static       | Active               |
| **Quantity** | One copy     | Can have many copies |
**Example:**
- /usr/bin/firefox = Program (file)
- Running Firefox = Process


#### Every Process Has
| Property     | Meaning                    | Example           |
| :----------- | :------------------------- | :---------------- |
| **PID**      | Process ID (unique number) | `1234`            |
| **PPID**     | Parent Process ID          | `1`               |
| **User**     | Who started it             | `john`            |
| **State**    | Current status             | Running, Sleeping |
| **CPU %**    | CPU usage                  | `5%`              |
| **Memory %** | RAM usage                  | `2%`              |

#### Process States
| State        | Letter | Meaning                     |
| :----------- | :----- | :-------------------------- |
| **Running**  | `R`    | Currently executing         |
| **Sleeping** | `S`    | Waiting for something       |
| **Stopped**  | `T`    | Paused (Ctrl+Z)             |
| **Zombie**   | `Z`    | Finished but not cleaned up |
| **Dead**     | `X`    | Completely finished         |

#### Process Lifecycle
```
Created → Running → Sleeping → Running → Terminated
            ↑          ↓
            └──────────┘
```

**Simple flow:**
1. You start a program
2. It becomes a process (Running)
3. It may wait for input (Sleeping)
4. It continues (Running)
5. It finishes (Terminated)


### Parent and Child Processes

Every process has a parent (except PID 1).
```
init/systemd (PID 1)
    └── bash (PID 1000)
            └── ls (PID 1234)
```

**When you run a command:**
- Your shell (bash) is the parent
- The command becomes the child


#### View Process Information
```
ps     (#Snapshot of processes)
```
Think of ps as a photo of system at that moment


**Output:**
```
  PID TTY          TIME CMD
 1234 pts/0    00:00:00 bash
 1250 pts/0    00:00:00 ps
```

```
USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root         1  0.0  0.1 169836 12456 ?        Ss   10:00   0:02 /usr/lib/systemd/systemd
```

**All processes (full format):**

```
ps aux
```
- a → all users
- u → user format (CPU, MEM)
- x → background processes

**Shows:**
- all processes
- CPU, memory usage

##### Find Specific Process
```
ps aux | grep apache
ps aux | grep ssh
ps aux | grep python
```

##### View Process Tree
See parent-child relationships:
```
pstree
```

or

```
ps -ef
```
Shows process tree relation

**Important columns:**
- PID → process
- PPID → parent process

----

# Monitor Process Activity

## top - Real-time Process Monitor
```
top
```
**Press:**
- q → quit
- k → kill process
- M → sort by memory

**Output updates every 3 seconds:**
```
top - 10:30:00 up 5 days,  2:30,  2 users,  load average: 0.15, 0.10, 0.05
Tasks: 150 total,   1 running, 149 sleeping,   0 stopped,   0 zombie
%Cpu(s):  2.0 us,  1.0 sy,  0.0 ni, 96.5 id,  0.5 wa,  0.0 hi,  0.0 si
MiB Mem :   7976.5 total,   2345.6 free,   3456.7 used,   2174.2 buff/cache
MiB Swap:   2048.0 total,   2048.0 free,      0.0 used.   4123.4 avail Mem

  PID USER      PR  NI    VIRT    RES    SHR S  %CPU  %MEM     TIME+ COMMAND
 1234 john      20   0  123456  56789  12345 S   5.0   0.7   1:23.45 firefox
 5678 root      20   0   98765  34567   8901 S   2.0   0.4   0:45.67 apache2
```


## htop - Better Version of top

Install first:
```
sudo apt install htop
```

```
htop
```

**Benefits:**
- Colored output
- Easier to use
- Mouse support
- Easier to kill processes


### free - Memory Usage
```
free -h
```

___

# Finding Processes - `pgrep` 

Work with processes using name instead of PID

### pgrep
```
pgrep httpd          # Finds PID of httpd
pgrep -l sshd        # Show name too
pgrep -u root        # All root processes
```

----

# Kill Processes
**Why Kill Processes?**
- Process is frozen/not responding
- Process is using too much CPU/memory
- You want to stop a service
- Malicious process running

## Signals
To kill a process, you send it a signal.


**Common signals:**

| Signal      | Number | Meaning                    |
| :---------- | :----- | :------------------------- |
| **SIGHUP**  | `1`    | Hangup (reload config)     |
| **SIGINT**  | `2`    | Interrupt (Ctrl+C)         |
| **SIGKILL** | `9`    | Force kill (cannot ignore) |
| **SIGTERM** | `15`   | Terminate nicely (default) |
| **SIGSTOP** | `19`   | Pause process              |
| **SIGCONT** | `18`   | Continue paused process    |

**View All Signals:**
```
kill -l
```

#### kill Command
**Basic syntax:**
```
kill PID
```
Sends SIGTERM (15) by default - asks process to quit nicely.

**Kill Process Example:**

First find the PID:
```
ps aux | grep firefox
```

Output:
```
john  1234  5.0  3.0  123456  78900  ?  Sl  10:00  1:00 firefox
```
PID= 1234

**Kill it:**
```
kill 1234
```

#### Force Kill (When Normal Kill Doesn't Work)
SIGKILL (9) - Cannot be ignored:
```
kill -9 1234
kill -SIGKILL 1234
kill -KILL 1234
```

#### killall - Kill by Name
Kill all processes with that name:

```
killall firefox
killall -9 firefox              # Force kill
```


#### Kill Zombie Processes
Zombies can't be killed directly!

Find zombies:
```
ps aux | grep Z
```

Kill the parent process:
```
ps -ef | grep <zombie_PID>      # Find PPID
kill <PPID>                      # Kill parent
```


#### pkill = Process Kill by Name

It allows you to kill processes using their name, instead of using the PID.
```
pkill processname
```

##### Force kill
```
pkill -9 processname
```

___

# Background Jobs (`&`, `jobs`, `fg`, `bg`, `nohup`)

## job 
- A command started from your terminal
- It is linked to your current shell session

**Example:**
```
sleep 100
```
This becomes a job


## Types of Jobs
#### 1. Foreground Job

Runs in front of you

- Blocks terminal 
- You must wait

**Example:**
```
sleep 100
```

#### 2. Background Job

Runs behind the scenes

**Terminal is free**

**Example:**
```
sleep 100 &
```

### Jobs Working

##### Start a background job
```
sleep 100 &
```

**Output:**
```
[1] 1234
```
- `[1]` → Job number
- 1234 → PID

##### See jobs
```
jobs
```

**Example:**
```
[1]+ Running sleep 100 &
```

##### Stop a job (pause it)

**Press:**
```
Ctrl + Z
```

**Job becomes:**
```
Stopped
```

##### Resume in background
```
bg %1
```

##### Bring to foreground
```
fg %1
```



## Jobs vs Processes

| Feature       | Job              | Process       |
| ------------- | ---------------- | ------------- |
| Controlled by | Shell            | OS            |
| Scope         | Current terminal | Entire system |
| ID            | Job ID (`%1`)    | PID (`1234`)  |
==Every job is a process, but not every process is a job==


### What happens when terminal closes?

**❌ Normal background job:**
```
sleep 100 &
```

👉 Dies when terminal closes

**✅ Persistent job (nohup):**
```
nohup sleep 100 &
```

👉 Keeps running even after logout

**Even if:**
- You logout
- Terminal closes

Process keeps running

___
# Nice Values (Priority)

**Controls CPU priority**

**Range:**
```
-20 (highest priority)
0 (default)
19 (lowest priority)
```

Nice values control how much CPU time a process gets (-20 to 19).

- Lower number = Higher priority (confusing, I know!)
- -20: Highest priority (not nice at all!)
- 0: Default
- 19: Lowest priority (very nice to others!)

```bash
nice -n 10 ./script.sh        # Start with low priority
renice -n 5 -p 1234          # Change priority of running process
```

**Use case:** Running a backup script that shouldn't slow down your server.
```bash
nice -n 15 tar -czf backup.tar.gz /data
```



____________
# Managing Services (systemd)

Systemd is the "manager" that controls services (programs that run in the background).

**Modern Linux uses ==systemctl==.**

#### service
**Example:**
- web server (httpd)
- ssh (sshd)

```bash
systemctl start httpd       # Start Apache web server
systemctl stop httpd        # Stop it
systemctl restart httpd     # Stop then start
systemctl status httpd      # Check if running

systemctl enable httpd      # Start automatically at boot
systemctl disable httpd     # Don't start at boot
systemctl mask httpd        # Completely prevent from starting
```

**Check service:**
```
systemctl status ssh
```

**Start:**
```
sudo systemctl start ssh

```

**Stop:**
```
sudo systemctl stop ssh
```

**mask:**
```
systemctl mask httpd        # Completely prevent from starting
```
Completely blocks service (even manual start ❌)



____

# Journald (Logs)

**System logging service**

##### View logs
```
journalctl
```

##### Live logs
```
journalctl -f
```

##### Logs for service
```
journalctl -u httpd
```

### Make logs persistent

**Edit:**
```
sudo nano /etc/systemd/journald.conf
```

**Change:**
```
Storage=persistent

```

**Then:**
```
systemctl restart systemd-journald
```

