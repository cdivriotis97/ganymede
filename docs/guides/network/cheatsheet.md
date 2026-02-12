# Cheatsheet Network

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

### Connection & Basics

* **Connect:** `telnet console-api <2000 + router_number>`
* **Reboot:** `reload`

### Configuration Management

```ios
# View running config
show running-config

# Save changes
copy running-config startup-config
# OR
wr

# Reset router (delete config)
write erase

```

### General Principles

![General Principles](../../assets/network-general-principles.png)

* `no <command>`: Negates or removes a command.
* `do <command>`: Executes operational commands from config mode (e.g., `do show ip route`).
* **Shortcuts:** `sh` (show), `conf t` (configure terminal), `int` (interface).

---

## Juniper (Junos) Essentials

### Connection

* **Console:** `telnet console4-api <2000 + router_number>`

### Initial Setup (Root Password)

If the root password is empty, you must set one to allow commits:

```junos
[edit]
root# set groups global system root-authentication plain-text-password
root# set apply-groups global
root# commit

```

### System Commands

* **Reboot:** `root@% reboot`
* **Apply changes:** `commit`
* **Undo:** `delete <command>`
* **Operational commands in config mode:** `run <command>` (e.g., `run show route`)

### Security / Firewall

By default, Juniper may block packets. Switch to **packet-mode**:

```junos
root> configure
[edit]
root# set security forwarding-options family <family> mode packet-based
root# commit
# Note: Requires a reboot

```

---

## Static Routing

### IPv4 Configuration

| Feature | Linux | Cisco | Juniper |
| --- | --- | --- | --- |
| **Add IP** | `ip a a <IP>/<mask> dev <int>` | `(config-if)# ip address <IP> <mask>` | `set interfaces <int> unit 0 family inet address <IP>/<mask>` |
| **Del IP** | `ip a d <IP>/<mask> dev <int>` | `(config-if)# no ip address` | `delete interfaces <int> unit 0 family inet address <IP>/<mask>` |
| **Add Route** | `ip r a <net>/<mask> via <next>` | `(config)# ip route <net> <mask> <next>` | `set routing-options static route <net>/<mask> next-hop <next>` |

> **Cisco Tip:** Use `no switchport` on a physical interface to assign an IP directly.

### IPv6 Configuration

*Global Prefix:* `2000::/3`

**Cisco Enable IPv6:**

```ios
(config)# sdm prefer dual-ipv4-and-ipv6
# Reboot required
(config-if)# ipv6 address <IP>/<mask>

```

**Juniper Add IPv6:**

```junos
set interfaces <int> unit 0 family inet6 address <IP>/<mask>
set routing-options rib inet6.0 static route <net>/<mask> next-hop <next>

```

---

## Dynamic Routing

### RIP & RIPng (IPv6)

**Cisco (IPv4):**

```ios
(config)# router rip
(config-router)# network <network_IP>

```

**Cisco (IPv6):**

```ios
(config-if)# ipv6 rip <name> enable
(config)# redistribute connected

```

**Juniper (IPv6):**
Requires a policy to export routes:

```junos
set policy-options policy-statement ADV-RIPng term 1 from protocol [ direct ripng ]
set policy-options policy-statement ADV-RIPng term 1 then accept
set protocols ripng group ripng-group export ADV-RIPng
set protocols ripng group ripng-group neighbor <interface>

```

### OSPF & OSPFv3 (IPv6)

**Cisco (IPv4):**

```ios
(config)# router ospf <process_id>
(config-router)# network <IP> <wildcard_mask> area <area_id>

```

**Juniper (IPv6):**

```junos
set routing-options router-id <ID>
set protocols ospf3 area 0.0.0.0 interface <interface>

```

---

## BGP (Cisco focus)

### Observation

* `sh ip bgp summary`: Neighbor status.
* `sh ip bgp neighbors <IP> advertised-routes`: Sent routes.
* `sh ip bgp neighbors <IP> received-routes`: Received routes (requires `soft-reconfiguration inbound`).

### Configuration

```ios
(config)# router bgp <AS_number>
(config-router)# neighbor <IP> remote-as <Remote_AS>
(config-router)# network <IP> mask <mask>

```

### Route Manipulation (Local-Pref)

```ios
(config)# ip prefix-list MY_FILTER permit <net>/<mask>
(config)# route-map SET_LP permit 10
(config-route-map)# match ip address prefix-list MY_FILTER
(config-route-map)# set local-preference 200
(config-router)# neighbor <IP> route-map SET_LP in

```

---

## Switching & MPLS

### VLANs (Cisco)

```ios
(config)# vlan 10
(config-if)# switchport mode access
(config-if)# switchport access vlan 10

```

### MPLS (Cisco)

```ios
(config)# ip cef
(config)# mpls label protocol ldp
(config-if)# mpls ip
# View labels: show tag-switching forwarding-table

```

---

## Debugging Tips

* **Check Tables:** Always start with `show ip route` or `run show route`.
* **Follow the Path:** Use `ping` and `traceroute`.
* **Sniffing:** Use **Wireshark** to verify if packets reach the interface or if ARP is failing.

```
