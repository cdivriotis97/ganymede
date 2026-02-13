# Algorithms Cookbook

---

## Use Cases

Each algorithm in this cookbook serves a unique purpose. Below is an overview of why we use them and their specific roles in network environments.

### 1. [Dijkstra's Shortest Path Algorithm](./dijkstra.md)
* **Primary Use:** Finding the most efficient path between two points in a graph.
* **Networking Application:** 
    * **Routing Protocols:** It is the core of **OSPF (Open Shortest Path First)** and **IS-IS**. Routers use it to calculate the best path for data packets to travel through a complex web of connections.

### 2. [Decision Tree Classification](./decision-tree.md)
* **Primary Use:** Simple but powerful predictive modeling for categorical data.
* **Networking Application:**
    * **Traffic Classification:** Helping firewalls decide whether to allow or block a packet based on specific rules (Port, Protocol, IP).
    * **Basic Troubleshooting:** Creating automated "if-then" logic to identify if a network issue is hardware or software-related.

### 3. [Random Forest Algorithm](./random_forest.md)
* **Primary Use:** Robust classification and regression by combining multiple decision trees.
* **Networking Application:**
    * **Intrusion Detection Systems (IDS):** Because it is harder to fool than a single tree, it is used to detect sophisticated **DDoS attacks** or malware signatures.
    * **Predictive Maintenance:** Analyzing historical network logs to predict when a server or a switch is likely to fail.
