# Network Cheatsheet

---

## Linux Networking Basics

### Disable Network Manager
In lab environments, Network Manager can interfere with manual IP settings.
```bash
# Stop the service
sudo service network-manager stop

# Get internet access via DHCP on a specific interface
dhclient eth1

```

### Interface Management

```bash
# Enable an interface
ip link set dev <interface> up

# Disable an interface
ip link set dev <interface> down

```

---

## Cisco Essentials

### Configuration Management

```ios
# View configs and status
show running-config
show ip interface brief
show interface brief           # For Fibre Channel (SAN)

# Saving and Resetting
wr                             # Shortcut for copy running-config startup-config
write erase                    # Reset router (requires reload)
reload                         # Reboot device

```

### General Principles

* `no <command>`: Negates or removes a command.
* `do <command>`: Executes operational commands from config mode.
* **Shortcuts:** `sh` (show), `conf t` (configure terminal), `int` (interface).
* **Clear Statistics:** `clear counters interface all`
* **Routing Activation:** On some Cisco switches, you must explicitly enable routing:

```ios
(config)# ip routing

```

### User Management & Security

```ios
# Admin User
(config)# username <name> privilege 15 password <password>
(config)# enable secret <password>

# Line Security
(config)# line con 0
(config-line)# login local
(config)# line vty 0 4
(config-line)# login local
(config-line)# transport input ssh

```

### Layer 2: VLANs, Trunk & LACP

```ios
# VLAN & Access
(config)# vlan 10
(config-if)# switchport mode access
(config-if)# switchport access vlan 10

# 802.1Q Trunk
(config)# interface <interface>
(config-if)# switchport trunk encapsulation dot1q  # On some models
(config-if)# switchport mode trunk
(config-if)# switchport trunk allowed vlan 10,20

# Port-Channel (LACP)

(config)# interface range fa0/1 - 2
(config-if-range)# channel-group 1 mode active
(config)# interface port-channel 1
(config-if)# switchport mode trunk

```

---

## Juniper (Junos) Essentials

### System Commands

```junos
# Initial Setup
root# set groups global system root-authentication plain-text-password
root# set apply-groups global

# Commit Logic
root# commit                   # Apply changes
root# commit check             # Verify syntax without applying
root# rollback 1               # Undo last committed change

# Operational
root@% reboot
root# run show route           # Execute show commands from config mode

```

### Security & Firewall

By default, Juniper SRX/Firewalls block traffic. Switch to **packet-mode** for lab routing:

```junos
[edit]
root# set security forwarding-options family inet mode packet-based
root# commit                   # Requires reboot

```

### Layer 2: VLANs, Trunk & LACP (Aggregate Ethernet)

```junos
# 1. Create VLAN
set vlans DATA vlan-id 10

# 2. Access and Trunk Ports
set interfaces ge-0/0/0 unit 0 family ethernet-switching interface-mode access vlan members DATA
set interfaces ge-0/0/1 unit 0 family ethernet-switching interface-mode trunk vlan members [ DATA VOIP ]

# 3. LACP (Aggregate Ethernet)
# First, define the device count
set chassis aggregated-devices ethernet device-count 1

# Add physical members to the logical bundle
set interfaces ge-0/0/10 ether-options 802.3ad ae0
set interfaces ge-0/0/11 ether-options 802.3ad ae0

# Configure the logical interface
set interfaces ae0 aggregated-ether-options lacp active
set interfaces ae0 unit 0 family ethernet-switching interface-mode trunk vlan members all

```

---

## Routing (Cross-Vendor)

### IPv4 & IPv6 Static

| Feature | Cisco | Juniper |
| --- | --- | --- |
| **Add IPv4** | `ip address <IP> <mask>` | `set interfaces <int> unit 0 family inet address <IP>/<mask>` |
| **IPv6 Enable** | `sdm prefer dual-ipv4-and-ipv6` | (Enabled by default) |
| **Add IPv6** | `ipv6 address <IP>/<prefix>` | `set interfaces <int> unit 0 family inet6 address <IP>/<prefix>` |
| **Static Route** | `ip route <net> <mask> <next>` | `set routing-options static route <net>/<mask> next-hop <next>` |
| **IPv6 Route** | `ipv6 route <net>/<pre> <next>` | `set routing-options rib inet6.0 static route <net>/<pre> next-hop <next>` |

---

## Dynamic Routing

### OSPF

* **Cisco:**
```ios
(config)# router ospf 1
(config-router)# network 10.0.0.0 0.0.0.255 area 0

```


* **Juniper:**
```junos
set protocols ospf area 0.0.0.0 interface ge-0/0/0.0

```



### BGP (Cisco)

```ios
(config)# router bgp 65001
(config-router)# neighbor 192.168.1.1 remote-as 65002
(config-router)# network 10.10.10.0 mask 255.255.255.0

# Route Policy (Local Preference)
(config)# ip prefix-list MY_NET permit 10.10.10.0/24
(config)# route-map SET_LP permit 10
(config-route-map)# match ip address prefix-list MY_NET
(config-route-map)# set local-preference 200

```

---

## SAN / MDS (Cisco)

```ios
# 1. Alias
(config)# fcalias name MyServer vsan 1
(config-fcalias)# member pwwn 21:00:00:e0:8b:05:05:04

# 2. Zone & Activation
(config)# zone name Zone1 vsan 1
(config-zone)# member fcalias MyServer
(config)# zoneset name Set1 vsan 1
(config-zoneset)# member Zone1
(config)# zoneset activate name Set1 vsan 1

```

---

## Debugging & Verification

* **Routing:** `show ip route` (Cisco) | `run show route` (Juniper)
* **LACP status:** `show etherchannel summary` (Cisco) | `run show interfaces terse ae0` (Juniper)
* **Connectivity:** `ping` / `traceroute`
* **Packet Capture:** Use **Wireshark** to confirm 802.1Q tags or LACP BPDU exchange.