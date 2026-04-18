# Validate Network Configuration
### Check IP Address

**Show all interfaces:**
```
ip a
```
**Shows:**
- IP address
- Network interfaces (like eth0, ens33)

**Look for:**
```
inet 192.168.x.x
```

```
ifconfig
```

____________

### Check Routing Table
```
ip route
```

**Routing table:**
```
ip r
```
Shows routing table

**Important:**
```
default via 192.168.1.1
```
This is your gateway (internet path)


_____________

### Open Ports

**Check Open Ports:**
```
ss -tuln
```
Shows open ports
- t → TCP
- u → UDP
- l → listening
- n → numeric

or 
```
nmap -p- <ip>
```



-----------

### Check DNS Configuration
```
cat /etc/resolv.conf
```


______


# 2. Set Hostname

```
sudo hostnamectl set-hostname myserver
```
Changes system name


**Check:**
```
hostnamectl
```

_________

# 3. Static IP using `nmcli`

#### 1. Check connection name
```
nmcli con show
```

**Example:**
```
System eth0
```


#### 2. Set static IP
```
nmcli con modify "System eth0" \
ipv4.addresses 192.168.1.100/24 \                
ipv4.gateway 192.168.1.1 \
ipv4.method manual
```

**Set DNS**
```
nmcli con modify "System eth0" ipv4.dns "8.8.8.8"
```


**Apply changes**
```
nmcli con up "System eth0"
```


#### Important Commands

| Command                 | Use              |
| ----------------------- | ---------------- |
| `nmcli con show`        | list connections |
| `nmcli con up name`     | activate         |
| `nmcli con down name`   | deactivate       |
| `nmcli con delete name` | delete           |

### ==`nmtui` (Easy Mode)==

```
nmtui
```
Text-based UI (very easy)

**Use it to:**
- Set IP
- Set hostname
- Enable/disable network


___

# 4. DNS Configuration

```
/etc/hosts (local DNS)
```

```
sudo nano /etc/hosts
```

**Example:**
```
192.168.1.10   myserver
```
Used for local name resolution

#### via nmcli
```
nmcli con modify "System eth0" ipv4.dns "8.8.8.8"
```

______


# 5. Troubleshooting Commands

### Test Network Connectivity

ping - Test if Host is Reachable
```
ping 192.168.1.1
```

```
ping -c 4 192.168.1.1
```
Sends 4 pings only.


#### Test DNS Resolution
```
nslookup google.com
```

```
dig google.com
```
DNS lookup

#### traceroute - Show Path to Destination
```
traceroute google.com
```
Shows each hop (router) along the way.


#### HTTP test
```
curl http://example.com
```
Test HTTP request