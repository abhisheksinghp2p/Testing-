# Redirect Output to a File or Program
### Output?
When you run a command, it shows results on screen. This is called output.

```bash
ls
```
Output appears on your screen.

## Two Types of Output

Type	                   Name	                           File Descriptor	                Description
___
stdout	                   Standard Output	             1	                                Normal output/results
_________________________________________
stderr	                   Standard Error	                 2	                                Error messages



### Save Output to a File 

#### Create New File or #Overwrite (>)

- Redirects output to a file by replacing its existing contents
- If the file doesn’t exist → it gets created
- If it exists → everything inside is deleted first

**Example:**
```bash
echo "Hello" > file.txt
```
**file.txt** will contain only:
```
Hello
```
**Warning: Using > will delete old content!**


```bash
ls > myfiles.txt
```
This saves the file list into myfiles.txt



#### Add to Existing File / #Append (>>)

- Redirects output to a file by adding to the end
- If the file doesn’t exist → it gets created
- If it exists → new content is added after existing content

**Example:**
```
echo "World" >> file.txt
```

**file.txt becomes:**
```
Hello
World
```

```bash
echo "Line 1" > notes.txt       # Creates file
echo "Line 2" >> notes.txt      # Adds to file
echo "Line 3" >> notes.txt      # Adds more
```

Now notes.txt has 3 lines.


## Pipe ( | ) - Connect Commands

Send output of one command to another command.
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

___ 

# Edit Text Files from the Shell Prompt

**Two Main Editors:**

| Editor   | Difficulty | Best For       |
| :------- | :--------- | :------------- |
| **nano** | Easy       | Beginners      |
| **vim**  | Hard       | Advanced users |

## Nano Editor

Open a File
```bash
nano filename.txt
```

**Basic command:**

| Action         | Keys to press             |
| :------------- | :------------------------ |
| **Save file**  | `Ctrl` + `O` then `Enter` |
| **Exit**       | `Ctrl` + `X`              |
| **Cut line**   | `Ctrl` + `K`              |
| **Paste**      | `Ctrl` + `U`              |
| **Search**     | `Ctrl` + `W`              |
| **Go to line** | `Ctrl` + `_`              |


## Vim Editor
Vim has modes. This confuses beginners.

**Two Main Modes:**

| Mode       | Purpose                   | How to enter |
| :--------- | :------------------------ | :----------- |
| **Normal** | Move around, delete, copy | Press `Esc`  |
| **Insert** | Type text                 | Press `i`    |

### Basic Vim Steps
#### Open file:
```
vim filename.txt
```

**To type text:**
- Press i (now you can type)
- Type your text
- Press Esc when done typing
  
**To save and quit:**
- Press Esc
- Type :wq
- Press Enter
  
**To quit without saving:**
- Press Esc
- Type :q!
- Press Enter

#### Vim Cheat Sheet 
| Action | Keys |
| :--- | :--- |
| **Start typing** (Insert mode) | `i` |
| **Stop typing** (Normal mode) | `Esc` |
| **Save** | `:w` + `Enter` |
| **Quit** | `:q` + `Enter` |
| **Save and quit** | `:wq` + `Enter` |
| **Quit without saving** | `:q!` + `Enter` |
| **Delete line** | `dd` |
| **Undo** | `u` |
| **Search** | `/word` + `Enter` |

## Create File Without Editor
Create File Without Editor

#### Create small file:
```
echo "Hello World" > myfile.txt
```

#### Create file with multiple lines:
```
cat > notes.txt << EOF
Line 1
Line 2
Line 3
EOF
```


## Stream Editors (sed & awk)

**Difference from nano/vim:**
- nano/vim: Open file, edit interactively, save
- sed/awk: Edit text in one command (non-interactive)


### awk (Pattern Scanning & Processing)
AWK is mainly used to extract and process columns (fields) from text.

==awk is a tool to work with columns in text files.==

**AWK is best for:**
- printing specific columns
- filtering based on conditions
- parsing logs, /etc/passwd, command output

**If a file looks like:**
```
xyz 25 india
john 30 usa
```

**command:**
```bash
awk '{print $1}' file.txt
```

**output:**
```
ak
john
```

**How AWK sees data**
By default, AWK splits each line by spaces/tabs into fields:
- $1 = first column
- $2 = second column
- $NF = last column
- NR = line number

**Example:**
```bash
echo "root:x:0:0:root:/root:/bin/bash" | awk -F: '{print $1, $7}'
```

**Output:**
```bash
root /bin/bash
```

#### AWK basic format
```bash
awk 'pattern { action }' file
```

**example:**
```bash
awk '$3 > 1000 {print $1, $3}' /etc/passwd
```
**Meaning:**
- if column 3 (UID) > 1000
- print username + UID


### sed (Stream Editor) (search/replace + line editing)

**Purpose:** Find/replace + delete/insert for text streams

==sed is used to find and replace text.==

**SED is best for:**
- replacing text
- deleting lines
- printing specific lines
- quick cleanup (spaces, blank lines)
- editing in pipelines

#### Sed basic format
```bash
sed 'command' file
```

**example:**
```bash
sed 's/india/USA/g' file.txt
```
It replaces india with USA.

**example:**
```
echo "hello root" | sed 's/root/admin/'
```

**output:**
```bash
hello admin
```

**example:**
```bash
# Replace all "http" with "https"
sed 's/http/https/g' urls.txt
```

---

# Change the Shell Environment
## Environment Variables
Variables are like containers that store information.

The system uses variables to remember things like:
- Your username
- Your home folder
- Where to find commands

### View Variables
**See one variable:**
```
echo $HOME
echo $USER
echo $SHELL
```

==**See all variables:**==
```
env
```

#### Important Variables

| Variable | What it stores | Example Value |
| :--- | :--- | :--- |
| `$HOME` | Your home folder | `/home/john` |
| `$USER` | Your username | `john` |
| `$SHELL` | Your shell program | `/bin/bash` |
| `$PWD` | Current folder | `/home/john/docs` |
| `$PATH` | Where commands are found | `/usr/bin:/bin` |
### Create Your Own Variable
```
MYNAME="ak"
echo $MYNAME
```

output:ak

## The PATH Variable
PATH tells the system where to look for commands.

```
echo $PATH
```


**Output looks like:**
```
/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin
```

These are folders separated by :

### Add Folder to PATH
```
export PATH=$PATH:/home/john/scripts
```
Now system will also look in /home/john/scripts for commands.



## Aliases - Create Shortcuts
Tired of typing long commands? Create shortcuts!

**Create alias:**
```
alias ll='ls -la'
```


```
alias c='clear'
alias h='history'
alias ports='ss -tulnp'
```

#### See all aliases:
```
alias
```

####
```
unalias ll
```


## Make Changes Permanent
Changes disappear when you close terminal!

To keep them forever, add to ~/.bashrc:
```
nano ~/.bashrc
```

**Add your lines at the bottom:**
```
alias ll='ls -la'
alias c='clear'
export PATH=$PATH:/home/john/scripts
```
Save and exit (Ctrl+O, Ctrl+X)

**Apply changes now:**
```
source ~/.bashrc
```

## Command History
Bash remembers your old commands.

**View history:**
```
history
```

**Run old command:**
```
!50                             # Run command number 50
!!                              # Run last command
```


**Clear history:**
```
history -c
```



#### ==Check for passwords in environment:==
```
env | grep -i pass
env | grep -i key
```