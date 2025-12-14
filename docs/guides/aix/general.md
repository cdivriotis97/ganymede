## Core Concepts, Administration, and Roadmap

### Introduction to AIX

AIX (Advanced Interactive eXecutive) is a specialized UNIX operating system that stands out due to its reliance on a proprietary internal database, the **Object Data Manager (ODM)**, which stores critical configuration data for the Logical Volume Manager (LVM) and system devices. For administrative tasks, the use of **SMITTY (System Management Interface Tool)** is highly recommended, as it simplifies complex commands and helps prevent common administrative errors.

### Logical Volume Manager (LVM)

AIX's LVM virtualizes physical disks, offering a flexible and robust storage management system:

* **Physical Volumes (PVs)**: The underlying physical hard disks. Commands like `lspv` list available PVs.
* **Volume Groups (VGs)**: Containers for PVs, with the mandatory `rootvg` being the core system volume group. VGs are partitioned into **Physical Partitions (PPs)**, which are the smallest allocation unit for Logical Volumes. VGs have maximum capacity limits based on the PP size (e.g., 1016 PPs per PV for a standard VG, which can be modified using the `chvg -t` command).
* **Logical Volumes (LVs)**: Data containers within a VG used for RAW devices or filesystems. While LVs can be directly resized, it is generally recommended to change the filesystem size (`chfs`), which automatically adjusts the underlying LV.
* **Mirroring and Resilience**: AIX LVM supports RAID 0, 1, and 0+1 (10). Mirroring can be configured at the LV level (`mklvcopy`) or across the entire VG (`mirrorvg`). Special procedures (`bosboot` and `bootlist`) are required to ensure a mirrored `rootvg` is fully bootable.
* **VG Operations**: VGs (excluding `rootvg`) can be taken offline (`varyoffvg`), brought online (`varyonvg`), and even **exported** and **imported** (the only way to effectively rename a VG).
* **Snapshots**: Snapshots are often created by splitting a mirror copy (`splitvg`) to get an instantaneous, full copy of the data, which can be mounted read-only for backup purposes. JFS2 filesystems also support their own snapshot mechanism.

### Filesystem Management and Networking

AIX filesystems include **JFS** and the modern **JFS2 (Enhanced Journaled File System)**. Filesystem configurations are tracked in `/etc/filesystems`.

* **Resizing**: Filesystem size is adjusted using `chfs -a size=<new_size>`.
* **NFS (Network File System)**: NFS exports are configured in `/etc/exports` and managed via `exportfs -va`. When mounting an NFS share, using the `soft` option is preferred over the default `hard` mount to prevent the system from freezing due to network issues.
* **JFS2 Snapshots**: Instantaneous, read-only copies. Multiple snapshots can be chained, meaning the most recent snapshot depends on the previous ones.

### Device and Package Administration

* **Device Management**: All devices are defined in the ODM. Commands like `lsdev -C` list all configured devices (disks, adapters, etc.), and `lsslot` shows their physical locations. `lscfg -vp` provides detailed hardware characteristics (serial number, firmware, etc.).
* **Package Management**: AIX software is managed through a hierarchy:
    * **Filesets**: The basic unit of software/patching.
    * **APARs (Authorized Program Analysis Report)**: Individual fixes.
    * **Service Packs (SPs)**: Intermediate updates for critical and security fixes (`oslevel -s`).
    * **Technology Levels (TLs)**: Major, stable updates released twice a year with new features and hardware support (`oslevel -r`).
* **Updating**: Updates are managed via `smitty update_all`. Patches can be temporarily **APPLIED** (allowing for simple rollback) or **COMMITTED** (finalized).

### Backup and Daemon Management

* **System Backup**: The `mksysb` command performs a unique system backup that includes a boot image (`bosboot`), system definition files (`image.data` and `bosinst.data`), and the system data. Backups created on CD/DVD/tape are bootable, while file-based backups are not.
* **Daemons**: System daemons are managed via the System Resource Controller (SRC), using commands like `lssrc -a` to list all services and `startsrc`/`stopsrc` for control.

---

## AIX Roadmap and Modernization (AIX 7.3 TL2 Highlights)

IBM’s roadmap for AIX is focused on **Hybrid Cloud** enablement and system modernization. The **AIX 7.3 Technology Level 2 (TL2)**, released in November 2023, highlights these key areas:

### Automation and Modernization

* **Open-Source Integration**: Focus on integrating open-source technology for easier management and cloud deployment models.
* **Core Tools Updates**: Inclusion of updated open-source components:
    * **Python** (v3.19.17) for out-of-the-box Ansible automation.
    * **Bash** (v5.2.15) as an included alternate shell.
    * Updates to essential libraries and tools (`libxml2`, `rpm`, `rsyslog`).
* **Management Enhancements**: Improved capabilities for image creation, such as `create_ova` with hardware compression.

### Enhanced Availability

* **Live Kernel Update**: Optimized performance for AIX live kernel updates in PowerVC environments.
* **Network Resilience**: Enhanced LLDP (Link Layer Discovery Protocol) reporting.
* **Storage Resilience**: MPIO (Multipath I/O) support for FPIN (Fabric Performance Impact Notification).

