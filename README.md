# MulePay - Cloud-Scale Advanced Database Systems Portfolio
Student Name: Erighe Oghale | Matric No / ID: 301922842
Academic Session: 2026/2027 | Course: MIT 8103
# MulePay Core Database System

## Project Overview
This repository contains the database architecture and implementation for **MulePay**, a cloud-scale digital wallet and payment processing platform. The project demonstrates a progression from a foundational relational schema to a highly available, distributed cloud architecture.

## Portfolio Implementations

* **Portfolio 1 & 2: Relational Schema & Constraints**
  Implemented a robust PostgreSQL schema with strict `CHECK` constraints (e.g., KYC status, positive balances, exact casing for transaction states) and foreign key relationships to ensure data integrity across users, wallets, and ledger entries.

* **Portfolio 3: Transactions & Concurrency**
  Developed ACID-compliant P2P transfer scripts utilizing row-level locking (`FOR UPDATE`) and double-entry ledger Common Table Expressions (CTEs) to prevent race conditions and overdrafts during concurrent processing.

* **Portfolio 4: NoSQL & Advanced Data Models**
  Integrated a NoSQL Document model using PostgreSQL's `JSONB` data type to handle flexible, unstructured session metadata (device configurations, IP routing, and user app preferences) without rigid schema alterations.

* **Portfolio 5: Distributed Cloud Architecture**
  Designed a highly available cloud architecture featuring active-passive Multi-AZ replication for read-heavy workloads. Implemented geographic horizontal sharding via PostgreSQL native `PARTITION BY LIST` to route transactions (e.g., Africa vs. North America) for reduced latency and data sovereignty.

## Execution Evidence
Screenshots validating successful script executions, transaction commits, and distributed shard routing are located within the `screenshots/` directory of their respective portfolio folders.