# Brocade SAN Switch Cheatsheet

## System Management

### Connection and Basics
* **Default Login:** `admin` / `password`
* **Check Switch Status:** `switchshow` (Provides status, domain ID, and port states)
* **Check Firmware Version:** `version`
* **Reboot Switch:** `reboot`

### Configuration Management
```bash
# View all configuration settings
configshow

# Back up configuration to an external server
configupload

# Restore configuration from a server
configdownload

# Set the switch name
switchname "Brocade_SAN_01"

```

---

## Interface Management

### Port Status and Control

```bash
# Enable a port
portenable <port_number>

# Disable a port
portdisable <port_number>

# Detailed port statistics and errors
portstatsshow <port_number>

# Clear port statistics
portstatsclear <port_number>

```

### Fabric Login (FLOGI)

To see which devices (WWNs) are physically connected to the ports:

```bash
# Show all logged-in devices and their WWNs
flogishow
# OR
portloginshow <port_number>

```

---

## SAN Zoning (Brocade Logic)

Brocade uses a three-step logic: **Aliases** -> **Zones** -> **Configuration (CFG)**.

### 1. Create Aliases

Aliases make WWNs human-readable (e.g., naming a WWN "Server_HBAs").

```bash
# Create an alias
alicreate "Alias_Name", "WWN"
# Example
alicreate "SRV_PROD_01", "21:00:00:24:ff:50:05:04"

# Add members to an existing alias
aliadd "Alias_Name", "WWN"

```

### 2. Create Zones

Zones define which aliases can talk to each other (usually 1 Initiator + 1 Target).

```bash
# Create a zone
zonecreate "Zone_Name", "Alias1; Alias2"
# Example
zonecreate "Zone_SRV01_Storage", "SRV_PROD_01; Storage_Port_A"

```

### 3. Create and Activate Configuration

The Zone Configuration (CFG) is a container for all the zones you want active.

```bash
# Create a new configuration and add a zone
cfgcreate "CFG_Name", "Zone_Name"

# Add a zone to an existing configuration
cfgadd "CFG_Name", "Zone_Name"

# Save the changes to non-volatile memory
cfgsave

# Enable the configuration (This makes the zoning live)
cfgenable "CFG_Name"

```

---

## Maintenance and Troubleshooting

### Zoning Verification

```bash
# View the defined (offline) configuration
cfgshow

# View the currently active zoning in the fabric
cfgactiveshow

# Find a specific WWN in the zone database
zoneshow | grep -i "21:00:..."

```

### Fabric Troubleshooting

* **Check Fabric Membership:** `fabricshow` (Shows all switches in the fabric)
* **Monitor Environment:** `chassisshow` (Status of fans, power supplies, and temperature)
* **SFP Diagnostics:** `sfpshow <port_number>` (Shows light levels and SFP health)

---

## General Principles

* **Persistence:** Always run `cfgsave` after your modifications; otherwise, changes may be lost if the switch reboots.
* **Case Sensitivity:** Command names and Aliases/Zones are often case-sensitive in FOS.
* **The "no" equivalent:** In Brocade, use `delete` or `remove` commands (e.g., `alidelete`, `zonedelete`, `cfgdelete`).

```
