
---

# 1. Cisco CLI Modes

Cisco devices have different modes for security and control.

| Mode | Prompt | Purpose | Command |
|-----|-----|-----|-----|
| User Mode | `Router>` | Basic view only | Default |
| Privileged Mode | `Router#` | Admin access | `enable` |
| Global Config | `(config)#` | Change device settings | `configure terminal` |

### Example
```
Router> enable
Router# configure terminal
Router(config)#
```

**Simple meaning**

- `>` → normal user
- `#` → admin
- `(config)#` → editing device settings

---

# 2. Basic Router Configuration

## Step 1 — Enter Configuration Mode

```
Router> enable
Router# configure terminal
```

---

## Step 2 — Set Router Name

```
Router(config)# hostname R1
```

Now router prompt becomes:

```
R1(config)#
```

---

## Step 3 — Configure an Interface

Routers communicate through **interfaces (ports)**.

Example configuration:

```
R1(config)# interface gigabitEthernet0/0
R1(config-if)# ip address 192.168.1.1 255.255.255.0
R1(config-if)# no shutdown
```

Explanation:

| Command        | Meaning           |
| -------------- | ----------------- |
| interface g0/0 | Select the port   |
| ip address     | Assign IP address |
| no shutdown    | Turn the port ON  |

Important:

Cisco interfaces are **off by default**.

Without `no shutdown` the interface will stay **disabled**.

---

# 3. Basic Switch Configuration

Switches work automatically but need an **IP for management**.

```
Switch> enable
Switch# configure terminal
Switch(config)# hostname S1
```

---

## Assign Management IP

```
S1(config)# interface vlan 1
S1(config-if)# ip address 192.168.1.2 255.255.255.0
S1(config-if)# no shutdown
```

---

## Set Default Gateway

```
S1(config)# ip default-gateway 192.168.1.1
```

Explanation:

The switch will send traffic for other networks to the router.

---

# 4. Static Routing

Routers only know **directly connected networks**.

To reach another network, we must create a **static route**.

### Syntax

```
ip route DESTINATION_NETWORK SUBNET_MASK NEXT_HOP
```

### Example

```
R1(config)# ip route 10.0.0.0 255.255.255.0 192.168.1.2
```

Meaning:

```
To reach network 10.0.0.0
send packets to router 192.168.1.2
```

---

# 5. Default Route

Default route is used for **unknown networks (usually internet)**.

```
R1(config)# ip route 0.0.0.0 0.0.0.0 192.168.1.1
```

Meaning:

```
If router doesn't know where to send traffic
send it to 192.168.1.1
```

Usually this is the **ISP router**.

---

# 6. Important Troubleshooting Commands

These commands help find network problems.

---

## Check Interface Status

```
show ip interface brief
```

Common results:

| Status | Meaning |
|------|------|
| up/up | Working |
| administratively down | Interface disabled |
| down/down | Cable problem |

---

## Check Routing Table

```
show ip route
```

Important codes:

| Code | Meaning |
|----|----|
| C | Connected |
| S | Static route |
| O | OSPF route |

---

## Check Connectivity

### Ping

```
ping 192.168.1.1
```

Meaning:

```
"Are you reachable?"
```

---

### Traceroute

```
traceroute 8.8.8.8
```

Shows the **path packets take to reach the destination**.

---

# 7. Common Network Problems

| Problem                    | Cause              | Fix                       |
| -------------------------- | ------------------ | ------------------------- |
| Ping fails                 | Interface disabled | `no shutdown`             |
| Ping fails                 | Wrong IP address   | Check device IP           |
| Cannot reach internet      | Missing gateway    | Configure default gateway |
| Cannot reach other network | Missing route      | Add static route          |

---

# 8. Save Configuration

If you reboot without saving, configuration is lost.

Save it using:

```
copy running-config startup-config
```

OR

```
write memory
```

Meaning:

```
running-config → current settings
startup-config → saved settings used after reboot
```

---

# Quick Command Summary

```
enable
configure terminal
hostname
interface
ip address
no shutdown
ip route
show ip interface brief
show ip route
ping
traceroute
copy running-config startup-config
```

---

# One Line Summary

Router configuration = Assign IP + Enable interface + Add routes  
Troubleshooting = Use show commands + ping + traceroute