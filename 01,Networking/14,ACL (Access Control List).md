==ACL is a set of rules used to permit or deny network traffic based on IP, port, or protocol.==

```
                    ┌─────────────┐
   Traffic ────────►│    ACL      │────────► Allowed Traffic
   (Packets)        │  (Filter)   │
                    └──────┬──────┘
                           │
                           ▼
                      Blocked Traffic
                         (Denied)
```

### Common Uses of ACLs / Traffic Filtering
- Control traffic flow
- Improve security
- Filter unwanted traffic

| Purpose                  | Example                          |
| :----------------------- | :------------------------------- |
| **Security**             | Block hackers/unwanted traffic   |
| **Traffic Control**      | Limit who can access servers     |
| **Bandwidth Management** | Restrict certain applications    |
| **NAT**                  | Identify traffic for translation |
| **VPN**                  | Define interesting traffic       |
| **QoS**                  | Classify traffic for priority    |

### Types of ACL 
## Standard ACL 
==Filters traffic based on source IP only==

**Place:** CLOSE TO DESTINATION Router.
## Extended ACL
Filters traffic based on Source IP, Destination IP, Port number, Protocol (TCP/UDP/ICMP)

**Place:** CLOSE TO SOURCE  Router.

**ACL ID numbers used to identify ACL type**
- 1-99 = Standard ACL 
- 100-199 Extended ACL
- ```
┌─────────────────────────────────────────────────────────────────┐
│                    STANDARD ACL                                 │
├─────────────────────────────────────────────────────────────────┤
│  • Number: 1-99                                                 │
│  • Filters by: SOURCE IP only                                   │
│  • Simple but less precise                                      │
│  • Place: CLOSE TO DESTINATION                                  │
└─────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│                    EXTENDED ACL                                 │
├─────────────────────────────────────────────────────────────────┤
│  • Number: 100-199                                              │
│  • Filters by: Source IP, Dest IP, Protocol, Ports              │
│  • More precise control                                         │
│  • Place: CLOSE TO SOURCE                                       │
└─────────────────────────────────────────────────────────────────┘
```


_________________


# Port Security 
- ==Port security is a feature used to restrict which devices can connect to a switch port using MAC address==
- Port Security is a feature used on switches to control which devices are allowed to connect to a specific switch port. It helps prevent unauthorized access to a network.

**Purpose**
- Prevent unauthorized devices
- Improve LAN security
- Prevents unauthorized devices from connecting
- Stops MAC flooding attacks
- Enhances Layer 2 security
- Useful in offices, campuses, and enterprise networks

```
Switch Port → Check MAC → Allow / Block
```


## Types of Violations
When an unauthorized device connects, the switch can respond in different ways:

#### Protect Mode
- Drops unknown MAC traffic
- No alert/log generated
#### Restrict Mode
**Drops traffic + sends alert**
- Drops traffic
- Logs the violation
- Sends alerts (SNMP trap)
#### Shutdown Mode (default)
**Port gets disabled**
- Disables the port completely
- Requires manual or automatic recovery



## Types Of Port Security
#### 1. Static MAC Addressing

**What it is:**
You manually configure which MAC addresses are allowed on a port.

**How it works:**

- The network admin enters specific MAC addresses into the switch config
- Only those devices are allowed
- Any other device → violation


#### 2. Dynamic MAC Addressing

**What it is:**
The switch automatically learns MAC addresses of connected devices.

**How it works:**

- First device connects → switch learns its MAC
- Stored in MAC address table (CAM table)
- If device disconnects or switch reboots → MAC is forgotten


#### 3. Sticky MAC Addressing

**What it is:**
A hybrid approach: automatically learns MAC addresses AND saves them in the configuration.

**How it works:**

- Device connects → MAC is learned automatically
- Switch “sticks” it into running config
- Can be saved permanently using write memory