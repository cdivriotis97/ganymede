# InfluxDB Operations Guide

This guide covers essential operations for managing InfluxDB, including database creation, data manipulation, and best practices.

---

## Database Management

### Create a Database
To initialize a new database, execute the following command:

```sql
CREATE DATABASE draas

```

### Retention Policies

Retention policies (RP) define how long data is stored. To set a 3-year retention period as the default for the `draas` database:

```sql
USE draas
CREATE RETENTION POLICY "3years" ON "draas" DURATION 1095d REPLICATION 1 DEFAULT

```

---

## Data Manipulation

### Deleting Data Points

!!! warning "Important"
In InfluxDB, you cannot delete a specific field value. You must delete the **entire point**. Furthermore, you can only use `time` and `tags` in the `WHERE` clause.

**How to delete corrupted points :**

1. **Query the timestamps first**:

```sql
SELECT * FROM "DATABASE" WHERE xxxxx > 0 ORDER BY time DESC LIMIT 100

```

2. **Delete using the timestamp**:

```sql
DELETE FROM "DATABASE" WHERE time = '2022-07-14T14:55:49.142723763Z'

```

3. **Delete using Nanoseconds**:

```bash
# Enter influx with nanosecond precision
influx --precision ns
# Then run the delete
DELETE FROM "matable" WHERE time = 1657809948537456939

```

### Inserting Data

Data is added using the Line Protocol.

```sql
-- Format: INSERT <measurement> <fields> <timestamp>
INSERT DATABASE xxxxx=45984 1656637200000000000

```

---

## Backup and Restore

The **portable** format is recommended for all backup operations.

* **Backup**: `influxd backup -portable -db pdu /root/influxbkp`
* **Restore**: `influxd restore -portable -db pdu /root/influxbkp`

---

## Core Concepts

* **Measurement**: Similar to a SQL Table.
* **Fields**: The actual data (e.g., temperature). **Not indexed.**
* **Tags**: Key-value metadata. **Indexed.**
* **Point**: A single record (Measurement + Tags + Fields + Time).
* **Series**: A collection of points sharing the same measurement and tags.

---

## Database Design Best Practices

### Optimize Series Cardinality

Series cardinality is the total number of unique tag combinations. High cardinality causes high memory usage and crashes.

* **Do not** use tags for highly variable data (like random IDs, specific sensor values, or timestamps).
* **Do** use tags for data you frequently filter or group by.

---