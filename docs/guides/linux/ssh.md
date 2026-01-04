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

    Isolation: Never use the same SSH key for every server. Generate a unique key pair for each service (GitHub, VPS, etc.).

    Local Config: Use your ~/.ssh/config to disable dangerous features like ForwardAgent and UseRoaming (which can expose keys in MITM scenarios).

    Strict Checking: Always use StrictHostKeyChecking yes to ensure you are alerted if a server's fingerprint changes.

## Audit and Verification

Applying a configuration is not enough; you must verify that it is active and correctly implemented.

    SSH-Audit: Use [ssh-audit](https://www.sshaudit.com/) to perform a deep scan of your server. It will identify weak ciphers or outdated protocols and provide a security score. Your goal is a "Perfect" or "A" rating.

    Nmap: You can quickly verify the algorithms your server advertises to the world with the Nmap Scripting Engine (NSE): 
    ```
    nmap --script ssh2-enum-algos -sV -p 22 <your-server-ip> 
    ```
    This tool confirms that only your chosen secure ciphers (like Chacha20) are visible to potential attackers.

Conclusion

SSH hardening is about reducing your attack surface to the absolute minimum. By moving to modern cryptographic standards and regularly auditing your exposure with sshaudit and nmap, you turn your remote access into a truly secure gateway.