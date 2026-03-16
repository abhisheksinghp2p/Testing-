# VLAN
==A VLAN divides **ONE physical switch** into **MULTIPLE virtual switches**.==
A VLAN is a logical grouping of devices within the same broadcast domain. By default, a switch is one big broadcast domain. 

**Key Rule:**

- 1 VLAN = 1 Broadcast Domain = 1 Subnet.
- Traffic from VLAN 10 cannot go to VLAN 20 without a Router (Layer 3).

**Benefits:**
- **Security:** Sensitive HR data (VLAN 20) stays separate from Guest Wi-Fi (VLAN 50).
- **Performance:** Reduces broadcast traffic (broadcasts in VLAN 10 don't reach VLAN 20).
- **Organization:** Group users by department, not physical location.

1. **Separate Networks** - Different groups isolated
2. **Reduce Broadcast** - Broadcasts stay in their VLAN
3. **Security** - VLAN 10 cannot see VLAN 20 traffic
4. **Organization** - Group devices logically
5. **Performance** - Less unnecessary traffic

---

### Network Design

```
┌─────────────────────────────────────────────────────────────────┐
│                     WITHOUT VLAN                                │
│                                                                 │
│     All devices in ONE broadcast domain                        │
│                                                                 │
│    PC1 ──┐                                                      │
│    PC2 ──┼──── SWITCH ────┼── PC5                               │
│    PC3 ──┤                ├── PC6                               │
│    PC4 ──┘                └── PC7                               │
│                                                                 │
│    ⚠ Broadcast from PC1 reaches ALL devices!                   │
│    ⚠ No separation between departments                         │
│    ⚠ Security issues                                           │
└─────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│                      WITH VLAN                                  │
│                                                                 │
│    VLAN 10 (HR)          │         VLAN 20 (IT)                 │
│    ┌─────────────┐       │       ┌─────────────┐                │
│    │ PC1         │       │       │ PC5         │                │
│    │ PC2         │───────┼───────│ PC6         │                │
│    │ PC3         │  SWITCH       │ PC7         │                │
│    └─────────────┘       │       └─────────────┘                │
│                          │                                      │
│    ✓ Separate broadcast domains                                 │
│    ✓ Logical separation                                        │
│    ✓ Better security                                           │
└─────────────────────────────────────────────────────────────────┘
```

![[Screenshot (102).png]]

## Configuration of 3 Different VLANs

### Network Design

```
          [SWITCH]
     /      |      \
 VLAN 10  VLAN 20  VLAN 30
 Group A  Group B  Group C
```

### VLAN 10 Configuration

- VLAN ID: 10
- VLAN Name: GROUP_A
- Network: 192.168.10.0/24
- Subnet Mask: 255.255.255.0
- Gateway: 192.168.10.1
- First Usable IP: 192.168.10.2
- Last Usable IP: 192.168.10.254
- Broadcast Address: 192.168.10.255
- Total Hosts: 254


### VLAN 20 Configuration

- VLAN ID: 20
- VLAN Name: GROUP_B
- Network: 192.168.20.0/24
- Subnet Mask: 255.255.255.0
- Gateway: 192.168.20.1
- First Usable IP: 192.168.20.2
- Last Usable IP: 192.168.20.254
- Broadcast Address: 192.168.20.255
- Total Hosts: 254


### VLAN 30 Configuration

- VLAN ID: 30
- VLAN Name: GROUP_C
- Network: 192.168.30.0/24
- Subnet Mask: 255.255.255.0
- Gateway: 192.168.30.1
- First Usable IP: 192.168.30.2
- Last Usable IP: 192.168.30.254
- Broadcast Address: 192.168.30.255
- Total Hosts: 254

---

## 💻 Switch Configuration Commands

### Step 1: Create VLANs on Switch
```cisco
Switch# configure terminal

Create VLAN 10
Switch(config)# vlan 10
Switch(config-vlan)# name GROUP_A
Switch(config-vlan)# exit

Create VLAN 20
Switch(config)# vlan 20
Switch(config-vlan)# name GROUP_B
Switch(config-vlan)# exit

Create VLAN 30
Switch(config)# vlan 30
Switch(config-vlan)# name GROUP_C
Switch(config-vlan)# exit
```


### Step 2: Assign Ports to VLANs
```
! Put Port 1-5 in VLAN 10
Switch(config)# interface range FastEthernet 0/1-5
Switch(config-if-range)# switchport mode access
Switch(config-if-range)# switchport access vlan 10
Switch(config-if-range)# exit

! Put Port 6-10 in VLAN 20
Switch(config)# interface range FastEthernet 0/6-10
Switch(config-if-range)# switchport mode access
Switch(config-if-range)# switchport access vlan 20
Switch(config-if-range)# exit

! Put Port 11-15 in VLAN 30
Switch(config)# interface range FastEthernet 0/11-15
Switch(config-if-range)# switchport mode access
Switch(config-if-range)# switchport access vlan 30
Switch(config-if-range)# exit
```

### Step 3: Verify Configuration
```
! Show all VLANs
Switch# show vlan brief

VLAN Name                     Status    Ports
---- ------------------------ --------- -----------------
1    default                  active    Fa0/16-24
10   GROUP_A                  active    Fa0/1-5
20   GROUP_B                  active    Fa0/6-10
30   GROUP_C                  active    Fa0/11-15

! Show specific port
Switch# show interface Fa0/1 switchport
Administrative Mode: access
Operational Mode: access
Access Mode VLAN: 10 (GROUP_A)
```

```
                    [SWITCH]
         ┌─────────────┼─────────────┐
         │             │             │
      VLAN 10       VLAN 20       VLAN 30
   192.168.10.0   192.168.20.0   192.168.30.0
         │             │             │
    ┌────┼────┐   ┌────┼────┐   ┌────┼────┐
    │    │    │   │    │    │   │    │    │
   PC1  PC2  PC3 PC4  PC5  PC6 PC7  PC8  PC9
    ↓    ↓    ↓   ↓    ↓    ↓   ↓    ↓    ↓
  .10  .11  .12 .10  .11  .12 .10  .11  .12

Device Details:
┌──────┬─────────┬──────────────────┬─────────────────┐
│Device│  VLAN   │    IP Address    │  Broadcast      │
├──────┼─────────┼──────────────────┼─────────────────┤
│ PC1  │ VLAN 10 │ 192.168.10.10    │ 192.168.10.255  │
│ PC2  │ VLAN 10 │ 192.168.10.11    │ 192.168.10.255  │
│ PC3  │ VLAN 10 │ 192.168.10.12    │ 192.168.10.255  │
├──────┼─────────┼──────────────────┼─────────────────┤
│ PC4  │ VLAN 20 │ 192.168.20.10    │ 192.168.20.255  │
│ PC5  │ VLAN 20 │ 192.168.20.11    │ 192.168.20.255  │
│ PC6  │ VLAN 20 │ 192.168.20.12    │ 192.168.20.255  │
├──────┼─────────┼──────────────────┼─────────────────┤
│ PC7  │ VLAN 30 │ 192.168.30.10    │ 192.168.30.255  │
│ PC8  │ VLAN 30 │ 192.168.30.11    │ 192.168.30.255  │
│ PC9  │ VLAN 30 │ 192.168.30.12    │ 192.168.30.255  │
└──────┴─────────┴──────────────────┴─────────────────┘
```






## Access Port vs Trunk Port
### Access Port
```
┌─────────────────────────────────────────────────────────────────┐
│                        ACCESS PORT                              │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  • Belongs to ONE VLAN only                                     │
│  • Connects to end devices (PC, Printer, Phone)                │
│  • Frames are UNTAGGED                                          │
│  • Switch adds/removes VLAN tag internally                      │
│                                                                 │
│       PC                    SWITCH                              │
│    ┌──────┐              ┌─────────┐                            │
│    │      │──────────────│ Port 1  │                            │
│    │      │  Untagged    │ VLAN 10 │                            │
│    └──────┘   Frame      │ (Access)│                            │
│                          └─────────┘                            │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### Trunk Port
```
┌─────────────────────────────────────────────────────────────────┐
│                        TRUNK PORT                               │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  • Carries MULTIPLE VLANs                                       │
│  • Connects switches together                                   │
│  • Frames are TAGGED with 802.1Q                                │
│  • Native VLAN frames are untagged                              │
│                                                                 │
│    SWITCH 1                              SWITCH 2               │
│   ┌─────────┐                          ┌─────────┐              │
│   │         │ ════════════════════════ │         │              │
│   │  Trunk  │   Tagged Frames          │  Trunk  │              │
│   │  Port   │   VLAN 10,20,30          │  Port   │              │
│   └─────────┘                          └─────────┘              │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

```
┌─────────────────────────────────────────────────────────────────────────┐
│                    COMPLETE VLAN TOPOLOGY                               │
└─────────────────────────────────────────────────────────────────────────┘

                         TRUNK LINK
                    (Carries VLAN 10,20,30)
                    
   ┌──────────────────┐         ┌──────────────────┐
   │     SWITCH 1     │═════════│     SWITCH 2     │
   │                  │  Tagged │                  │
   │  Fa0/24 (Trunk)  │ Frames  │  Fa0/24 (Trunk)  │
   └────────┬─────────┘         └────────┬─────────┘
            │                            │
   ┌────────┼────────┐          ┌────────┼────────┐
   │        │        │          │        │        │
 Fa0/1   Fa0/2    Fa0/3      Fa0/1    Fa0/2    Fa0/3
(Access) (Access) (Access)  (Access) (Access) (Access)
VLAN 10  VLAN 20  VLAN 30   VLAN 10  VLAN 20  VLAN 30
   │        │        │          │        │        │
   │        │        │          │        │        │
┌──┴──┐  ┌──┴──┐  ┌──┴──┐   ┌──┴──┐  ┌──┴──┐  ┌──┴──┐
│PC-A │  │PC-B │  │PC-C │   │PC-D │  │PC-E │  │PC-F │
│ HR  │  │ IT  │  │Sales│   │ HR  │  │ IT  │  │Sales│
└─────┘  └─────┘  └─────┘   └─────┘  └─────┘  └─────┘

   VLAN 10 (HR)    : PC-A, PC-D     ← Can communicate
   VLAN 20 (IT)    : PC-B, PC-E     ← Can communicate  
   VLAN 30 (Sales) : PC-C, PC-F     ← Can communicate
```

## VLAN Header (802.1Q Tag)
When frames travel on a trunk link, they need a VLAN tag to identify which VLAN they belong to.

```
┌──────────────────────────────────────────────────────────────────────────┐
│                     802.1Q TAGGED FRAME                                  │
├────────────┬────────────┬──────────────┬──────────┬───────────┬─────────┤
│  Dest MAC  │  Src MAC   │  802.1Q Tag  │  Type    │   Data    │   FCS   │
│  (6 bytes) │  (6 bytes) │  (4 bytes)   │ (2 bytes)│ (46-1500) │(4 bytes)│
└────────────┴────────────┴──────┬───────┴──────────┴───────────┴─────────┘
                                 │
                    ┌────────────┴────────────┐
                    │     802.1Q TAG DETAIL   │
                    └────────────┬────────────┘
                                 ▼
┌─────────────────────────────────────────────────────────────────────────┐
│                        4-BYTE 802.1Q TAG                                │
├─────────────────────┬─────────────────────────────────────────────────┤
│        TPID         │                   TCI                            │
│     (16 bits)       │               (16 bits)                          │
│      0x8100         │                                                  │
├─────────────────────┼───────────┬─────────────┬───────────────────────┤
│                     │  Priority │     CFI     │       VLAN ID         │
│     Tag Protocol    │  (3 bits) │   (1 bit)   │      (12 bits)        │
│     Identifier      │   PCP     │   DEI       │     1 - 4094          │
└─────────────────────┴───────────┴─────────────┴───────────────────────┘
```

### Inter-VLAN Communication
#### VLANs Can't Talk Directly
```
┌────────────────────────────────────────────────────────────────────────────┐
│                     WHY VLANs CAN'T COMMUNICATE?                           │
├────────────────────────────────────────────────────────────────────────────┤
│                                                                            │
│   VLAN = Separate Broadcast Domain = Separate Network                     │
│                                                                            │
│   ┌─────────────┐                              ┌─────────────┐             │
│   │   VLAN 10   │           ✖                  │   VLAN 20   │             │
│   │  (Network A)│◄──────── BLOCKED ───────────►│  (Network B)│             │
│   │             │                              │             │             │
│   │    PC-A     │      Layer 2 Switch          │    PC-C     │             │
│   │ 192.168.10.10│     can't route!            │192.168.20.10│             │
│   └─────────────┘                              └─────────────┘             │
│                                                                            │
│   SOLUTION: Need Layer 3 Device (Router or L3 Switch)                      │
│                                                                            │
└────────────────────────────────────────────────────────────────────────────┘
```

#### Network Topology
```
┌────────────────────────────────────────────────────────────────────────────┐
│                         NETWORK SETUP                                      │
└────────────────────────────────────────────────────────────────────────────┘

                              ┌─────────────────────┐
                              │       ROUTER        │
                              │  (Layer 3 Device)   │
                              │                     │
                              │   Fa0/0 (Trunk)     │
                              │        │            │
                              │   ┌────┴────┐       │
                              │   │         │       │
                              │ Fa0/0.10  Fa0/0.20  │
                              │ VLAN 10   VLAN 20   │
                              │ .10.1     .20.1     │
                              │ MAC:R1    MAC:R2    │
                              └─────────┬───────────┘
                                        │
                                   Trunk Link
                                  (VLAN 10,20)
                                        │
                              ┌─────────┴───────────┐
                              │       SWITCH        │
                              │                     │
                              │   Fa0/24 (Trunk)    │
                              │                     │
                              │  Fa0/1      Fa0/2   │
                              │ (VLAN 10)  (VLAN 20)│
                              └───┬───────────┬─────┘
                                  │           │
                                  │           │
                         ┌────────┴──┐   ┌────┴───────┐
                         │   PC-A    │   │    PC-C    │
                         │  VLAN 10  │   │   VLAN 20  │
                         │           │   │            │
                         │IP: .10.10 │   │ IP: .20.10 │
                         │MAC: AA:AA │   │ MAC: CC:CC │
                         │GW: .10.1  │   │ GW: .20.1  │
                         └───────────┘   └────────────┘
```

#### example
 **PC-A (VLAN 10) Pings PC-C (VLAN 20)**
```
┌────────────────────────────────────────────────────────────────────────────┐
│  STEP 1: IS DESTINATION LOCAL OR REMOTE?                                   │
├────────────────────────────────────────────────────────────────────────────┤
│                                                                            │
│  PC-A wants to ping 192.168.20.10                                          │
│                                                                            │
│  ┌────────────────────────────────────────────────────────────────────────┐│
│  │  PC-A calculates:                                                      ││
│  │                                                                        ││
│  │  My IP      : 192.168.10.10                                            ││
│  │  My Mask    : 255.255.255.0                                            ││
│  │  My Network : 192.168.10.0                                             ││
│  │                                                                        ││
│  │  Destination: 192.168.20.10                                            ││
│  │  Dest Network: 192.168.20.0                                            ││
│  │                                                                        ││
│  │  192.168.10.0 ≠ 192.168.20.0                                           ││
│  │                                                                        ││
│  │  ╔════════════════════════════════════════════════════════════════╗    ││
│  │  ║  RESULT: DIFFERENT NETWORK → Send to DEFAULT GATEWAY!          ║    ││
│  │  ║  Gateway = 192.168.10.1                                        ║    ││
│  │  ╚════════════════════════════════════════════════════════════════╝    ││
│  └────────────────────────────────────────────────────────────────────────┘│
│                                                                            │
│  KEY: PC-A will send packet to ROUTER, not directly to PC-C               │
│                                                                            │
└────────────────────────────────────────────────────────────────────────────┘
```


# DHCP (Dynamic Host Configuration Protocol) 
DHCP automatically assigns IP addresses and network configuration to devices.

DHCP (Dynamic Host Configuration Protocol) is a protocol that automatically assigns IP addresses, Subnet Masks, Gateways, and DNS servers to clients so they can communicate on the network.

```
┌─────────────────────────────────────────────────────────────────┐
│                    DHCP OVERVIEW                                │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  Protocol        : DHCP                                         │
│  Layer           : Application Layer (Layer 7)                  │
│  Transport       : UDP                                          │
│  Server Port     : 67   -----|  >  (Always                      │
│  Client Port     : 68   -----|  >     fix)                      │
│  Message Type    : Broadcast (initially)                        │
│                                                                 │
│  DHCP Provides:                                                 │
│    ✓ IP Address                                                 │
│    ✓ Subnet Mask                                                │
│    ✓ Default Gateway                                            │
│    ✓ DNS Server                                                 │
│    ✓ Lease Time                                                 │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

## DORA (Discover → Offer → Request → Acknowledge)

## DORA Process in VLAN

**PC-A (VLAN 10) requests IP from DHCP Server**
```
INITIAL STATE:
═════════════

PC-A (VLAN 10)
┌────────────────────────────┐
│ IP Address    : 0.0.0.0    │
│ MAC Address   : AA:AA:AA:AA│
│ Gateway       : None       │
│ VLAN          : 10         │
└────────────────────────────┘

Router Sub-interfaces:
┌────────────────────────────┐
│ Fa0/1.10 : 192.168.10.1    │ ← VLAN 10 Gateway
│            ip helper: 192.168.100.10
│                            │
│ Fa0/1.20 : 192.168.20.1    │ ← VLAN 20 Gateway
│            ip helper: 192.168.100.10
└────────────────────────────┘

DHCP Server:
┌────────────────────────────┐
│ IP: 192.168.100.10         │
│                            │
│ Pool VLAN10:               │
│   Network: 192.168.10.0/24 │
│   Range: .10 - .100        │
│   Gateway: 192.168.10.1    │
│                            │
│ Pool VLAN20:               │
│   Network: 192.168.20.0/24 │
│   Range: .10 - .100        │
│   Gateway: 192.168.20.1    │
└────────────────────────────┘
```

```
┌─────────────────────────────────────────────────────────────────┐
│                                                                 │
│   PC-A ◄────► SWITCH ◄────► ROUTER ◄────► DHCP SERVER          │
│  (VLAN 10)            (Relay Agent)      (192.168.100.10)      │
│  No IP yet            192.168.10.1                              │
│                       (ip helper-address 192.168.100.10)        │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

```
┌────────────────────────────────────────────────────────────────────────────┐
│                          DORA FLOW                                         │
├────────────────────────────────────────────────────────────────────────────┤
│                                                                            │
│    CLIENT                     ROUTER                      SERVER           │
│   (Port 68)                  (Relay)                    (Port 67)          │
│      │                          │                           │              │
│      │ ═══════ DISCOVER ═══════►│ ─────── DISCOVER ────────►│              │
│      │   Broadcast (68→67)      │   Unicast + GIADDR        │              │
│      │                          │                           │              │
│      │ ◄═══════ OFFER ══════════│ ◄─────── OFFER ───────────│              │
│      │   Broadcast (67→68)      │   Unicast to GIADDR       │              │
│      │                          │                           │              │
│      │ ═══════ REQUEST ════════►│ ─────── REQUEST ─────────►│              │
│      │   Broadcast (68→67)      │   Unicast + GIADDR        │              │
│      │                          │                           │              │
│      │ ◄═══════ ACK ════════════│ ◄─────── ACK ─────────────│              │
│      │   Broadcast (67→68)      │   Unicast to GIADDR       │              │
│      │                          │                           │              │
│      ▼                          │                           │              │
│  GOT IP!                        │                           │              │
│                                                                            │
└────────────────────────────────────────────────────────────────────────────┘
```
### 1: DISCOVER 
```
┌────────────────────────────────────────────────────────────────────────────┐
│  STEP 1: DISCOVER - "I need an IP!"                                        │
├────────────────────────────────────────────────────────────────────────────┤
│                                                                            │
│  WHO SENDS  : Client (PC-A)                                                │
│  TYPE       : BROADCAST                                                    │
│  DIRECTION  : Client → Server                                              │
│                                                                            │
│  ┌────────────────────────────────────────────────────────────────────────┐│
│  │  LAYER 2:  Src MAC: AAAA.AAAA │ Dst MAC: FFFF.FFFF (Broadcast)        ││
│  │  LAYER 3:  Src IP : 0.0.0.0   │ Dst IP : 255.255.255.255              ││
│  │  LAYER 4:  Src Port: 68       │ Dst Port: 67                          ││
│  │  DHCP:     GIADDR: 0.0.0.0    │ Message: DISCOVER                     ││
│  └────────────────────────────────────────────────────────────────────────┘│
│                                                                            │
│  AFTER RELAY:                                                              │
│  ┌────────────────────────────────────────────────────────────────────────┐│
│  │  LAYER 3:  Src IP : 192.168.100.1 │ Dst IP : 192.168.100.10 (Unicast) ││
│  │  LAYER 4:  Src Port: 67           │ Dst Port: 67                      ││
│  │  DHCP:     GIADDR: 192.168.10.1   │ Client MAC: AAAA.AAAA (preserved) ││
│  └────────────────────────────────────────────────────────────────────────┘│
│                                                                            │
│  KEY: Router adds GIADDR = 192.168.10.1 (tells server which subnet)        │
│                                                                            │
└────────────────────────────────────────────────────────────────────────────┘
```

### 2: OFFER 
```
┌────────────────────────────────────────────────────────────────────────────┐
│  STEP 2: OFFER - "Here's 192.168.10.10 for you!"                           │
├────────────────────────────────────────────────────────────────────────────┤
│                                                                            │
│  WHO SENDS  : Server                                                       │
│  TYPE       : UNICAST (to Router) → BROADCAST (to Client)                  │
│  DIRECTION  : Server → Client                                              │
│                                                                            │
│  SERVER LOGIC:                                                             │
│  ┌────────────────────────────────────────────────────────────────────────┐│
│  │  "GIADDR = 192.168.10.1 → Client is in 192.168.10.0/24 network"       ││
│  │  "Use VLAN10 pool → Assign 192.168.10.10"                             ││
│  └────────────────────────────────────────────────────────────────────────┘│
│                                                                            │
│  PACKET:                                                                   │
│  ┌────────────────────────────────────────────────────────────────────────┐│
│  │  LAYER 3:  Src IP : 192.168.100.10  │ Dst IP : 192.168.10.1 (GIADDR)  ││
│  │  LAYER 4:  Src Port: 67             │ Dst Port: 68                    ││
│  │  DHCP:     YIADDR: 192.168.10.10    │ Message: OFFER                  ││
│  │                                                                        ││
│  │  OPTIONS:  Subnet Mask    : 255.255.255.0                             ││
│  │            Default Gateway: 192.168.10.1                              ││
│  │            DNS Server     : 8.8.8.8                                   ││
│  │            Lease Time     : 86400 sec (24 hours)                      ││
│  └────────────────────────────────────────────────────────────────────────┘│
│                                                                            │
│  KEY: YIADDR = "Your IP Address" = IP offered to client                    │
│                                                                            │
└────────────────────────────────────────────────────────────────────────────┘
```

### 3: REQUEST
```
┌────────────────────────────────────────────────────────────────────────────┐
│  STEP 3: REQUEST - "Yes! I want 192.168.10.10!"                            │
├────────────────────────────────────────────────────────────────────────────┤
│                                                                            │
│  WHO SENDS  : Client (PC-A)                                                │
│  TYPE       : BROADCAST (informs ALL servers)                              │
│  DIRECTION  : Client → Server                                              │
│                                                                            │
│  PACKET:                                                                   │
│  ┌────────────────────────────────────────────────────────────────────────┐│
│  │  LAYER 3:  Src IP : 0.0.0.0   │ Dst IP : 255.255.255.255              ││
│  │  LAYER 4:  Src Port: 68       │ Dst Port: 67                          ││
│  │  DHCP:     Requested IP : 192.168.10.10                               ││
│  │            Server ID    : 192.168.100.10                              ││
│  │            Message      : REQUEST                                     ││
│  └────────────────────────────────────────────────────────────────────────┘│
│                                                                            │
│  WHY BROADCAST?                                                            │
│  ┌────────────────────────────────────────────────────────────────────────┐│
│  │  • Inform chosen server: "I accept your offer"                        ││
│  │  • Inform other servers: "Release your offers"                        ││
│  │  • Client STILL has no IP (Src IP = 0.0.0.0)                          ││
│  └────────────────────────────────────────────────────────────────────────┘│
│                                                                            │
│  KEY: Contains Requested IP + Server Identifier                            │
│                                                                            │
└────────────────────────────────────────────────────────────────────────────┘
```

### 4: ACK
```
┌────────────────────────────────────────────────────────────────────────────┐
│  STEP 4: ACK - "Confirmed! 192.168.10.10 is yours!"                        │
├────────────────────────────────────────────────────────────────────────────┤
│                                                                            │
│  WHO SENDS  : Server                                                       │
│  TYPE       : UNICAST (to Router) → BROADCAST (to Client)                  │
│  DIRECTION  : Server → Client                                              │
│                                                                            │
│  PACKET:                                                                   │
│  ┌────────────────────────────────────────────────────────────────────────┐│
│  │  LAYER 3:  Src IP : 192.168.100.10  │ Dst IP : 192.168.10.1 (GIADDR)  ││
│  │  LAYER 4:  Src Port: 67             │ Dst Port: 68                    ││
│  │  DHCP:     YIADDR: 192.168.10.10    │ Message: ACK                    ││
│  │                                                                        ││
│  │  OPTIONS:  Subnet Mask    : 255.255.255.0                             ││
│  │            Default Gateway: 192.168.10.1                              ││
│  │            DNS Server     : 8.8.8.8                                   ││
│  │            Lease Time     : 86400 sec                                 ││
│  └────────────────────────────────────────────────────────────────────────┘│
│                                                                            │
│  RESULT - PC-A CONFIGURED:                                                 │
│  ┌────────────────────────────────────────────────────────────────────────┐│
│  │  IP Address     : 192.168.10.10                                       ││
│  │  Subnet Mask    : 255.255.255.0                                       ││
│  │  Default Gateway: 192.168.10.1                                        ││
│  │  DNS Server     : 8.8.8.8                                             ││
│  └────────────────────────────────────────────────────────────────────────┘│
│                                                                            │
│  KEY: Server records binding (MAC ↔ IP) in database                        │
│                                                                            │
└────────────────────────────────────────────────────────────────────────────┘
```

### Summary
```
┌────────────────────────────────────────────────────────────────────────────┐
│                         MUST REMEMBER                                      ��
├────────────────────────────────────────────────────────────────────────────┤
│                                                                            │
│  PORTS:                                                                    │
│  ───────                                                                   │
│    • Port 67 = DHCP Server (bootps)                                        │
│    • Port 68 = DHCP Client (bootpc)                                        │
│    • Client→Server: 68→67  │  Server→Client: 67→68                         │
│                                                                            │
│  MESSAGE TYPES:                                                            │
│  ──────────────                                                            │
│    • D & R = Client sends = BROADCAST (Src IP = 0.0.0.0)                   │
│    • O & A = Server sends = UNICAST to GIADDR                              │
│                                                                            │
│  RELAY AGENT (ip helper-address):                                          │
│  ─────────────────────────────────                                         │
│    • Converts Broadcast → Unicast                                          │
│    • Adds GIADDR (Router's interface IP)                                   │
│    • GIADDR tells server which pool to use                                 │
│                                                                            │
│  IMPORTANT FIELDS:                                                         │
│  ─────────────────                                                         │
│    • GIADDR = Gateway IP Address (added by relay)                          │
│    • YIADDR = Your IP Address (offered/assigned IP)                        │
│    • CHADDR = Client Hardware Address (MAC)                                │
│                                                                            │
│  CLIENT IP:                                                                │
│  ──────────                                                                │
│    • DISCOVER: Src IP = 0.0.0.0 (no IP yet)                                │
│    • REQUEST : Src IP = 0.0.0.0 (still not confirmed)                      │
│    • After ACK: Client uses assigned IP                                    │
│                                                                            │
└────────────────────────────────────────────────────────────────────────────┘
```

# VTP (VLAN Trunking Protocol)
```
┌────────────────────────────────────────────────────────────────────────────┐
│                           VTP OVERVIEW                                     │
├────────────────────────────────────────────────────────────────────────────┤
│                                                                            │
│  VTP = VLAN Trunking Protocol                                              │
│                                                                            │
│  PURPOSE: Automatically synchronize VLAN information across all switches   │
│                                                                            │
│  ┌────────────────────────────────────────────────────────────────────────┐│
│  │  WITHOUT VTP:                                                          ││
│  │  ─────────────                                                         ││
│  │    • Create VLAN 10 on Switch 1                                        ││
│  │    • Manually create VLAN 10 on Switch 2                               ││
│  │    • Manually create VLAN 10 on Switch 3                               ││
│  │    • Manually create VLAN 10 on Switch 4...                            ││
│  │    • 100 switches = 100 times manual configuration! 😫                 ││
│  │                                                                         ││
│  ├────────────────────────────────────────────────────────────────────────┤│
│  │  WITH VTP:                                                             ││
│  │  ──────────                                                            ││
│  │    • Create VLAN 10 on VTP Server                                      ││
│  │    • ALL switches automatically learn VLAN 10! ✅                      ││
│  │    • 100 switches = 1 time configuration! 😊                           ││
│  └────────────────────────────────────────────────────────────────────────┘│
│                                                                            │
│  CISCO PROPRIETARY: Works only on Cisco switches                           │
│  LAYER 2 PROTOCOL: Works over trunk links                                  │
│                                                                            │
└────────────────────────────────────────────────────────────────────────────┘
```

**VTP is Used to create multiple VLAN (1-1000)**
**Its Require Layer 3 switch which has 64 Ports so we can connect 64 layer 2 switch and Layer 2 switch has 24 ports to connect n device this how we can create 1000 VLAN.**
**We have to configure VLANs on Layer 3 switch only.**

![[Screenshot (103).png]]


# Ether Channel 
Bundles multiple physical links into one logical link for increased bandwidth & redundancy

```
┌────────────────────────────────────────────────────────────────────────────┐
│                      ETHERCHANNEL OVERVIEW                                 │
├────────────────────────────────────────────────────────────────────────────┤
│                                                                            │
│  EtherChannel = Bundle multiple physical links into ONE logical link       │
│                                                                            │
│  Also Known As:                                                            │
│    • Port Channel                                                          │
│    • Link Aggregation                                                      │
│    • LAG (Link Aggregation Group)                                          │
│    • NIC Teaming (on servers)                                              │
│                                                                            │
│                                                                            │
│  WITHOUT ETHERCHANNEL:                    WITH ETHERCHANNEL:               │
│  ─────────────────────                    ──────────────────               │
│                                                                            │
│   Switch A        Switch B               Switch A        Switch B          │
│   ┌──────┐        ┌──────┐               ┌──────┐        ┌──────┐          │
│   │      │━━━━━━━━│      │               │      │────────│      │          │
│   │      │╳╳╳╳╳╳╳╳│      │  Blocked      │      │════════│      │  Single  │
│   │      │╳╳╳╳╳╳╳╳│      │  by STP!      │      │────────│      │  Logical │
│   │      │╳╳╳╳╳╳╳╳│      │               │      │────────│      │  Link!   │
│   └──────┘        └──────┘               └──────┘        └──────┘          │
│                                                                            │
│   4 links = 1 Gbps usable                4 links = 4 Gbps usable!          │
│   (3 blocked by STP)                     (All active)                      │
│                                                                            │
└────────────────────────────────────────────────────────────────────────────┘
```

```
┌────────────────────────────────────────────────────────────────────────────┐
│                   THE SOLUTION - ETHERCHANNEL                              │
├────────────────────────────────────────────────────────────────────────────┤
│                                                                            │
│         SWITCH A                              SWITCH B                     │
│        ┌────────┐                            ┌────────┐                    │
│        │        │  Gi0/1 ─────────────Gi0/1  │        │                    │
│        │        │  Gi0/2 ═════════════Gi0/2  │        │                    │
│        │   Po1  │  Gi0/3 ─────────────Gi0/3  │  Po1   │                    │
│        │        │  Gi0/4 ═════════════Gi0/4  │        │                    │
│        └────────┘         ▲                  └────────┘                    │
│                           │                                                │
│                    Port-Channel 1                                          │
│                  (Single Logical Link)                                     │
│                                                                            │
│                                                                            │
│  HOW IT WORKS:                                                             │
│  ┌────────────────────────────────────────────────────────────────────────┐│
│  │                                                                        ││
│  │  • 4 physical links bundled into 1 logical link (Port-Channel 1)      ││
│  │  • STP sees only ONE link → No blocking!                               ││
│  │  • All 4 links actively forward traffic                                ││
│  │  • Traffic load-balanced across all links                              ││
│  │                                                                        ││
│  │  RESULT:                                                               ││
│  │    • 4 x 1 Gbps = 4 Gbps total bandwidth! ✅                           ││
│  │    • Built-in redundancy (if 1 link fails, others continue)           ││
│  │    • No STP blocking                                                   ││
│  │                                                                        ││
│  └────────────────────────────────────────────────────────────────────────┘│
│                                                                            │
└────────────────────────────────────────────────────────────────────────────┘
```


