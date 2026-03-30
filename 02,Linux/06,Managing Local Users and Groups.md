# User and Group Concepts
## User?
A user is an account that can log into the system.

**Every user has:**
- Username - Name to login (like "john")
- UID - User ID number (like 1001)
- Home folder - Personal folder (like /home/john)
- Shell - Program to use (like /bin/bash)

#### Types of Users

| Type              | UID Range | Purpose                 | Example           |
| :---------------- | :-------- | :---------------------- | :---------------- |
| **Root**          | `0`       | Super admin, full power | `root`            |
| **System users**  | `1-999`   | Run services, no login  | `apache`, `mysql` |
| **Regular users** | `1000+`   | Normal people           | `john`, `sarah`   |

==UID 0 = superuser privileges==
## Group?
A group is a collection of users.

Groups help manage permissions for multiple users at once.

**Example:**
- Group "developers" has users: john, sarah, mike
- All of them can access the same files

#### Every User Has
| Item                 | Description                            |
| :------------------- | :------------------------------------- |
| **Primary group**    | Main group (usually same name as user) |
| **Secondary groups** | Additional groups user belongs to      |

**Example:**
- User "john"
- Primary group: john
- Secondary groups: developers, wheel


## Important Files

| File        | What it stores           |
| ----------- | ------------------------ |
| /etc/passwd | User account information |
| /etc/shadow | Encrypted passwords      |
| /etc/group  | Group information        |


---

# Gain Superuser Access
## Root?
Root is the superuser - the most powerful account.

- UID is always 0
- Can do ANYTHING on the system
- Can read/write/delete any file
- Can add/remove users
- Very dangerous if misused!


#### Root Prompt vs Normal Prompt
```
[john@server ~]$              # Normal user ($ sign)
[root@server ~]#              # Root user (# sign)
```

- $ = regular user
-  # = root user


### Two Ways to Get Root Power

| Method   | Command        | What it does            |
| :------- | :------------- | :---------------------- |
| **su**   | `su -`         | Switch to root user     |
| **sudo** | `sudo command` | Run one command as root |

#### Using su (Switch User)
**Switch to root:**
```
su -
```
Enter root password. Now you ARE root.

**Switch to another user:**
```
su - <username>
```

**Exit back:**
```
exit
```

#### Using sudo 

**Run ONE command with root power:**
```
sudo cat /etc/shadow
```
Enter YOUR password (not root's).

**Why sudo is better:**
- Don't need to know root password
- Only runs one command as root
- Logs what you did
- Safer than being root all the time

#### sudo su
Uses sudo privileges to become root

```
sudo su
```

Requires your user password (not root)


### Who Can Use sudo?
Users in the wheel group can use sudo.

**Check if you can use sudo:**
```
groups
```

Look for "wheel" in the list.

#### Wheel Group
==The wheel group is a special administrative group used to control who is allowed to gain superuser (root) privileges.==
It acts as a security control layer for privileged access.

##### Different Distros Use Different Admin Groups

| Distribution             | Admin Group |
| ------------------------ | ----------- |
| Ubuntu                   | `sudo`      |
| Debian                   | `sudo`      |
| Red Hat Enterprise Linux | `wheel`     |
| CentOS                   | `wheel`     |
| Fedora                   | `wheel`     |


**Check sudo configuration:**
```
sudo cat /etc/sudoers
```

**common commands:**
```
sudo cat /etc/shadow            # View shadow file
sudo useradd newuser            # Add user
sudo passwd john                # Change password
sudo systemctl restart sshd     # Restart service
sudo vim /etc/hosts             # Edit system file
```


### Run Shell as Root
```
sudo -i                         # Get root shell
sudo -s                         # Get root shell (keeps environment)
```

| Command     | What it does                         | Password needed     |
| :---------- | :----------------------------------- | :------------------ |
| `su`        | Switch to root (no environment)      | **Root** password   |
| `su -`      | Switch to root (full environment)    | **Root** password   |
| `su - john` | Switch to john (full environment)    | **John's** password |
| `sudo su`   | Switch to root using YOUR password   | **Your** password   |
| `sudo su -` | Switch to root with full environment | **Your** password   |


---


#  Manage Local User Accounts

**View All Users**
```
cat /etc/passwd
```


## ==Create New User== `useradd`

**There are two common commands:**
==adduser==
useradd

```bash
sudo adduser <username>
```

**This creates:**
- User "username"
- Home folder /home/"username"
- Primary group "username"
- Prompts you to set password


```bash
sudo useradd <username>
```
**This only:**
- Creates user entry in /etc/passwd
- Does NOT set password
- Does NOT create home directory (unless -m)
- Not interactive

# Set Password for New User `passwd`

**New user has no password! Set one:**
```
sudo passwd <username>
```


# Modify Existing User ==(usermod)==

#### Change shell:
```
sudo usermod -s /bin/zsh <username>
```

#### Add to group:
```
sudo usermod -aG wheel <username>
```
- a → append (very important)
- G → supplementary (secondary) groups

**⚠ Never forget -a.**
If you run:
```
sudo usermod -G fgroup ak
```
==It will replace all existing supplementary groups and may remove sudo access.==


## Change username:
```
sudo usermod -l newname oldname
```

## Check Wheel group users
```
getent group sudo
cat /etc/group | grep wheel
or 
groups <username>
id <username>
```




## Lock a User:
**Locking:**
The user cannot authenticate (log in) using their password.
```bash
sudo usermod -L ak
```

## Unlock user:
**Unlocking:**
Unlocking restores the ability to log in.
It does NOT delete the account.

```bash
sudo usermod -U john
```




# Delete User ==(userdel)==:

**Delete user only:**
```
sudo userdel john
```

**Delete user AND home folder:**
```
sudo userdel -r john
```


___

#  Manage Local Group Accounts

**View All Groups:**
```
cat /etc/group
```

**Your groups:**
```
groups
```

**Another user's groups:**
```
groups john
```

## Create New Group(==groupadd==):

```
sudo groupadd developers
```

**With specific GID:**
```
sudo groupadd -g 2000 developers
```

### Add User to Group
```
sudo usermod -aG developers john
```

==Remember: Always use -aG (append) or user will be removed from other secondary groups!==

### Remove User from Group
```
sudo gpasswd -d john developers
```

### Delete Group
```
sudo groupdel developers
```

==Note: Cannot delete a group if it's someone's primary group.==


___

#  Manage User Passwords

## Change Your Own Password
```
passwd
```
Enter old password, then new password twice.

#### Change Another User's Password (Need sudo)
```
sudo passwd john
```
Root doesn't need to know old password!


## Password Information

**Passwords are stored in /etc/shadow:**
```
sudo cat /etc/shadow
```

**example:**
```
john:$6$xyz...abc:19000:0:99999:7:::
```

| Field       | Meaning                                 |
| :---------- | :-------------------------------------- |
| `john`      | Username                                |
| `$6$xyz...` | Encrypted password                      |
| `19000`     | Days since Jan 1, 1970 (Last changed)   |
| `0`         | Min days before password change allowed |
| `99999`     | Max days password is valid              |
| `7`         | Warning days before expiration          |

### Password Hash Types
The password hash starts with a prefix:

| Prefix | Algorithm | Status             |
| :----- | :-------- | :----------------- |
| `$1$`  | MD5       | ❌ Old, Weak        |
| `$5$`  | SHA-256   | ✅ Secure           |
| `$6$`  | SHA-512   | ✅ Current Standard |
#### Check Password Status
```
sudo passwd -S john
```

output:
```
john PS 2023-01-15 0 99999 7 -1 (Password set, SHA512 crypt.)
```
