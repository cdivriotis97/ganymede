# Nginx and Let's Encrypt Guide

This guide explains how to secure an Nginx web server with free SSL/TLS certificates provided by **Let's Encrypt** using the **Certbot** client.

## Overview of Let's Encrypt

Let's Encrypt is a free, automated, and open Certificate Authority (CA). The most common way to obtain a certificate is via the **HTTP-01 challenge**, where Let's Encrypt verifies domain ownership by accessing a specific file on your server via Port 80.

---

## Installation and Setup

### 1. Install Certbot

You need the Certbot client and the Nginx plugin.

```bash
# For Ubuntu/Debian
sudo apt update
sudo apt install certbot python3-certbot-nginx

# For CentOS/RHEL
sudo dnf install certbot python3-certbot-nginx

```

### 2. Configure Nginx

Ensure your Nginx server block (`/etc/nginx/sites-available/default` or similar) has the correct `server_name` defined:

```nginx
server {
    listen 80;
    server_name example.com www.example.com;
}

```

### 3. Obtain the Certificate

Run Certbot to fetch the certificate and automatically update your Nginx configuration.

```bash
sudo certbot --nginx -d example.com -d www.example.com

```

* **--nginx**: Use the Nginx plugin for authentication and installation.
* **-d**: Specifies the domain names you want to secure.

---

## Understanding Rate Limits

There is often a misunderstanding regarding Let's Encrypt limits. It is **not** limited to 5 certificates total. Here are the actual primary limits:

| Limit Type | Threshold | Description |
| --- | --- | --- |
| **Certificates per Domain** | 50 per week | Total certificates issued for a registered domain (e.g., example.com). |
| **Duplicate Certificates** | 5 per week | Re-issuing a certificate for the exact same list of hostnames. |
| **Failed Validations** | 5 per hour | Number of failed attempts to verify domain ownership. |

> [!TIP]
> If you are testing your configuration, use the `--staging` flag to avoid hitting these limits during troubleshooting.

---

## Manual Nginx Configuration (Optional)

If you prefer not to let Certbot modify your files (like me, it's the most preferable way I think), use the following template for a secure SSL server block : 

```nginx
server {
    listen 443 ssl http2;
    server_name example.com;

    # Certificate paths
    ssl_certificate /etc/letsencrypt/live/example.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/example.com/privkey.pem;

    # Security enhancements
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_prefer_server_ciphers on;
    add_header Strict-Transport-Security "max-age=31536000" always;

    location / {
        # Your application configuration
    }
}

# Redirect HTTP to HTTPS
server {
    listen 80;
    server_name example.com;
    return 301 https://$host$request_uri;
}

```

---

## Maintenance and Renewal

Let's Encrypt certificates expire every **90 days**. Certbot usually installs a systemd timer or cron job to handle this automatically.

### Test Renewal

Verify that the renewal process works correctly:

```bash
sudo certbot renew --dry-run

```

### List Certificates

To see all certificates managed by Certbot and their expiration dates:

```bash
sudo certbot certificates

```

!!! info "Security Note"
Always ensure Port 80 remains open even after switching to HTTPS. Let's Encrypt requires it to perform the automated renewal challenges.