# Fedora CoreOS

Tired of complex server management and manual updates? **Fedora CoreOS (FCOS)** is the solution. This is a **minimal, automatically updating, container-focused** OS, set to be the **future of server infrastructure**.

## Why FCOS is a Game Changer:

* **Atomic Updates:** Managed by **rpm-ostree**, the entire OS updates atomically and automatically in the background, minimizing risk and maximizing uptime.
* **Immutable and Secure:** The read-only root filesystem enforces security, and all workloads run securely in containers.
* **Enterprise Proven:** The CoreOS concept forms the immutable host OS for **Red Hat OpenShift (via RHCOS)**, proving its scalability and reliability.
* **Perfect for the Edge:** Its small footprint, automation, and stability make FCOS the **ideal solution for edge computing deployments**.

## Seamless Provisioning and Security:

FCOS uses a declarative workflow:

1.  **Define:** Create your server state in a simple YAML using the Butane specification (network(s), users, containers using Podman Quadlet, ...)
2.  **Generate:** Use the **`butane` command** to produce the final Ignition JSON (`.ign` file).
3.  **Deploy:** Inject the config during installation using **`coreos-installer customize`**.

The container engine, **Podman**, enables **rootless containers** & **auto-update**, drastically enhancing security and isolation.

---

**FCOS delivers automation, security, and proven stability.**

➡️ **See my implementation example:** [https://github.com/snoopyx21/coreos-sample](https://github.com/snoopyx21/coreos-sample)

📚 **Learn More:** [https://docs.fedoraproject.org/en-US/fedora-coreos/](https://docs.fedoraproject.org/en-US/fedora-coreos/)

