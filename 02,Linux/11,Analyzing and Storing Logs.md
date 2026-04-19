# Logs 

**Logs record everything that happens on a system:**
- Who logged in
- What commands were run
- What services started/stopped
- Errors and warnings
- Security events


## System Log Architecture

**Two Logging Systems:** 

| System       | Name                | Description                 |
| :----------- | :------------------ | :-------------------------- |
| **rsyslog**  | Traditional logging | Text files in `/var/log`    |
| **journald** | Modern logging      | Binary journal by `systemd` |

### How Logging Works
```
Application → rsyslog/journald → Log Files/Journal
                    ↓
              /var/log/ files
```

**Simple flow:**
- Something happens (login, error, etc.)
- System sends log message
- rsyslog writes to text files
- journald stores in binary journal

#### ==Log Locations==
| Location            | What's There                 |
| :------------------ | :--------------------------- |
| `/var/log/`         | Main log directory           |
| `/var/log/messages` | General system logs          |
| `/var/log/secure`   | Authentication/security logs |
| `/var/log/boot.log` | Boot messages                |
| `/var/log/cron`     | Cron job logs                |
| `/var/log/maillog`  | Email logs                   |
| `/var/log/audit/`   | SELinux audit logs           |
| `/run/log/journal/` | systemd journal (temporary)  |
| `/var/log/journal/` | systemd journal (permanent)  |

___

# Review Syslog Files
## rsyslog Service

**Check if rsyslog is running:**
```
systemctl status rsyslog
```

**rsyslog configuration:**
```
cat /etc/rsyslog.conf
```


### Important Log Files
#### /var/log/messages - General System Log

**View all:**
```
sudo cat /var/log/messages
```


#### ==/var/log/secure - Security/Authentication Log==

**This file contains:**
- Login attempts (success and failure)
- SSH connections
- sudo usage
- User authentication


**View all:**
```
sudo cat /var/log/secure
```



___

#  Review System Journal Entries

## journald
journald is the modern logging system from systemd.
==journald is the systemd logging daemon that collects and stores system logs in binary format.==

**Benefits:**
- Structured data (not just text)
- Can filter by service, time, priority
- Includes boot logs
- Binary format (faster searching)


### journalctl Command
Main command to read journal.

**View all logs:**
```
journalctl
```