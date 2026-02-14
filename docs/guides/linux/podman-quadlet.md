# Podman Quadlet

Podman Quadlet is the essential tool for declarative deployment and management of Podman containers, especially in rootless mode, by leveraging the power of `systemd`. It effectively replaces the deprecated `podman generate systemd` command, simplifying the setup process dramatically.

### What is Quadlet?

Quadlet allows you to use simple configuration files (called *unit files* and ending in `.container`, `.pod`, `.volume`, etc.) to describe how a container or pod should be launched by `systemd`.

These files are placed in `~/.config/containers/systemd/` (for user services) or `/etc/containers/systemd/` (for system services). `systemd` reads them, converts them into standard service files (`.service`), and manages the container's lifecycle (startup on boot, automatic restarts, etc.).

### Key Feature: Automated Updates with `AutoUpdate=registry`

To ensure your services remain up-to-date without manual intervention, Quadlet simplifies the auto-update configuration.

By adding the option `AutoUpdate=registry` within the `[Container]` section, you instruct Podman to check for a newer image with the same tag in the registry when the `podman auto-update` command is run. This feature is crucial for maintaining security and stability with minimal effort.

## Monitoring Examples with Quadlet

Quadlet is perfectly suited for self-hosting and monitoring environments. Here are configuration examples for deploying Grafana and Uptime Kuma using Quadlet files, allowing you to manage them easily with `systemctl --user`.

### Grafana Container (`grafana.container`)

This file describes a standalone Grafana container with data persistence and automated image updates enabled.

  * **My implementation example:**  [cdivriotis97/podman-quadlet-grafana](https://www.google.com/search?q=https://github.com/cdivriotis97/podman-quadlet-grafana)

<!-- end list -->

```ini
# File: ~/.config/containers/systemd/grafana.container

[Container]
Image=grafana/grafana:latest
ContainerName=grafana
Volume=%h/data/grafana:/var/lib/grafana:Z
PublishPort=3000:3000
AutoUpdate=registry

[Service]
Restart=always

[Install]
WantedBy=default.target
```

### Uptime Kuma Container (`uptime-kuma.container`)

Uptime Kuma is a popular, lightweight monitoring tool. Here is the simplified Quadlet configuration for its deployment.

  * **My implementation example:**  [cdivriotis97/podman-quadlet-uptime-kuma](https://github.com/cdivriotis97/podman-quadlet-uptime-kuma)

<!-- end list -->

```ini
# File: ~/.config/containers/systemd/uptime-kuma.container

[Container]
Image=louislam/uptime-kuma:2
ContainerName=uptime-kuma
Volume=%h/data/uptime-kuma:/app/data:Z
PublishPort=3001:3001
AutoUpdate=registry
Environment=NODE_ENV=production

[Service]
Restart=always

[Install]
WantedBy=default.target
```

### Deployment Steps (Common for both):

1.  **Place the File:** Save the `.container` file in `~/.config/containers/systemd/`.
2.  **Reload:** `systemctl --user daemon-reload`
3.  **Start & Enable:** `systemctl --user enable --now [container_name].service` (e.g., `grafana.service`)
4.  **Auto-Update:** Run `podman auto-update` periodically to check for and apply new image versions.

!!! tip

    Use `/usr/libexec/podman/quadlet --dryrun` to check any issue in the unit file.