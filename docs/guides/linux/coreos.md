# Fedora CoreOS (FCOS)

Fedora CoreOS is a minimal, container-focused operating system designed for secure, scalable deployments. It operates on an **immutable root filesystem** and follows a **declarative provisioning** model.

## Core Technical Stack

| Component | Technology | Function |
| --- | --- | --- |
| **OS Management** | `rpm-ostree` | Atomic updates and image-based rollbacks |
| **Provisioning** | `Ignition` | First-boot JSON configuration engine |
| **Container Engine** | `Podman` | Native Quadlet support and rootless execution |
| **Config Specs** | `Butane` | Human-readable YAML transpiled to Ignition |

---

## Infrastructure as Code (IaC) Workflow

FCOS bypasses traditional interactive installers. Provisioning is handled via a three-step pipeline:

### 1. Definition (Butane)

The `.bu` file defines the desired state: users, SSH keys, systemd units, and network configurations.

```yaml
variant: fcos
version: 1.5.0
passwd:
  users:
    - name: core
      password_hash: changeme
      ssh_authorized_keys:
        - ssh-ed25519 AAAAC3N...
storage:
  files:
    # Configuration IP Statique pour l'interface ens33
    - path: /etc/NetworkManager/system-connections/ens33.nmconnection
      mode: 0600
      contents:
        inline: |
          [connection]
          id=ens33
          type=ethernet
          interface-name=ens33
          [ipv4]
          address1=192.168.1.100/24,192.168.1.1
          dns=8.8.8.8;8.8.4.4;
          method=manual
systemd:
  units:
    - name: sample.service
      enabled: true
      contents: |
        [Unit]
        Description=System Check
        [Service]
        ExecStart=/usr/bin/echo "FCOS Initialized with Static IP"
        [Install]
        WantedBy=multi-user.target

```

> [!IMPORTANT]
> **Sécurité :** L'utilisation d'un mot de passe est utile pour le débogage en console locale (TTY), mais la clé SSH reste la méthode recommandée pour l'accès distant. Le fichier de connexion réseau doit impérativement avoir un `mode: 0600`.

### 2. Transpilation

Convert the YAML into an Ignition JSON file. This is the only format consumed by the OS during the initial boot.

```bash
docker run --interactive --rm quay.io/coreos/butane:release \
  --pretty --strict < config.bu > config.ign

```

### 3. Provisioning

Inject the ignition file during installation.

```bash
sudo coreos-installer install /dev/sda \
  --ignition-file config.ign \
  --copy-network

```

---

## System Life Cycle & Immutability

### Atomic Updates with rpm-ostree

Unlike traditional package managers (`dnf`/`apt`), `rpm-ostree` treats the OS as a versioned filesystem tree.

* **Check current deployment:** `rpm-ostree status`
* **Rollback to previous state:** `rpm-ostree rollback` (requires reboot)
* **Package layering (minimal use recommended):**
```bash
rpm-ostree install net-tools
systemctl reboot

```



### Container Orchestration via Quadlet

FCOS uses **Quadlet** to treat containers as native systemd units. This ensures containers start automatically and follow standard service dependencies.

> [!NOTE]
> Store `.container` files in `/etc/containers/systemd/`. Systemd will automatically generate the corresponding units upon reloading.

---

## Resources & Repositories

* **Sample Implementation:** [cdivriotis97/coreos-sample](https://github.com/cdivriotis97/coreos-sample)
* **Official Documentation:** [Fedora CoreOS Docs](https://docs.fedoraproject.org/en-US/fedora-coreos/)
