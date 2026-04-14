
# Types of LAN 
1. SOHO LAN (Small office/Home office)
2. Enterprise LAN

```
┌─────────────────────────────────────────────────────────────────────────┐
│                                                                         │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│   ┌─────────────────────────────┐   ┌─────────────────────────────┐    │
│   │        SOHO TREE            │   │     ENTERPRISE MESH         │    │
│   ├─────────────────────────────┤   ├─────────────────────────────┤    │
│   │                             │   │                             │    │
│   │ • Small Office/Home Office  │   │ • Large Organizations       │    │
│   │ • 1-20 Users                │   │ • 100-10,000+ Users         │    │
│   │ • Hierarchical Structure    │   │ • Highly Redundant          │    │
│   │ • Router → Switch → Devices │   │ • Multiple Interconnections │    │
│   │ • Simple Star/Tree Design   │   │ • Data Center / Campus      │    │
│   │ • Budget-Friendly           │   │ • Maximum Availability      │    │
│   │ • Basic Redundancy          │   │ • Spine-Leaf / Full Mesh    │    │
│   │                             │   │                             │    │
│   └─────────────────────────────┘   └─────────────────────────────┘    │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

## SOHO 
```
┌─────────────────────────────────────────────────────────────────────────┐
│                    SOHO TREE NETWORK DIAGRAM                            │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│                            ┌─────────────┐                              │
│                            │  INTERNET   │                              │
│                            │    (ISP)    │                              │
│                            └──────┬──────┘                              │
│                                   │                                     │
│                            ┌──────┴──────┐                              │
│                            │    MODEM    │                              │
│                            └──────┬──────┘                              │
│                                   │                                     │
│   ════════════════════════════════════════════════════════════════     │
│   ║                     ROOT LEVEL                               ║     │
│   ════════════════════════════════════════════════════════════════     │
│                                   │                                     │
│                            ┌──────┴──────┐                              │
│                            │   ROUTER    │ ◄── Root Node               │
│                            │ (Gateway)   │     DHCP, NAT, Firewall     │
│                            │ 192.168.1.1 │     Wireless (optional)     │
│                            └──────┬──────┘                              │
│                                   │                                     │
│   ════════════════════════════════════════════════════════════════     │
│   ║                   BRANCH LEVEL                               ║     │
│   ════════════════════════════════════════════════════════════════     │
│                                   │                                     │
│              ┌────────────────────┼────────────────────┐                │
│              │                    │                    │                │
│       ┌──────┴──────┐      ┌──────┴──────┐      ┌──────┴──────┐        │
│       │  SWITCH 1   │      │  SWITCH 2   │      │   WIRELESS  │        │
│       │  (Office)   │      │  (Lab/Work) │      │     AP      │        │
│       │  8-Port     │      │  8-Port     │      │             │        │
│       └──────┬──────┘      └──────┬──────┘      └──────┬──────┘        │
│              │                    │                    │                │
│   ════════════════════════════════════════════════════════════════     │
│   ║                    LEAF LEVEL                                ║     │
│   ════════════════════════════════════════════════════════════════     │
│              │                    │                    │                │
│    ┌─────────┼─────────┐   ┌──────┼──────┐      ┌──────┴──────┐        │
│    │         │         │   │      │      │      │             │        │
│   🖥️        💻        🖨️  🖥️     🖥️    📷     📱    📱    💻       │
│  Desktop  Laptop  Printer Desktop Desktop Camera Phone  Phone Laptop   │
│                                          (PoE)                          │
│                                                                         │
│   IP Range: 192.168.1.0/24                                             │
│   DHCP Pool: 192.168.1.100 - 192.168.1.200                            │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

## Enterprise LAN
```
┌─────────────────────────────────────────────────────────────────────────┐
│                   ENTERPRISE MESH DEFINITION                            │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│   Enterprise Mesh = High-redundancy network topology for large          │
│                     organizations with multiple interconnections        │
│                                                                         │
│   Key Concepts:                                                         │
│   ══════════════                                                        │
│                                                                         │
│   • Every (or most) nodes connected to multiple other nodes            │
│   • Multiple paths for data to travel                                  │
│   • Eliminates single points of failure                                │
│   • Self-healing capability                                            │
│   • Used in data centers and campus backbones                          │
│                                                                         │
│   Types of Enterprise Mesh:                                             │
│   ═════════════════════════                                             │
│                                                                         │
│   ┌─────────────────────────────────────────────────────────────────┐  │
│   │                                                                 │  │
│   │   1. FULL MESH         - Every node connected to every other   │  │
│   │                          node (maximum redundancy)             │  │
│   │                                                                 │  │
│   │   2. PARTIAL MESH      - Strategic connections between         │  │
│   │                          critical nodes                        │  │
│   │                                                                 │  │
│   │   3. SPINE-LEAF        - Modern data center mesh design        │  │
│   │      (Clos Network)      (most common today)                   │  │
│   │                                                                 │  │
│   │   4. WIRELESS MESH     - Enterprise wireless with mesh         │  │
│   │      (Campus)            backhaul between APs                  │  │
│   │                                                                 │  │
│   └─────────────────────────────────────────────────────────────────┘  │
│                                                                         │
│   Where Used:                                                           │
│   ════════════                                                          │
│   • Data centers (spine-leaf)                                          │
│   • Campus network backbones                                           │
│   • Financial trading networks                                         │
│   • Healthcare critical systems                                        │
│   • Cloud infrastructure                                               │
│   • Service provider networks                                          │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```




# Switching
Switching is the process of forwarding data packets/frames from a source to a destination within a network(LAN). A switch is a network device that connects multiple devices and uses MAC addresses to forward data at Layer 2 (DATA LINK LAYER).

Switching is a Layer 2 (Data Link Layer) process where a network switch forwards frames based on MAC addresses. It creates a MAC address table (CAM table) dynamically by learning source MAC addresses on incoming frames.

```
┌─────────────────────────────────────────────────┐
│           SWITCHING BENEFITS                    │
├─────────────────────────────────────────────────┤
│ ✓ Dedicated bandwidth per port                  │
│ ✓ Full-duplex communication                     │
│ ✓ Each port = Separate collision domain         │
│ ✓ MAC address learning & filtering              │
│ ✓ Low latency & high speed                      │
│ ✓ Supports VLANs (network segmentation)         │
│ ✓ More secure than hubs                         │
└─────────────────────────────────────────────────┘
```
### Three Switch Functions at Layer 2:-

#### 1.Address learning - 
Layer 2 switches and bridges remember the source hardware address of each frame received on an interface, and they enter this information into a
MAC database called a forward/filter table.

#### 2.Forward/filter decisions - 
When a frame is received on an interface, the switch looks at the destination hardware address and finds the exit interface in the MAC database.
The frame is only forwarded out the specified destination port.

#### 3.Loop avoidance -
If multiple connections between switches are created for redundancy purposes, network loops can occur. Spanning Tree Protocol (STP) is
used to stop network loops while still permitting redundancy.
switch avoids loop by default STP protocol is enabled on the switch to avoid loop. STP keeps 1 link in the forwarding state and put all other link-blocking states to

### STP (Spanning Tree Protocol)
STP (Spanning Tree Protocol) is a Layer 2 protocol that **prevents loops** in a switched network.

**Works on: Switches**.

- It prevents loop by shutting down a line that's not needed or making a loop.
- A STP packet is generate every 10sec to check loop occurrence and prevent the loop by downing  the line and also up the line when needed.


___________________________________________


# Router Packet Switching Methods
These are methods used by routers (especially Cisco) to forward packets from source to destination.

![[Screenshot (98) 1.png]]
## 1. Process Switching

- Oldest and slowest method
- **Every packet processed by CPU**
- CPU handles all routing decisions


```
Packet Arrives
      ↓
CPU receives packet
      ↓
CPU looks up routing table
      ↓
CPU determines exit interface
      ↓
CPU forwards packet
      ↓
(Repeat for EVERY packet)
```

## 2. Fast Switching (Route Cache)


- Also called route-cache switching (called switch engine)
- First packet is process-switched
- Cache stores destination info for subsequent packets
- Open standard (not Cisco proprietary)

```
First Packet:
      ↓
Process switched (slow)
      ↓
Result stored in ROUTE CACHE
      ↓
Subsequent Packets:
      ↓
Check route cache
      ↓
Forward using cached info (fast)
```

##### Route Cache Structure
```
┌─────────────────┬──────────────┬─────────────┬─────────────┐
│  Destination IP │ Next-Hop IP  │ Interface   │ MAC Header  │
├─────────────────┼──────────────┼─────────────┼─────────────┤
│  192.168.1.0    │ 10.0.0.2     │ Gi0/1       │ AA:BB:CC... │
│  172.16.0.0     │ 10.0.0.3     │ Gi0/2       │ DD:EE:FF... │
└─────────────────┴──────────────┴─────────────┴─────────────┘
```

### RIB (Routing Information Base)(Routing Table)
**What is RIB?**

- Also called Routing Table
- Lives in Control Plane( in CPU )
- Contains all routes learned from various sources
- Maintained by CPU/Route Processor
- Selects best path based on administrative distance and metrics

### Routing Table
A **routing table** is a table inside a **router** that stores information about **where to send IP packets**.

The router checks this table to decide the **best path (next hop) to reach the destination network**.

---

#### What a Routing Table Contains

A routing table usually stores:

- **Destination Network**
- **Subnet Mask / Prefix**
- **Next Hop (Gateway)**
- **Outgoing Interface**
- **Metric (cost of route)**

---

##### Example Routing Table

```
Destination        Next Hop        Interface
------------------------------------------------
192.168.1.0/24     Direct          Gig0/0
10.0.0.0/24        192.168.1.2     Gig0/1
0.0.0.0/0          192.168.1.1     Gig0/0
```

---

#### Meaning of Each Entry

##### 1. Directly Connected Network
```
192.168.1.0/24 → Gig0/0
```

This means:

```
Router is directly connected to this network
Packets go directly out of Gig0/0
```

---

##### 2. Remote Network
```
10.0.0.0/24 → Next hop 192.168.1.2
```

This means:

```
Router must send packet to another router (192.168.1.2)
```

---

##### 3. Default Route
```
0.0.0.0/0 → 192.168.1.1
```

This means:

```
If router does not know the destination network,
send packet to this gateway (usually ISP)
```

---

### How Router Uses Routing Table

Example:

```
Packet destination: 10.0.0.5
```

Router checks routing table:

```
10.0.0.0/24 → Next hop 192.168.1.2
```

Router sends packet to **192.168.1.2**.

---

### Types of Routes in Routing Table

### 1. Connected Route
Automatically added when interface is configured.

Example:
```
C 192.168.1.0/24 is directly connected, Gig0/0
```

---

### 2. Static Route
Manually configured by administrator.

Example:
```
ip route 10.0.0.0 255.255.255.0 192.168.1.2
```

---

### 3. Dynamic Route
Learned automatically from routing protocols like:

- RIP
- OSPF
- EIGRP
- BGP

---

#### ==3. CEF Switching (Cisco Express Forwarding)==

- Fastest and most preferred method
- Cisco proprietary
- Uses pre-built tables
- Default on modern Cisco routers
##### Key Components
###### a) FIB (Forwarding Information Base)


- **Mirror of routing table (RIB) and Use it as FIB and store it in temporary memory like RAM (switch engine of switch) after shutdown of switch FIB is rested and again on first connect it clones RIB and store it in switch engine.**
- Optimized for fast lookup
-  **Lives in Data Plane (switch engine) or called RAM of switch**
- **Optimized copy of best routes from RIB**
- **Used for actual packet forwarding**
- Hardware-based lookups (ASIC/TCAM)
- Part of CEF (Cisco Express Forwarding)


```
┌─────────────────┬──────────────┬─────────────┐
│  Prefix/Network │ Next-Hop     │ Interface   │
├─────────────────┼──────────────┼─────────────┤
│  192.168.1.0/24 │ 10.0.0.2     │ Gi0/1       │
│  172.16.0.0/16  │ 10.0.0.3     │ Gi0/2       │
│  0.0.0.0/0      │ 10.0.0.1     │ Gi0/0       │
└─────────────────┴──────────────┴─────────────┘
```


###### b) Adjacency Table
Store Next-hop MAC address and Layer 2 details needed to forward packets.

```
┌──────────────┬───────────────────┬─────────────┐
│  Next-Hop IP │ Layer 2 Header    │ Interface   │
├──────────────┼───────────────────┼─────────────┤
│  10.0.0.2    │ AA:BB:CC:DD:EE:01 │ Gi0/1       │
│  10.0.0.3    │ AA:BB:CC:DD:EE:02 │ Gi0/2       │
└──────────────┴───────────────────┴─────────────┘
```


- Contains Layer 2 information

> [!NOTE]
> 
> >**Routing table tells:**
> “Where to send the packet (next IP)”
> 
>  >**Adjacency table tells:**
> “How to send it (MAC address, interface)”
> 

## Planes on Router / Traffic on Router 
![[Pasted image 20260129143417.png]]

