# MulePay Distributed Cloud Architecture

## 1. CAP Theorem Trade-offs (Consistency vs. Availability)
As a financial platform, MulePay prioritizes **Consistency and Partition Tolerance (CP)**. Financial regulations dictate that all users must see their exact wallet balances simultaneously. In the event of a network partition, MulePay will temporarily block transactions (sacrificing Availability) rather than risk processing duplicate transfers or overdrafts.

## 2. Replication Strategy
MulePay utilizes an **Active-Passive (Master-Slave) Multi-AZ Replication** setup:
* **Primary Node (Read-Write):** Handles all ACID-compliant transaction inserts and locking mechanisms.
* **Read Replicas (Asynchronous):** Handle heavy read workloads, such as generating monthly statements and querying the JSONB session metadata. 
* **Failover:** If the primary node goes down, a synchronized replica is promoted to Primary with zero data loss.

## 3. Sharding (Horizontal Partitioning)
To handle millions of concurrent users, the `transactions` table is horizontally sharded by geographic region using PostgreSQL native partitioning. This ensures African transactions are localized to an AWS af-south-1 database cluster, while North American transactions route to us-east-1, reducing latency.