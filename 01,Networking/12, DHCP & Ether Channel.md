




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



## 1. The Problem — Why We Need EtherChannel

### Without EtherChannel:

```
  What if ONE link between switches is not enough bandwidth?

  ┌──────────┐    100 Mbps     ┌──────────┐
  │   SW1    │════════════════ │   SW2    │
  │          │    Fa0/24       │          │
  │ 24 PCs   │                 │ 24 PCs   │
  └──────────┘                 └──────────┘

  Problem: 48 PCs sharing ONE 100 Mbps link = SLOW! 🐢
```

### Can We Just Add More Cables?

```
  ❌ WRONG — Just adding cables:

  ┌──────────┐    Fa0/21      ┌──────────┐
  │   SW1    │════════════════│   SW2    │
  │          │    Fa0/22      │          │
  │          │════════════════│          │
  │          │    Fa0/23      │          │
  │          │════════════════│          │
  │          │    Fa0/24      │          │
  │          │════════════════│          │
  └──────────┘                └──────────┘

  4 cables connected but...

  ⚠️ STP (Spanning Tree Protocol) will BLOCK 3 links!
  ⚠️ Only 1 link will be active!
  ⚠️ Other 3 links = WASTED! 😱
```

```
  What actually happens:

  ┌──────────┐    Fa0/21  ❌ BLOCKED     ┌──────────┐
  │   SW1    │════════════════════════════│   SW2    │
  │          │    Fa0/22  ❌ BLOCKED     │          │
  │          │════════════════════════════│          │
  │          │    Fa0/23  ❌ BLOCKED     │          │
  │          │════════════════════════════│          │
  │          │    Fa0/24  ✅ ACTIVE       │          │
  │          │════════════════════════════│          │
  └──────────┘                           └──────────┘

  WHY? Because STP prevents loops!
  STP sees 4 links = possible loop = blocks 3!
```

---

## 2. What is EtherChannel? — The Solution

```
  EtherChannel = Bundle multiple physical links into ONE logical link

  ┌──────────┐                           ┌──────────┐
  │   SW1    │    Fa0/21  ┐              │   SW2    │
  │          │════════════│              │          │
  │          │    Fa0/22  │  ONE         │          │
  │          │════════════├─ LOGICAL ════│          │
  │          │    Fa0/23  │  LINK        │          │
  │          │════════════│  (Port       │          │
  │          │    Fa0/24  ┘  Channel 1)  │          │
  │          │════════════│              │          │
  └──────────┘                           └──────────┘

  STP sees ONE link (not 4) = No blocking! ✅
  Bandwidth = 4 x 100 Mbps = 400 Mbps!    ✅
```

> **Simple Definition:**
> EtherChannel combines 2 to 8 physical links into 1 logical link.

### Also Known As:

| Name                   | Used By                 |
| ---------------------- | ----------------------- |
| EtherChannel           | Cisco                   |
| Port Channel           | Cisco                   |
| Link Aggregation (LAG) | Industry Standard       |
| NIC Teaming            | Servers (Windows/Linux) |
| Bond                   | Linux                   |

---

## 3. Benefits of EtherChannel

```
  ┌──────────────────────────────────────────────────────────┐
  │                                                          │
  │  ✅ More Bandwidth     4 x 100 Mbps = 400 Mbps          │
  │                        4 x 1 Gbps   = 4 Gbps            │
  │                        8 x 1 Gbps   = 8 Gbps (max)      │
  │                                                          │
  │  ✅ No STP Blocking    STP sees 1 link = no blocking    │
  │                                                          │
  │  ✅ Redundancy         If 1 link fails, others work     │
  │                        No downtime!                      │
  │                                                          │
  │  ✅ Load Balancing     Traffic spread across all links   │
  │                                                          │
  └──────────────────────────────────────────────────────────┘
```

### Redundancy Example:

```
  Normal: All 4 links working

  ┌──────┐  ════  ┌──────┐
  │ SW1  │  ════  │ SW2  │    Total: 400 Mbps ✅
  │      │  ════  │      │
  │      │  ════  │      │
  └──────┘        └──────┘


  1 link fails:

  ┌──────┐  ════  ┌──────┐
  │ SW1  │  ═XX═  │ SW2  │    Total: 300 Mbps ✅ (still works!)
  │      │  ════  │      │
  │      │  ════  │      │
  └──────┘        └──────┘


  WITHOUT EtherChannel — if the ONE link fails:

  ┌──────┐  ═XX═  ┌──────┐
  │ SW1  │        │ SW2  │    Total: 0 Mbps ❌ DISCONNECTED!
  └──────┘        └──────┘
```

---

## 4. EtherChannel Rules (IMPORTANT!)

```
  ┌──────────────────────────────────────────────────────────┐
  │                                                          │
  │  ALL ports in EtherChannel MUST match:                   │
  │                                                          │
  │  ✅ Same SPEED          (all 100 Mbps or all 1 Gbps)    │
  │  ✅ Same DUPLEX         (all full-duplex)                │
  │  ✅ Same VLAN           (if access ports)                │
  │  ✅ Same TRUNK settings (if trunk ports)                 │
  │  ✅ Same STP settings                                    │
  │                                                          │
  │  ❌ Cannot mix 100 Mbps and 1 Gbps                      │
  │  ❌ Cannot mix access and trunk                          │
  │  ❌ Cannot mix different VLANs                           │
  │                                                          │
  │  Maximum: 8 ports per EtherChannel                       │
  │  Minimum: 2 ports per EtherChannel                       │
  │                                                          │
  └──────────────────────────────────────────────────────────┘
```

---

## 5. Three Types of EtherChannel Protocols

```
  ┌────────────────────────────────────────────────────────────────┐
  │                                                                │
  │  1. LACP  (Link Aggregation Control Protocol)   ← BEST ✅    │
  │     - Industry standard (IEEE 802.3ad)                        │
  │     - Works with ANY vendor (Cisco, HP, Juniper)              │
  │     - Modes: active / passive                                  │
  │                                                                │
  │  2. PAgP  (Port Aggregation Protocol)           ← Cisco only │
  │     - Cisco proprietary                                        │
  │     - Works only between Cisco switches                        │
  │     - Modes: desirable / auto                                  │
  │                                                                │
  │  3. Static (Manual / ON)                        ← No protocol │
  │     - No negotiation protocol                                  │
  │     - Just forced ON                                           │
  │     - Mode: on                                                 │
  │     - ⚠️ Not recommended (no error checking)                  │
  │                                                                │
  └────────────────────────────────────────────────────────────────┘
```

---

## 6. LACP Modes — How They Pair

```
  LACP Modes:
  • active   = "I will START the negotiation"
  • passive  = "I will WAIT for the other side to start"
```

| SW1 Mode | SW2 Mode | Result |
|----------|----------|--------|
| active | active | ✅ EtherChannel Forms |
| active | passive | ✅ EtherChannel Forms |
| passive | active | ✅ EtherChannel Forms |
| passive | passive | ❌ NO Channel (both waiting) |

```
  Diagram:

  active  ──────────► active       ✅ Both start = WORKS
  active  ──────────► passive      ✅ One starts, other responds = WORKS
  passive ──────────► passive      ❌ Both waiting = NOBODY starts = FAILS
```

> 💡 **Best Practice:** Use `active` on **BOTH** sides.



---

## 7. Network Diagram

```
                    EtherChannel (Port-Channel 1)
                    LACP — 4 x 1 Gbps = 4 Gbps

  ┌─────────────────┐                    ┌─────────────────┐
  │      SW1        │  Gi0/1 ══════════ │      SW2        │
  │                 │  Gi0/2 ══════════ │                 │
  │  SALES (V10)    │  Gi0/3 ══════════ │  SALES (V10)    │
  │  MARKET (V20)   │  Gi0/4 ══════════ │  MARKET (V20)   │
  │  HR (V30)       │      Po1          │  HR (V30)       │
  │                 │                    │                 │
  │  Fa0/1  → V10   │                    │  Fa0/1  → V10   │
  │  Fa0/5  → V20   │                    │  Fa0/5  → V20   │
  │  Fa0/10 → V30   │                    │  Fa0/10 → V30   │
  └──┬───┬───┬──────┘                    └──┬───┬───┬──────┘
     │   │   │                              │   │   │
    PC1 PC3 PC5                            PC2 PC4 PC6
  Sales Mkt  HR                          Sales Mkt  HR
```


---

## 📌 8. EtherChannel Load Balancing

### How Does Traffic Split?

```
  EtherChannel does NOT split one file across links!
  It uses a HASH method to decide which link to use.

  ┌──────────────────────────────────────────────────┐
  │         EtherChannel (4 links)                    │
  │                                                    │
  │  Link 1 ════  PC1 → PC5 traffic goes here        │
  │  Link 2 ════  PC2 → PC6 traffic goes here        │
  │  Link 3 ════  PC3 → PC7 traffic goes here        │
  │  Link 4 ════  PC4 → PC8 traffic goes here        │
  │                                                    │
  │  Each CONVERSATION uses ONE link                  │
  │  Different conversations use different links       │
  └──────────────────────────────────────────────────┘
```

### Load Balancing Methods:

| Method | Based On | Best For |
|--------|----------|----------|
| `src-mac` | Source MAC address | Many source devices |
| `dst-mac` | Destination MAC address | Many destination devices |
| `src-dst-mac` | Both MACs **(default)** | General use |
| `src-ip` | Source IP address | Many source IPs |
| `dst-ip` | Destination IP address | Many destination IPs |
| `src-dst-ip` | Both IPs | **Best for most networks** |
____
## 9. Without vs With EtherChannel

```
  WITHOUT EtherChannel              WITH EtherChannel
  ════════════════════              ══════════════════

  ┌────┐  ─── ✅  ┌────┐          ┌────┐  ════╗  ┌────┐
  │SW1 │  ─── ❌  │SW2 │          │SW1 │  ════╬  │SW2 │
  │    │  ─── ❌  │    │          │    │  ════╬  │    │
  │    │  ─── ❌  │    │          │    │  ════╝  │    │
  └────┘           └────┘          └────┘   Po1   └────┘

  STP blocks 3 links              ALL links active
  Only 100 Mbps                   400 Mbps total
  1 link fails = DOWN             1 link fails = still UP
  No redundancy                   Full redundancy
```

