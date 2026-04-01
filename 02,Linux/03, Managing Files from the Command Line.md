# The Linux File System Structure
Linux uses a hierarchical (tree) structure starting from the root directory /. Unlike Windows which uses drive letters (C:, D:), Linux has a single unified tree.

```
/
├── bin
├── boot
├── dev
├── etc
├── home
├── lib
├── media
├── mnt
├── opt
├── proc
├── root
├── run
├── sbin
├── srv
├── sys
├── tmp
├── usr
└── var
```

### Absolute vs Relative Paths
#### Absolute Path
- Starts from root /
- Complete path to file/directory
- Works from anywhere

```
/home/john/documents/report.txt
/etc/passwd
/var/log/secure
```

#### Relative Path
- Relative to current directory
- Does not start with /
- Shorter but depends on location

```
documents/report.txt      # From /home/john
../jane/file.txt          # Go up one, then to jane
./script.sh               # Current directory
```

#### Special Directory References
| Symbol  | Meaning             |
| :------ | :------------------ |
| `.`     | Current directory   |
| `..`    | Parent directory    |
| `~`     | Home directory      |
| `~user` | Another user's home |
# Specify Files by Name
**File Naming Rules:**
- Case-sensitive (File.txt ≠ file.txt)
- Can contain letters, numbers, dots, underscores, hyphens
- Avoid spaces (use quotes or escape if needed)
- **Hidden files start with .**
- No length limit practically (255 characters max)
- Avoid special characters (/ \ * ? " < > |)

### Hidden Files
Files starting with . are hidden by default.
```
ls          # Shows only visible files
ls -a       # Shows all files including hidden
ls -la      # Long listing with hidden files
```

#### Important Directories

| File/Directory           | Description                    |
| :----------------------- | :----------------------------- |
| `~/.bash_history`        | Command history                |
| `~/.bashrc`              | Bash configuration             |
| `~/.bash_profile`        | Login configuration            |
| `~/.ssh/`                | SSH keys and config            |
| `~/.ssh/authorized_keys` | Allowed SSH public keys        |
| `~/.ssh/id_rsa`          | Private SSH key (**CRITICAL**) |
| `~/.ssh/known_hosts`     | Known SSH servers              |
| `~/.config/`             | Application configs            |
==`~/.bashrc` - It's a file run in background when we open terminal & configure the terminal according to our alias or predefined alias.==

**View file:**
```bash
 cat ~/.bash_history
```

**Edit file:**
```Bash
nano ~/.bashrc
```

# Manage Files with Command-line Tools

## Listing Files - ls Command
```
ls                  # List current directory
ls /etc             # List specific directory
ls -l               # Long format
ls -a               # Show hidden files
ls -la              # Long format with hidden
ls -lh              # Human-readable sizes
ls -lt              # Sort by modification time
ls -lS              # Sort by size
ls -R               # Recursive listing
ls -ld /etc         # Directory info only
```

### Understanding long format output:
```
-rw-r--r--. 1 root root 2388 Jan 15 10:30 passwd
```

| Field          | Meaning                     |
| :------------- | :-------------------------- |
| `-rw-r--r--`   | Permissions (Type + Access) |
| `.`            | SELinux context indicator   |
| `1`            | Number of hard links        |
| `root`         | Owner (User)                |
| `root`         | Group                       |
| `2388`         | Size in bytes               |
| `Jan 15 10:30` | Last modification time      |
| `passwd`       | File name                   |

## Creating Directories - mkdir Command

```
mkdir docs                      # Create single directory
mkdir -p parent/child/grandchild  # Create nested directories
mkdir dir1 dir2 dir3            # Create multiple directories
mkdir -m 700 private            # Create with specific permissions
```


## Creating Files - touch Command
```
touch file.txt                  # Create empty file
touch file1 file2 file3         # Create multiple files
touch -t 202301151030 file.txt  # Set specific timestamp
```

==**Note:** touch also updates timestamps of existing files.==

## Copying Files - cp Command
```
cp source destination           # Basic copy
cp file.txt /tmp/               # Copy to directory
cp file.txt /tmp/newname.txt    # Copy with new name
cp -r dir1 dir2                 # Copy directory recursively
cp -p file.txt backup/          # Preserve permissions and timestamps
cp -i file.txt /tmp/            # Interactive (prompt before overwrite)
cp -v file.txt /tmp/            # Verbose output
cp -a source/ dest/             # Archive mode (preserves everything)
```

## Moving and Renaming - mv Command
```
mv oldname newname              # Rename file
mv file.txt /tmp/               # Move to directory
mv file.txt /tmp/newname.txt    # Move and rename
mv -i file.txt /tmp/            # Interactive
mv -v file.txt /tmp/            # Verbose
mv dir1 dir2                    # Move/rename directory
```

## Removing Files - rm Command
```
rm file.txt                     # Remove file
rm -i file.txt                  # Interactive (confirm)
rm -f file.txt                  # Force (no prompt)
rm -r directory                 # Remove directory recursively
rm -rf directory                # Force remove directory
rm -v file.txt                  # Verbose
```

**Warning:** rm -rf / can destroy entire system. Be extremely careful with rm commands.

## Removing Directories - rmdir Command
```
rmdir empty_directory           # Remove empty directory only
rmdir -p parent/child           # Remove nested empty directories
```


## File Content Commands

cat - Concatenate and Display
```
cat file.txt                    # Display file
cat file1 file2                 # Display multiple files
cat -n file.txt                 # Show line numbers
cat -A file.txt                 # Show hidden characters
```

### less - Page Through Files
```
less file.txt
```

### head and tail
```
head file.txt                   # First 10 lines
head -n 20 file.txt             # First 20 lines
head -c 100 file.txt            # First 100 bytes

tail file.txt                   # Last 10 lines
tail -n 50 file.txt             # Last 50 lines
tail -f /var/log/secure         # Follow file in real-time
tail -F /var/log/secure         # Follow with retry if file recreated
```

### wc - Word Count
```
wc file.txt                     # Lines, words, characters
wc -l file.txt                  # Lines only
wc -w file.txt                  # Words only
wc -c file.txt                  # Bytes only
wc -m file.txt                  # Characters only
```


#### Hidden Directories

| File                     | Purpose                        |
| :----------------------- | :----------------------------- |
| `~/.bash_history`        | Command history                |
| `~/.bashrc`              | Bash configuration             |
| `~/.bash_profile`        | Login configuration            |
| `~/.ssh/`                | SSH keys and config            |
| `~/.ssh/authorized_keys` | Allowed SSH public keys        |
| `~/.ssh/id_rsa`          | Private SSH key (**CRITICAL**) |
| `~/.ssh/known_hosts`     | Known SSH servers              |
| `~/.gnupg/`              | GPG keys                       |
| `~/.config/`             | Application configs            |



___ 

# The find Command
Powerful command for searching files.

**Basic syntax:**
```
find [path] [options] [expression]
```

```bash
find / -name passwd                     # Find by name
find / -iname passwd                    # Case-insensitive
find / -name "*.conf"                   # Wildcard search
find /home -user john                   # Files owned by user
find / -group admin                     # Files owned by group
find / -type f                          # Files only
find / -type d                          # Directories only
find / -type l                          # Symbolic links
find / -size +10M                       # Files larger than 10MB
find / -size -1k                        # Files smaller than 1KB
find / -mtime -7                        # Modified in last 7 days
find / -atime +30                       # Accessed more than 30 days ago
find / -perm 777                        # Exact permissions
find / -perm -4000                      # SUID files
find / -perm -2000                      # SGID files
find / -writable                        # Writable by current user
find / -executable                      # Executable by current user
```

# The locate Command
Faster than find but uses a database.

```bash
locate passwd                   # Find files containing "passwd"
locate -i readme                # Case-insensitive
locate -c "*.conf"              # Count matches
updatedb                        # Update database (root required)
```


#  `which` (Command path finder)
Finds the path of executable commands
- Searches in $PATH only
- Works only for commands

**example:**
```
which ls
```

**output:**
```
/bin/ls
```

``` bash
which python                    # Find command location
which -a python                 # All locations in PATH

type python                     # How shell interprets command
```

#  `whereis` (Quick binary/manuals + info)

Finds binary, source, and manual pages
- Faster than find
- Not as deep as find
**example:**
```
whereis ls
```

**output:**
```
ls: /bin/ls /usr/share/man/man1/ls.1.gz
```

```
whereis python3
```

| Command   | Search Type      | Speed     | Accuracy  | Use Case          |
| --------- | ---------------- | --------- | --------- | ----------------- |
| `find`    | Real filesystem  | Slow      | Very high | Deep search       |
| `locate`  | Database         | Fast      | Medium    | Quick search      |
| `which`   | Executables only | Very fast | High      | Find command path |
| `whereis` | Binary + docs    | Fast      | Medium    | Quick lookup      |

# `grep` = Global Regular Expression Print

**grep** = **search text inside files**
==It searches for patterns (text) inside files or command output.==
`grep` is one of the most powerful **text-search** tools in Linux—used everywhere from basic file searches to advanced cybersecurity analysis.

**Basic Syntax:**
```
grep [options] pattern file
```

```
grep "error" logfile.txt                        (Shows lines containing error)
grep "error" file1.txt file2.txt                (Search in Multiple Files)
grep -r "password" /etc                         (Searches all files inside /etc)  (Recursive Search)   
ps aux | grep nginx                             (Finds running nginx processes)

grep "Failed password" /var/log/auth.log        (Find failed logins)
```