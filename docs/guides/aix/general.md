### AIX: Core Concepts and Administration

This document provides an overview of the foundational concepts and essential utilities of the IBM AIX operating system. AIX is a unique form of UNIX that relies on its own internal database, the Object Data Manager (ODM), to store critical configuration data for devices and the volume manager.

**System Administration Tools**

The primary tool for managing AIX servers is the **System Management Interface Tool (SMITTY)**. SMITTY simplifies administration tasks and helps reduce errors by guiding the user through command structures.

![smitty](/docs/assets/smitty.png){ width="300" }
/// caption
Image caption
///

**Installation and Updates**

AIX can be installed using several methods, including CD-ROM, system backup images (`mksysb`) on bootable media, or a Network Installation Management (NIM) server. The boot process allows access to SMS mode (System Management Services) by pressing `<1>` or `<F1>` to modify the bootlist for installation.

Software is managed through packages categorized by:
* **Technology Levels (TLs)**: Major stable updates that introduce new features and hardware support.
* **Service Packs (SPs)**: Intermediate updates providing security and critical fixes.
* **Filesets**: The basic unit of software.

Updates can be applied and committed permanently, or applied temporarily (`APPLIED` mode) to allow for easy rollback if issues arise.

**Logical Volume Manager (LVM)**

AIX's LVM virtualizes physical disks, offering flexibility and resilience.
* **Physical Volumes (PVs)** are the physical hard disks.
* **Volume Groups (VGs)** are containers for one or more PVs, with the mandatory `rootvg` being the system's core VG. VGs are composed of **Physical Partitions (PPs)**, which are the basic allocation increment.
* **Logical Volumes (LVs)** are created within VGs to hold data or host filesystems. LVM supports data mirroring (RAID 1) at the LV (`mklvcopy`) or VG (`mirrorvg`) level.
* **Management**: VGs (excluding `rootvg`) can be taken offline (`varyoffvg`) and brought back online (`varyonvg`), or exported and imported to facilitate transfer or renaming between servers. Data can be moved between PVs within a VG using `migratepv`.
* **Snapshots**: Read-only snapshots, particularly for JFS2 filesystems, can be created almost instantaneously by temporarily freezing a mirror copy.

**Filesystems (FS) and Networking**

AIX primarily uses JFS and the improved **JFS2 (Enhanced Journaled File System)**. Filesystem configurations are tracked in `/etc/filesystems`, and their size can be adjusted using `chfs`.

NFS exports are managed by activating the necessary daemons and defining share attributes in `/etc/exports`. When mounting an NFS filesystem, using the `soft` option is recommended to prevent the system from hanging if a network issue occurs.

**Device Management**

All devices are defined and managed within the ODM database. Commands like `lsdev` and `lsslot` are used to list and determine the physical and logical configuration of components, including disk drives, network adapters, and Fibre Channel cards.

**Backup**

Standard system backups (`mksysb`) are unique due to AIX's internal database structure. A `mksysb` is a system image that includes the boot sector, configuration files (`image.data` and `bosinst.data`), and the system data itself. While a `mksysb` file created on disk is not bootable, one created on tape or CD/DVD is, allowing for a complete system restoration. Separate commands like `savevg` are used to back up non-system volume groups.