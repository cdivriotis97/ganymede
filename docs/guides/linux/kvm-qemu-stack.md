# KVM, QEMU, and Libvirt Management

This guide covers the creation, configuration, and lifecycle management of Virtual Machines (VMs) using the KVM/QEMU stack.

---

## Create a VM from an ISO Image

To install a new virtual machine from an ISO file, use the `virt-install` command.

### Key `virt-install` Parameters:

| Parameter | Description |
| :--- | :--- |
| `--name` | The unique name of the VM. |
| `--os-type` | Optimizes configuration for an OS type (e.g., 'linux', 'windows'). |
| `--os-variant` | Fine-tuned optimization for specific versions (e.g., 'fedora8', 'win10'). |
| `--ram` | Memory allocated to the guest in MiB. |
| `--vcpus` | Number of virtual CPUs to configure. |
| `--disk path=...` | Storage configuration and path to the media (file or partition). |
| `--graphics` | Specifies the graphical display (e.g., 'spice', 'vnc' or 'none'). |
| `--location` | Source for the installation (ISO, URL, or local directory). |
| `--extra-args` | Additional kernel command-line arguments for the installer. |



---

## Disk Image Management

### Checking Image Information
Check the file type and details of a disk image:
```bash
sudo file /var/lib/libvirt/images/debian9.img
# Output: /var/lib/libvirt/images/debian9.img: QEMU QCOW Image (v3), 10737418240 bytes

```

### Resizing a Disk Image

To increase the size of a cloud image:

```bash
qemu-img resize bionic-server-cloudimg-amd64.img 20G

# Verify the change
qemu-img info bionic-server-cloudimg-amd64.img
# virtual size: 20G (21474836480 bytes)

```

---

## Configure a Pre-defined VM Image

You can download and customize official cloud images without booting them using `virt-customize`.

```bash
# Download the image
wget [https://cloud-images.ubuntu.com/bionic/current/bionic-server-cloudimg-amd64.img](https://cloud-images.ubuntu.com/bionic/current/bionic-server-cloudimg-amd64.img)

# Set root password and remove cloud-init (if not needed)
sudo virt-customize -a bionic-server-cloudimg-amd64.img --root-password password:coolpass
sudo virt-customize -a bionic-server-cloudimg-amd64.img --uninstall cloud-init

```

---

## VM Life-cycle Management

### Define and Start a VM

If you have an XML configuration file, use these commands:

```bash
# Register the VM from an XML file
virsh define vm.xml

# Start the VM
virsh start bionic-vm

```

### List and Console Access

```bash
# List all virtual machines
virsh list --all

# Connect to the serial console
virsh console bionic-vm

```

> **Tip:** To exit the console, use `Ctrl` + `Alt Gr` + `]` (or `Ctrl` + `]`).

### Shutdown and Stop

```bash
# Graceful shutdown (sends ACPI signal)
virsh shutdown bionic-vm

# Hard stop (equivalent to pulling the power plug)
virsh destroy bionic-vm

```

---

## Networking

### Virtual Networks

View available networks managed by Libvirt:

```bash
virsh net-list --all

```

The default configuration usually uses a NAT bridge (`virbr0`):

```xml
<network>
  <name>default</name>
  <forward mode='nat'/>
  <bridge name='virbr0' stp='on' delay='0'/>
  <ip address='192.168.122.1' netmask='255.255.255.0'>
    <dhcp>
      <range start='192.168.122.2' end='192.168.122.254'/>
    </dhcp>
  </ip>
</network>

```

### Guest Network Configuration (Netplan)

Inside the Ubuntu guest, configure `/etc/netplan/01-netcfg.yaml`:

```yaml
network:
  version: 2
  renderer: networkd
  ethernets:
    ens2:
      dhcp4: true

```

Apply the configuration:

```bash
sudo netplan --debug apply

```

### Remote Access

Identify the IP address from the host using ARP:

```bash
arp -na | grep virbr0
# Example: ? (192.168.122.175) at 52:54:00:5e:cc:8d [ether] on virbr0

# SSH from host to guest
ssh root@192.168.122.175

```

---

## Troubleshooting: Shutdown Issues

If `virsh shutdown` does not work and you are forced to use `virsh destroy`, verify the following:

1. **ACPI Features:** Ensure the VM XML has ACPI enabled:
```xml
<features>
  <acpi/>
  <apic/>
</features>

```


2. **Guest Agent:** Install `qemu-guest-agent` inside the VM.
3. **Shutdown Timeout:** Check `/etc/init.d/libvirt-guests` settings:
```bash
ON_SHUTDOWN=shutdown
SHUTDOWN_TIMEOUT=300

```



```
