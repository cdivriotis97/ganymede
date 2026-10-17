# SSH on Linux

When you deploy a new Virtual Private Server (VPS), it usually comes with default settings that prioritize compatibility over security. In an era of constant automated attacks, these defaults are a liability. Based on the security principles shared by [Gammenion](https://gammenion.github.io/post/ssh-hardening/), this guide explains how to secure your SSH gateway for both the server and the client.

## Server-Side: Building the Fortress

Security starts with distrusting the default host keys provided by your VPS vendor.
Regenerate Host Keys: VPS images sometimes reuse the same host keys. Delete existing ones and generate a fresh Ed25519 key: 
```
ssh-keygen -t ed25519 -f /etc/ssh/ssh_server_ed25519 -o -a 128 
```

The Hardened Server Configuration: Modify your /etc/ssh/sshd_config to enforce strict cryptographic standards. Below is a production-ready configuration:


```ini
# File: /etc/ssh/sshd_config
# Basic Security
Port 22
Protocol 2
LoginGraceTime 120
StrictModes yes
MaxAuthTries 3

# Identity Files
HostKey /etc/ssh/ssh_server_ed25519

# Authentication (Keys only, no passwords)
PermitRootLogin no
PubkeyAuthentication yes
PasswordAuthentication no
PermitEmptyPasswords no
ChallengeResponseAuthentication no
UsePAM no

# Access Control (Whitelisting)
# Important: Ensure your user is in this group before applying!
AllowGroups ssh-allowed

# Hardened Cryptography (KEX, Ciphers, and MACs)
KexAlgorithms curve25519-sha256@libssh.org
Ciphers chacha20-poly1305@openssh.com
MACs hmac-sha2-512-etm@openssh.com

# Logging and Features
UsePrivilegeSeparation yes
LogLevel VERBOSE
X11Forwarding no
PermitTunnel no
PrintMotd no

# Inactivity Management
ClientAliveInterval 300
ClientAliveCountMax 0
TCPKeepAlive yes

```

## Client-Side: Protecting the Keyholder

Hardening is a two-way street. Your local machine must also be configured to prevent credential leakage.

* Isolation: Never use the same SSH key for every server. Generate a unique key pair for each service (GitHub, VPS, etc.).
* Local Config: Use your ~/.ssh/config to disable dangerous features like ForwardAgent and UseRoaming (which can expose keys in MITM scenarios).
* Strict Checking: Always use StrictHostKeyChecking yes to ensure you are alerted if a server's fingerprint changes.

## Audit and Verification

Applying a configuration is not enough; you must verify that it is active and correctly implemented.

* SSH-Audit: Use [ssh-audit](https://www.sshaudit.com/) to perform a deep scan of your server. It will identify weak ciphers or outdated protocols and provide a security score. Your goal is a "Perfect" or "A" rating.
* Nmap: You can quickly verify the algorithms your server advertises to the world with the Nmap Scripting Engine (NSE): 
```
nmap --script ssh2-enum-algos -sV -p 22 <your-server-ip> 
```
This tool confirms that only your chosen secure ciphers (like Chacha20) are visible to potential attackers.

## Tunneling

* Access remote server behind the firewall.

For example access app running on 8080 port for server x.y.z.a

`ssh -L 9000:localhost:8080 ec2-user@x.y.z.a`

Now just open the http://localhost:9000

* Expose the local port to remote server

`ssh -R 9000:localhost:3000 user@example.com`

Now the remote server could access you local app on remote address localhost:9000

## Port forwarding

- Expose local port 2222, forwarding to `10.0.0.179:22` using the remote server  `54.82.45.10`:

`ssh -L 127.0.0.1:2222:10.0.0.179:22 core@54.82.45.109`

