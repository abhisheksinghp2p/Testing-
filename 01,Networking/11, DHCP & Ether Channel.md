# DHCP (Dynamic Host Configuration Protocol) 
- DHCP automatically assigns IP addresses and network configuration to devices.
- DHCP automatically assigns IP configuration to devices on a network, so you don’t have to set IP addresses manually.
- ==DHCP (Dynamic Host Configuration Protocol) is a protocol that automatically assigns **IP addresses, Subnet Masks, Gateways, and DNS servers** to clients so they can communicate on the network.==

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

# DHCP DORA Process 
### DISCOVER -- OFFER -- REQUEST -- ACK

---

## Initial State

```
PC-A
┌────────────────────────────────┐
│ IP Address    : 0.0.0.0        │
│ MAC Address   : AAAA.AAAA      │
│ Gateway       : None           │
│ DNS           : None           │
└────────────────────────────────┘

DHCP Server (Router)
┌────────────────────────────────┐
│ IP: 192.168.10.1               │
│ MAC: BBBB.BBBB                 │
│                                │
│ Pool: MYPOOL                   │
│   Network : 192.168.10.0/24   │
│   Range   : .10 - .100        │
│   Gateway : 192.168.10.1      │
│   DNS     : 8.8.8.8           │
│   Lease   : 24 hours          │
│                                │
│ Excluded  : .1 to .9          │
└────────────────────────────────┘
```

---

## Network Diagram

```
┌───────────────────────────────────────────────────┐
│                                                   │
│   PC-A ◄──────────────► ROUTER (DHCP Server)     │
│   No IP yet               192.168.10.1            │
│   0.0.0.0                 Has pool of IPs         │
│                                                   │
└───────────────────────────────────────────────────┘
```

---

## DORA Flow Overview

```
┌──────────────────────────────────────────────────────────────┐
│                        DORA FLOW                             │
├──────────────────────────────────────────────────────────────┤
│                                                              │
│    CLIENT (PC-A)                        SERVER (Router)      │
│     (Port 68)                            (Port 67)           │
│        │                                    │                │
│        │ ═══════ 1. DISCOVER ══════════════►│                │
│        │    Broadcast (68 → 67)             │                │
│        │    "Any DHCP server?"              │                │
│        │                                    │                │
│        │ ◄══════ 2. OFFER ═════════════════ │                │
│        │    Broadcast  (67 → 68)            │                │
│        │    "Here's 192.168.10.10"          │                │
│        │                                    │                │
│        │ ═══════ 3. REQUEST ═══════════════►│                │
│        │    Broadcast (68 → 67)             │                │
│        │    "I want 192.168.10.10"          │                │
│        │                                    │                │
│        │ ◄══════ 4. ACK ══════════════════  │                │
│        │    Broadcast/Unicast (67 → 68)     │                │
│        │    "Confirmed! It's yours!"        │                │
│        │                                    │                │
│        ▼                                    │                │
│     GOT IP!                                 │                │
│     192.168.10.10 ✅                        │                │
│                                                              │
└──────────────────────────────────────────────────────────────┘
```

---

## Step 1: DISCOVER

```
┌──────────────────────────────────────────────────────────────┐
│  STEP 1: DISCOVER — "I need an IP!"                          │
├──────────────────────────────────────────────────────────────┤
│                                                              │
│  WHO SENDS  : Client (PC-A)                                  │
│  TYPE       : BROADCAST                                      │
│  DIRECTION  : Client → Everyone (looking for server)         │
│                                                              │
│  WHY BROADCAST?                                              │
│  • PC has NO IP address (0.0.0.0)                           │
│  • PC doesn't know where DHCP server is                     │
│  • So PC shouts to EVERYONE on network                      │
│                                                              │
│  PACKET:                                                     │
│  ┌──────────────────────────────────────────────────────────┐│
│  │  LAYER 2:                                                ││
│  │    Src MAC  : AAAA.AAAA          (my MAC)               ││
│  │    Dst MAC  : FFFF.FFFF          (broadcast)             ││
│  │                                                          ││
│  │  LAYER 3:                                                ││
│  │    Src IP   : 0.0.0.0            (I have no IP)         ││
│  │    Dst IP   : 255.255.255.255    (broadcast)            ││
│  │                                                          ││
│  │  LAYER 4:                                                ││
│  │    Src Port : 68                 (DHCP client port)     ││   
│  │    Dst Port : 67                 (DHCP server port)     ││   By using port 67 server accept the request.
│  │                                                          ││
│  │  DHCP DATA:                                              ││
│  │    Message Type   : DISCOVER                             ││
│  │    Transaction ID : 0x1234ABCD   (unique ID)            ││
│  │    Client MAC     : AAAA.AAAA    (so server knows me)   ││
│  │    Requested IP   : 0.0.0.0      (no preference)        ││
│  └──────────────────────────────────────────────────────────┘│
│                                                              │
│  WHAT HAPPENS:                                               │
│  ┌──────────────────────────────────────────────────────────┐│
│  │                                                          ││
│  │  PC-A shouts → EVERYONE hears it                         ││
│  │                                                          ││
│  │  Other PCs    : "Not for me" (ignore) ❌                 ││
│  │  Printer      : "Not for me" (ignore) ❌                 ││
│  │  DHCP Server  : "That's for ME!" ✅                      ││
│  │                                                          ││
│  └──────────────────────────────────────────────────────────┘│
└──────────────────────────────────────────────────────────────┘
```

---

## Step 2: OFFER

```
┌──────────────────────────────────────────────────────────────┐
│  STEP 2: OFFER — "Here's 192.168.10.10 for you!"            │
├──────────────────────────────────────────────────────────────┤
│                                                              │
│  WHO SENDS  : DHCP Server                                    │
│  TYPE       : BROADCAST                                      │
│  DIRECTION  : Server → Client                                │
│                                                              │
│  WHY BROADCAST?                                              │
│  • Client STILL has no IP (can't receive unicast)            │
│  • Client identifies its offer by Transaction ID             │
│                                                              │
│  SERVER LOGIC:                                               │
│  ┌──────────────────────────────────────────────────────────┐│
│  │                                                          ││
│  │  1. Server receives DISCOVER                             ││
│  │  2. Server checks pool: "What IPs are available?"        ││
│  │     → .1 to .9 = EXCLUDED (reserved)                     ││
│  │     → .10 = AVAILABLE ✅ (first available)              ││
│  │  3. Server picks 192.168.10.10                           ││
│  │  4. Server RESERVES this IP temporarily                 ││
│  │  5. Server sends OFFER with this IP                     ││
│  │                                                          ││
│  └──────────────────────────────────────────────────────────┘│
│                                                              │
│  PACKET:                                                     │
│  ┌──────────────────────────────────────────────────────────┐│
│  │  LAYER 2:                                                ││
│  │    Src MAC  : BBBB.BBBB          (server's MAC)         ││
│  │    Dst MAC  : FFFF.FFFF          (broadcast)            ││
│  │                                                          ││
│  │  LAYER 3:                                                ││
│  │    Src IP   : 192.168.10.1       (server's IP)          ││
│  │    Dst IP   : 255.255.255.255    (broadcast)            ││
│  │                                                          ││
│  │  LAYER 4:                                                ││
│  │    Src Port : 67                 (server port)          ││
│  │    Dst Port : 68                 (client port)          ││
│  │                                                          ││
│  │  DHCP DATA:                                              ││
│  │    Message Type    : OFFER                               ││
│  │    Transaction ID  : 0x1234ABCD  (matches DISCOVER)     ││
│  │    YIADDR          : 192.168.10.10 (Your IP Address)    ││
│  │    Server ID       : 192.168.10.1                       ││
│  │                                                          ││
│  │  OPTIONS:                                                ││
│  │    Subnet Mask     : 255.255.255.0                      ││
│  │    Default Gateway : 192.168.10.1                       ││
│  │    DNS Server      : 8.8.8.8                            ││
│  │    Lease Time      : 86400 seconds (24 hours)           ││
│  └──────────────────────────────────────────────────────────┘│
│                                                              │
│  WHAT HAPPENS:                                               │
│  ┌──────────────────────────────────────────────────────────┐│
│  │                                                          ││
│  │  Server broadcasts OFFER → EVERYONE hears it            ││
│  │                                                          ││
│  │  PC-A checks Transaction ID:                            ││
│  │  "0x1234ABCD matches MY discover! This is for ME!" ✅   ││
│  │                                                          ││
│  │  Other PCs check Transaction ID:                        ││
│  │  "0x1234ABCD is NOT mine. Ignore." ❌                   ││
│  │                                                          ││
│  └──────────────────────────────────────────────────────────┘│
│                                                              │
│  DIAGRAM:                                                    │
│                                                              │
│  ┌──────┐                              ┌──────────────┐     │
│  │ PC-A │                              │ DHCP Server  │     │
│  │      │  ◄══════ OFFER ════════════  │              │     │
│  │      │  "I offer you .10.10"        │ 192.168.10.1 │     │
│  │      │  Mask: 255.255.255.0         │              │     │
│  │      │  GW: 192.168.10.1            │              │     │
│  │      │  DNS: 8.8.8.8                │              │     │
│  │      │  Lease: 24 hours             │              │     │
│  └──────┘                              └──────────────┘     │
│                                                              │
│  KEY: YIADDR = "Your IP Address" = the IP offered to client │
│  KEY: Transaction ID must MATCH the DISCOVER                 │
│                                                              │
└──────────────────────────────────────────────────────────────┘
```

---

## Step 3: REQUEST

```
┌──────────────────────────────────────────────────────────────┐
│  STEP 3: REQUEST — "Yes! I want 192.168.10.10!"             │
├──────────────────────────────────────────────────────────────┤
│                                                              │
│  WHO SENDS  : Client (PC-A)                                  │
│  TYPE       : BROADCAST                                      │
│  DIRECTION  : Client → Everyone                              │
│                                                              │
│  WHY BROADCAST? (3 reasons)                                  │
│  ┌──────────────────────────────────────────────────────────┐│
│  │                                                          ││
│  │  1. Client STILL has no confirmed IP (Src = 0.0.0.0)   ││
│  │                                                          ││
│  │  2. Tell chosen server: "I accept YOUR offer" ✅        ││
│  │                                                          ││
│  │  3. Tell other servers: "I did NOT choose you,          ││
│  │     release the IP you offered back to your pool" ❌    ││
│  │                                                          ││
│  └──────────────────────────────────────────────────────────┘│
│                                                              │
│  PACKET:                                                     │
│  ┌──────────────────────────────────────────────────────────┐│
│  │  LAYER 2:                                                ││
│  │    Src MAC  : AAAA.AAAA          (my MAC)               ││
│  │    Dst MAC  : FFFF.FFFF          (broadcast)            ││
│  │                                                          ││
│  │  LAYER 3:                                                ││
│  │    Src IP   : 0.0.0.0            (still no confirmed IP)││
│  │    Dst IP   : 255.255.255.255    (broadcast)            ││
│  │                                                          ││
│  │  LAYER 4:                                                ││
│  │    Src Port : 68                 (client port)          ││
│  │    Dst Port : 67                 (server port)          ││
│  │                                                          ││
│  │  DHCP DATA:                                              ││
│  │    Message Type   : REQUEST                              ││
│  │    Transaction ID : 0x1234ABCD   (same as before)       ││
│  │    Requested IP   : 192.168.10.10 (I want this IP)     ││
│  │    Server ID      : 192.168.10.1  (I chose THIS server)││
│  │    Client MAC     : AAAA.AAAA                           ││
│  └──────────────────────────────────────────────────────────┘│
│                                                              │
│  WHAT HAPPENS:                                               │
│  ┌──────────────────────────────────────────────────────────┐│
│  │                                                          ││
│  │  Chosen Server (192.168.10.1):                          ││
│  │  "Client chose ME! I'll send ACK" ✅                    ││
│  │                                                          ││
│  │  Other Servers (if any):                                ││
│  │  "Client chose someone else."                           ││
│  │  "I'll release my offered IP back to pool" ❌           ││
│  │                                                          ││
│  └──────────────────────────────────────────────────────────┘│
│                                                              │
│  DIAGRAM:                                                    │
│                                                              │
│  ┌──────┐                              ┌──────────────┐     │
│  │ PC-A │                              │ DHCP Server  │     │
│  │      │  ══════ REQUEST ═══════════► │              │     │
│  │      │  "I want 192.168.10.10"      │ 192.168.10.1 │     │
│  │      │  "I chose server .10.1"      │              │     │
│  │      │  Src: 0.0.0.0               │  "Client     │     │
│  │      │  Dst: 255.255.255.255       │   chose ME!" │     │
│  └──────┘                              └──────────────┘     │
│                                                              │
│  KEY: Contains both Requested IP and Server ID              │
│                                                              │
└──────────────────────────────────────────────────────────────┘
```

---

## Step 4: ACK (Acknowledge)

```
┌──────────────────────────────────────────────────────────────┐
│  STEP 4: ACK — "Confirmed! 192.168.10.10 is yours!"          │
├──────────────────────────────────────────────────────────────┤
│                                                              │
│  WHO SENDS  : DHCP Server                                    │
│  TYPE       : BROADCAST                                      │
│  DIRECTION  : Server → Client                                │
│                                                              │
│  SERVER DOES 2 THINGS:                                       │
│  ┌──────────────────────────────────────────────────────────┐│
│  │                                                          ││
│  │  1. Creates BINDING record in database:                  ││
│  │     MAC: AAAA.AAAA ↔ IP: 192.168.10.10                   ││
│  │     Lease: 24 hours                                      ││
│  │                                                          ││
│  │  2. Sends ACK packet to confirm                          ││
│  │                                                          ││
│  └──────────────────────────────────────────────────────────┘│
│                                                              │
│  PACKET:                                                     │
│  ┌──────────────────────────────────────────────────────────┐│
│  │  LAYER 2:                                                ││
│  │    Src MAC  : BBBB.BBBB          (server's MAC)          ││
│  │    Dst MAC  : FFFF.FFFF          (broadcast)             ││
│  │                                                          ││
│  │  LAYER 3:                                                ││
│  │    Src IP   : 192.168.10.1       (server's IP)           ││
│  │    Dst IP   : 255.255.255.255    (broadcast)             ││
│  │                                                          ││
│  │  LAYER 4:                                                ││
│  │    Src Port : 67                 (server port)           ││
│  │    Dst Port : 68                 (client port)           ││
│  │                                                          ││
│  │  DHCP DATA:                                              ││
│  │    Message Type    : ACK                                 ││
│  │    Transaction ID  : 0x1234ABCD  (matches everything)    ││
│  │    YIADDR          : 192.168.10.10 (Your IP confirmed)   ││
│  │    Server ID       : 192.168.10.1                        ││
│  │                                                          ││
│  │  OPTIONS:                                                ││
│  │    Subnet Mask     : 255.255.255.0                       ││
│  │    Default Gateway : 192.168.10.1                        ││
│  │    DNS Server      : 8.8.8.8                             ││
│  │    Lease Time      : 86400 seconds (24 hours)            ││
│  └──────────────────────────────────────────────────────────┘│
│                                                              │
│  DIAGRAM:                                                    │
│                                                              │
│  ┌──────┐                              ┌──────────────┐      │
│  │ PC-A │                              │ DHCP Server  │      │
│  │      │  ◄══════ ACK ═══════════════ │              │      │
│  │      │  "CONFIRMED!"                │ 192.168.10.1 │      │
│  │      │  ".10.10 is yours            │              │      │
│  │      │   for 24 hours!"             │  Binding:    │      │
│  │      │                              │  AAAA↔.10.10 │      │
│  └──────┘                              └──────────────┘      │
│                                                              │
│  RESULT — PC-A IS NOW CONFIGURED:                            │
│  ┌──────────────────────────────────────────────────────────┐│
│  │                                                          ││
│  │  IP Address      : 192.168.10.10    ✅                  ││
│  │  Subnet Mask     : 255.255.255.0    ✅                  ││
│  │  Default Gateway : 192.168.10.1     ✅                  ││
│  │  DNS Server      : 8.8.8.8          ✅                  ││
│  │  Lease Time      : 24 hours         ✅                  ││
│  │                                                          ││
│  │  PC-A can now COMMUNICATE on the network! 🎉           ││
│  │                                                          ││
│  └──────────────────────────────────────────────────────────┘│
│                                                              │
│  SERVER BINDING TABLE:                                       │
│  ┌──────────────────────────────────────────────────────────┐│
│  │  IP Address     │ MAC Address  │ Lease Expires           ││
│  │  192.168.10.10  │ AAAA.AAAA   │ Tomorrow 10:00 AM      ││
│  └──────────────────────────────────────────────────────────┘│
│                                                              │
└──────────────────────────────────────────────────────────────┘
```

---

## DORA Summary Table

```
┌──────────────────────────────────────────────────────────────┐
│                     DORA SUMMARY                             │
├──────┬───────────┬────────┬───────────┬─────────────────────┤
│ Step │ Message   │ Sender │ Type      │ Key Info            │
├──────┼───────────┼────────┼───────────┼─────────────────────┤
│  D   │ DISCOVER  │ Client │ Broadcast │ "Any server?"       │
│      │           │        │           │ Src: 0.0.0.0        │
│      │           │        │           │ Dst: 255.255.255.255│
│      │           │        │           │ Port: 68 → 67       │
├──────┼───────────┼────────┼───────────┼─────────────────────┤
│  O   │ OFFER     │ Server │ Broadcast │ "Here's .10.10"     │
│      │           │        │           │ Src: 192.168.10.1   │
│      │           │        │           │ Dst: 255.255.255.255│
│      │           │        │           │ Port: 67 → 68       │
├──────┼───────────┼────────┼───────────┼─────────────────────┤
│  R   │ REQUEST   │ Client │ Broadcast │ "I want .10.10"     │
│      │           │        │           │ Src: 0.0.0.0        │
│      │           │        │           │ Dst: 255.255.255.255│
│      │           │        │           │ Port: 68 → 67       │
├──────┼───────────┼────────┼───────────┼─────────────────────┤
│  A   │ ACK       │ Server │ Broadcast │ "Confirmed!"        │
│      │           │        │           │ Src: 192.168.10.1   │
│      │           │        │           │ Dst: 255.255.255.255│
│      │           │        │           │ Port: 67 → 68       │
└──────┴───────────┴────────┴───────────┴─────────────────────┘
```

---

## Before and After DORA

```
  BEFORE DORA:                        AFTER DORA:

  ┌────────────────────┐              ┌────────────────────┐
  │ PC-A               │              │ PC-A               │
  │                    │              │                    │
  │ IP:   0.0.0.0     │              │ IP:   192.168.10.10│
  │ Mask: None         │              │ Mask: 255.255.255.0│
  │ GW:   None         │              │ GW:   192.168.10.1│
  │ DNS:  None         │              │ DNS:  8.8.8.8     │
  │                    │              │                    │
  │ ❌ Cannot          │              │ ✅ Can ping       │
  │    communicate     │              │ ✅ Can browse     │
  │                    │              │ ✅ Can access     │
  │                    │              │    network        │
  └────────────────────┘              └────────────────────┘
```

---
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



__________________________________________

# Ether Channel 
Bundles multiple physical links into one logical link for increased bandwidth & redundancy

Ether Channel combines multiple physical Ethernet links into one logical link to:
- Increase bandwidth
- Provide redundancy(Backup) (if one line break other will work.)
- Load Balancing
	Traffic is distributed across multiple links

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

## 6. LACP 
LACP (Link Aggregation Control Protocol) is a protocol that automatically bundles multiple physical links into one logical link (EtherChannel).


#### Modes — How They Pair


==**Active Mode**==
- Actively sends LACP packets
- Tries to form channel

==**Passive Mode**==
- Waits for other side
- Responds but doesn’t initiate

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

## 8. EtherChannel Load Balancing

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


