# KVM, QEMU, and Libvirt Management

---

## Create a VM from an ISO Image

To install a new virtual machine from an ISO file, use the `virt-install` command.

### Key virt-install Parameters:

| Parameter | Description |
| :--- | :--- |
| `--name` | The unique name of the VM. |
| `--os-type` | Optimizes configuration for an OS type (e.g., 'linux', 'windows'). |
| `--os-variant` | Fine-tuned optimization for specific versions (e.g., 'fedora8', 'win10'). |
| `--ram` | Memory allocated to the guest in MiB. |
| `--vcpus` | Number of virtual CPUs to configure. |
| `--disk path=...` | Storage configuration and path to the media. |
| `--graphics` | Specifies the graphical display (e.g., 'spice', 'vnc' or 'none'). |
| `--location` | Source for the installation (ISO, URL, or local directory). |
| `--extra-args` | Additional kernel command-line arguments for the installer. |



---

## Disk Image Management

### Advanced QEMU-IMG Commands
Check the file type and details:
```bash
sudo file /var/lib/libvirt/images/debian9.img
# Output: QEMU QCOW Image (v3), 10737418240 bytes

```

Convert a disk image format (e.g., raw to qcow2):

```bash
qemu-img convert -f raw -O qcow2 image.raw image.qcow2

```

Resize and verify:

```bash
qemu-img resize bionic-server-cloudimg-amd64.img 20G
qemu-img info bionic-server-cloudimg-amd64.img

```

### Manual QEMU Execution

You can start a VM directly without libvirt for testing purposes:

```bash
qemu-system-x86_64 -m 1024 -hda debian.qcow2 -cdrom debian-inst.iso -boot d

```

---

## Configure a Pre-defined VM Image

Download and customize official cloud images using `virt-customize`:

```bash
wget [https://cloud-images.ubuntu.com/bionic/current/bionic-server-cloudimg-amd64.img](https://cloud-images.ubuntu.com/bionic/current/bionic-server-cloudimg-amd64.img)

# Set root password and remove cloud-init
sudo virt-customize -a bionic-server-cloudimg-amd64.img --root-password password:coolpass
sudo virt-customize -a bionic-server-cloudimg-amd64.img --uninstall cloud-init

```

---

## VM Life-cycle and Snapshots

### Define and Start

```bash
virsh define vm.xml
virsh start bionic-vm

```

### Snapshot Management

Libvirt allows taking snapshots of a running or stopped VM (requires qcow2):

```bash
# Create a snapshot
virsh snapshot-create-as --domain bionic-vm --name "AfterConfig" --description "Initial Setup"

# List snapshots
virsh snapshot-list bionic-vm

# Restore a snapshot
virsh snapshot-revert bionic-vm --snapshotname "AfterConfig"

# Delete a snapshot
virsh snapshot-delete bionic-vm --snapshotname "AfterConfig"

```

### Console Access

```bash
virsh console bionic-vm

```

To exit the console, use `Ctrl` + `Alt Gr` + `]` (or `Ctrl` + `]`).

---

## Networking

### Virtual Networks

```bash
virsh net-list --all

```

Default NAT bridge (`virbr0`) configuration:

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

### Guest Network (Netplan)

Configure `/etc/netplan/01-netcfg.yaml`:

```yaml
network:
  version: 2
  renderer: networkd
  ethernets:
    ens2:
      dhcp4: true

```

Apply: `sudo netplan --debug apply`

---

## Performance and Resource Tuning

### CPU Pinning and Memory

View VM resource usage:

```bash
virsh domstats bionic-vm

```

Set memory limits on the fly:

```bash
virsh setmem bionic-vm 2048M --config --live

```

---

## Troubleshooting: Shutdown Issues

If `virsh shutdown` fails:

1. **ACPI Features:** Ensure the XML has ACPI enabled:
```xml
<features>
  <acpi/>
  <apic/>
</features>

```


2. **Guest Agent:** Install `qemu-guest-agent` inside the VM.
3. **Emergency Stop:** `virsh destroy bionic-vm`
