




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



