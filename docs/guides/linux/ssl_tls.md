# SSL/TLS Certificates Cheatsheet

## Common Extensions Reference

| Extension | Format | Description |
|-----------|--------|-------------|
| .pem, .crt, .cer | **PEM** (Base64) | Most common format. Includes -----BEGIN CERTIFICATE-----. |
| .der | **DER** (Binary) | Binary version of a certificate. Does not contain text headers. |
| .p7b, .p7c | **PKCS#7** | Contains certificates and chain certificates, but **no private key**. |
| .pfx, .p12 | **PKCS#12** | Password-protected container for certificate, intermediates, and **private key**. |

---

## Inspection Commands
Use these commands to view the content of a certificate without opening the file.

=== "PEM Format"
    ```bash
    openssl x509 -in certificate.pem -text -noout
    ```

=== "DER Format"
    ```bash
    openssl x509 -inform der -in certificate.der -text -noout
    ```

=== "PKCS#12 (PFX)"
    ```bash
    openssl pkcs12 -info -in certificate.pfx
    ```

=== "CSR (Signing Request)"
    ```bash
    openssl req -text -noout -verify -in request.csr
    ```

---

## Conversion Commands
Convert between different formats to meet your server's requirements.

### PEM / DER
Convert between ASCII and Binary formats.

```bash
# PEM to DER
openssl x509 -outform der -in certificate.pem -out certificate.der

# DER to PEM
openssl x509 -inform der -in certificate.der -out certificate.pem

```

### PFX (PKCS#12) Conversions

Useful for migrating between Windows (IIS) and Linux (Apache/Nginx).

```bash
# Extract everything from PFX to PEM
openssl pkcs12 -in certificate.pfx -out certificate.pem -nodes

# Convert PFX to PKCS#8 (Two steps)
openssl pkcs12 -in cert.pfx -nocerts -nodes -out temp.pem
openssl pkcs8 -in temp.pem -topk8 -nocrypt -out cert.pk8

```

### P7B (PKCS#7) Conversions

```bash
# P7B to PEM
openssl pkcs7 -print_certs -in certificate.p7b -out certificate.pem

# P7B to PFX (Requires the private key)
openssl pkcs7 -print_certs -in cert.p7b -out cert.cer
openssl pkcs12 -export -in cert.cer -inkey privateKey.key -out cert.pfx -certfile cacert.cer

```

---

## Creation and Generation

Commands for common administrative tasks.

### Generate a New Private Key and CSR

```bash
openssl req -out request.csr -new -newkey rsa:2048 -nodes -keyout privateKey.key

```

### Generate a Self-Signed Certificate

```bash
openssl req -x509 -sha256 -nodes -days 365 -newkey rsa:2048 -keyout privateKey.key -out certificate.crt

```

---

## Network Testing

Check SSL certificates directly on a remote server.

### Check a Remote Website

```bash
openssl s_client -connect [www.google.com:443](https://www.google.com:443)

```

### Verify if a Key matches a Certificate

To ensure a private key belongs to a specific certificate, compare the MD5 hash of the modulus:

```bash
openssl x509 -noout -modulus -in certificate.crt | openssl md5
openssl rsa -noout -modulus -in privateKey.key | openssl md5

```
!!! info "Security Note"

    Always protect your .key and .pfx files. They contain sensitive private data that should never be shared or committed to version control systems.

```

