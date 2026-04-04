
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
ps
```

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



___

# Managing Services (systemd)

**Modern Linux uses ==systemctl==.**

Check service:
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
