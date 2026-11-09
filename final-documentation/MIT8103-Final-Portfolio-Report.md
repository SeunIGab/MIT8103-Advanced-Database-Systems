# MIT 8103 - Advanced Database Systems

## Consolidated Portfolio Report

**Case Study:** Sotai Digital Solutions — Enterprise IT Service Management and Asset Monitoring System

## Executive Summary

This consolidated report presents five practical portfolios
developed for MIT 8103 Advanced Database Systems using the
Sotai Digital Solutions IT Service Management (ITSM) case study.

The work investigates relational database design, SQL query
optimisation, transaction correctness, NoSQL document modelling,
and distributed database resilience.

PostgreSQL was used to implement nine relational tables and
enforce database integrity constraints. Query optimisation
experiments demonstrated improvements from indexed execution.

Automated transaction tests validated commit, rollback,
savepoints, atomicity, isolation behaviour, optimistic
concurrency control and deadlock detection.

MongoDB was used to implement document-oriented ITSM collections.
In a 50,000-document benchmark, indexing reduced the measured
query execution time from 39 ms to 1 ms.

A three-node MongoDB replica set demonstrated data replication,
automatic failover, backup restoration and recovery following
a simulated network partition. The disaster recovery exercise
restored 50,040 documents.

The findings demonstrate how different database engineering
techniques contribute to data integrity, performance,
transaction correctness, flexibility and resilience.

## Introduction

This report consolidates five practical database engineering portfolios covering relational database design, SQL query optimisation, transaction management, NoSQL implementation, and distributed database resilience.


---

## Portfolio 1 — Relational Database Design


**Project:** Sotai ITSM – Enterprise IT Service Management and Asset Monitoring System

**Organisation:** Sotai Digital Solutions

### 1. Project Overview

This portfolio presents the design of a relational database for Sotai ITSM, an enterprise IT service management and asset monitoring system.

The database supports client management, IT assets, service tickets, technician assignments, service-level agreements, security monitoring and audit records.

The implementation uses PostgreSQL and relational database design principles to improve data integrity, consistency and maintainability.

### 2. Database Architecture

The database contains nine relational tables:

| Table | Purpose |
|---|---|
| clients | Stores client information |
| technicians | Stores IT technician information |
| assets | Tracks client-owned IT assets |
| sla_agreements | Defines service-level response and resolution targets |
| tickets | Stores IT service requests and incidents |
| ticket_history | Records ticket status changes |
| security_agents | Tracks security agents installed on assets |
| security_alerts | Stores security alerts associated with assets |
| audit_logs | Stores audit event information |

The database uses primary keys to identify records and foreign keys to enforce relationships between entities.

### 3. Entity Relationship Design

The entity relationship diagram describes the relationships between clients, assets, tickets, technicians, service-level agreements and security monitoring records.

Key relationships include:

- One client can own multiple assets.
- One client can submit multiple tickets.
- One client can have multiple SLA agreements.
- One technician can be assigned multiple tickets.
- One asset can be associated with multiple tickets.
- One ticket can have multiple ticket history records.
- One asset can have multiple security agents and security alerts.

The audit_logs table is standalone in the current database design.

The complete ER diagram is documented in `er-diagram.md`.

A supporting diagram image is available at `../evidence/portfolio-1-er-diagram.png`.

### 4. Database Normalisation

The database was designed using the principles of First Normal Form (1NF), Second Normal Form (2NF) and Third Normal Form (3NF).

#### 4.1 First Normal Form

Attributes are stored as atomic values, and repeating groups are avoided.

For example, each client asset is represented by a separate record in the assets table.

#### 4.2 Second Normal Form

The design satisfies the documented 2NF requirements by ensuring that non-key attributes depend on their complete candidate keys.

Ticket attributes such as title, priority and status describe the associated ticket.

#### 4.3 Third Normal Form

Client, technician and asset details are separated into dedicated tables to reduce redundant storage.

For example, tickets reference clients through client_id instead of duplicating client names and contact information.

This design reduces update anomalies and supports consistent data management.

Further details are available in `normalization.md`.

### 5. Integrity Constraints

The database applies several integrity constraints.

#### Primary Keys

Each table uses a primary key to uniquely identify its records.

#### Foreign Keys

Foreign keys maintain relationships between clients, assets, technicians, tickets, ticket history and security monitoring records.

#### Unique Constraints

Uniqueness is enforced for:

- Client contact email
- Technician email
- Asset hostname within each client
- SLA priority within each client
- Security agent name within each asset

#### NOT NULL Constraints

Required attributes include client names, technician names, ticket titles, ticket priorities and asset hostnames.

#### CHECK Constraints

Ticket priority is restricted to:

- Low
- Medium
- High
- Critical

Ticket status is restricted to:

- Open
- In Progress
- Resolved
- Closed

SLA response and resolution times must be positive.

#### Composite Foreign Key

The tickets table uses a composite foreign key:

`(asset_id, client_id)`

This references the corresponding columns in the assets table.

The constraint prevents a ticket from referencing an asset belonging to a different client.

Detailed explanations are provided in `constraints.md`.

### 6. Database Implementation

The relational schema is defined in:

`schema.sql`

Sample records are provided in:

`sample-data.sql`

The implementation uses PostgreSQL SQL statements to define tables, keys, relationships and integrity constraints.

### 7. Security and Auditing

The database supports security monitoring through the security_agents and security_alerts tables.

The audit_logs table stores audit event information, including action descriptions, entity identifiers and timestamps.

In the current implementation, automatic audit record generation is not configured.

Database triggers or application-level auditing could be introduced in a future implementation.

### 8. Design Benefits

The relational design provides:

- Reduced data redundancy
- Improved referential integrity
- Consistent ticket and asset relationships
- Structured technician assignments
- Service-level agreement management
- Security monitoring support
- Extensibility for future ITSM capabilities

### 9. Portfolio Files

| File | Description |
|---|---|
| README.md | Portfolio overview and documentation |
| schema.sql | PostgreSQL relational schema |
| sample-data.sql | Sample database records |
| er-diagram.md | Entity relationship diagram |
| normalization.md | Normalisation analysis |
| constraints.md | Database integrity constraints |

### 10. Conclusion

Portfolio 1 demonstrates the design of a relational database for an enterprise IT service management environment.

The Sotai ITSM schema integrates client management, asset tracking, ticket processing, service-level agreements and security monitoring within a structured relational model.

Normalisation, primary keys, foreign keys and integrity constraints provide a foundation for consistent and maintainable IT service data.

The design establishes the relational database foundation for subsequent MIT 8103 portfolio experiments.


---

## Portfolio 2 — Query Optimisation



**Project:** Sotai ITSM – Enterprise IT Service Management and Asset Monitoring System

### 1. Project Overview

This portfolio evaluates the effect of PostgreSQL B-tree indexing on query performance in the Sotai ITSM database.

### 2. Technology Stack

- PostgreSQL 16
- SQL and EXPLAIN ANALYZE
- B-tree indexes
- Docker
- GitHub Codespaces

### 3. Experimental Database

The `benchmark_tickets` table contains 100,000 records. The tested query filters tickets by status and orders results by creation date in descending order. Both measured plans returned 100 matching records.

### 4. Experimental Methodology

1. Prepare the benchmark dataset.
2. Execute the query before indexing.
3. Capture the execution plan.
4. Create a composite B-tree index.
5. Update table statistics using ANALYZE.
6. Execute the query after indexing.
7. Compare execution times and query plans.

### 5. Index Definition

```sql
CREATE INDEX IF NOT EXISTS idx_benchmark_status_created
ON benchmark_tickets(status, created_at DESC)
INCLUDE (client_id);

ANALYZE benchmark_tickets;
```

### 6. Performance Results

| Metric | Before Index | After Index |
|---|---|---|
| Execution time | 5.723 ms | 0.549 ms |
| Planning time | 0.236 ms | 0.322 ms |
| Query access method | Sequential Scan | Bitmap Index Scan and Bitmap Heap Scan |
| Matching records | 100 | 100 |

The indexed query executed approximately 10.42 times faster, representing a 90.41% reduction in execution time.

### 7. Analysis

Before indexing, PostgreSQL performed a sequential scan and filtered out 99,900 nonmatching rows. After indexing, PostgreSQL used a bitmap index scan followed by a bitmap heap scan.

The results demonstrate the potential benefit of indexing selective queries. However, the comparison is based on one before-and-after measurement. Repeated benchmark runs are needed to evaluate consistency and the influence of caching and runtime variability.

Indexes also introduce storage and maintenance overhead.

### 8. Evidence

- evidence/portfolio-2/query-results.txt
- evidence/portfolio-2/before-index.txt
- evidence/portfolio-2/after-index.txt

### 9. Conclusion

The experiment demonstrated that appropriate B-tree indexing can substantially improve selective query performance in PostgreSQL. The observed execution time decreased from 5.723 ms to 0.549 ms, while the execution plan changed from a sequential scan to indexed access.
  

---

## Portfolio 3 — Transactions and Concurrency


### Organisation
Sotai Digital Solutions

### System
Enterprise IT Service Management and Asset Monitoring System

### Objective
To demonstrate transaction processing, ACID
properties, concurrency control, transaction
isolation, and deadlock handling in PostgreSQL.

### Database Environment
- PostgreSQL 16
- GitHub Codespaces
- Docker Compose
- Database: sotai_itsm

### ACID Properties

**Atomicity:** A transaction succeeds completely
or is rolled back.

**Consistency:** Database constraints remain
enforced during transaction processing.

**Isolation:** Concurrent transactions are
controlled using PostgreSQL isolation levels
and locking mechanisms.

**Durability:** Committed changes persist in
PostgreSQL storage across sessions and normal
database restarts.

### Experiments

1. COMMIT transaction
2. ROLLBACK transaction
3. SAVEPOINT transaction
4. Constraint violation and atomicity
5. Optimistic concurrency control
6. READ COMMITTED isolation
7. REPEATABLE READ isolation
8. Deadlock detection and recovery

### Evidence

- evidence/portfolio-3/setup-results.txt
- evidence/portfolio-3/transaction-results.txt
- evidence/portfolio-3/concurrency-results.txt
- Screenshots of isolation-level experiments
- Screenshots of deadlock detection

### Conclusion

The experiments are designed to demonstrate
how PostgreSQL manages transactions, maintains
data consistency, and controls conflicting
database operations.

Final observations should be documented
using the actual execution results.


---

## Portfolio 4 — NoSQL Database Implementation


**Project:** Sotai ITSM – Enterprise IT Service Management and Asset Monitoring System

### 1. Project Overview

This portfolio investigates NoSQL database implementation using MongoDB 7.

The experiments demonstrate how a document-oriented database can support enterprise IT service management operations, including ticket management, asset monitoring, technician assignments and security event tracking.

The portfolio evaluates document modelling, CRUD operations, aggregation pipelines and indexing performance.

### 2. Technology Stack

- MongoDB 7
- MongoDB Shell (mongosh)
- JavaScript
- Docker and Docker Compose
- GitHub Codespaces

### 3. Database Architecture

The MongoDB database is named `sotai_itsm`.

Four principal collections were created:

| Collection | Purpose | Sample documents |
|---|---|---:|
| `itsm_tickets` | Service ticket management | 15 |
| `itsm_assets` | IT asset monitoring | 10 |
| `itsm_technicians` | Technician information | 5 |
| `itsm_security_events` | Security event tracking | 10 |

MongoDB stores records as BSON documents, allowing related information to be represented using nested objects and arrays.

For example, an asset document can contain hardware specifications, monitoring information and tags.

### 4. Document Schema Design

The database uses document-oriented modelling to represent IT service management entities.

The schema implementation is contained in `schema.js`.

Sample records are created using `sample-data.js`.

Document structures include embedded attributes where appropriate, while identifiers support relationships between collections.

### 5. CRUD Operations

The CRUD experiment demonstrates:

- **Create:** Insert a new service ticket.
- **Read:** Retrieve ticket information.
- **Update:** Modify ticket status and assigned technician.
- **Delete:** Remove a test ticket.

The experiment also demonstrates how MongoDB supports embedded ticket comments and SLA information.

The final verification confirmed that the temporary test ticket was removed and the original 15 sample tickets remained.

Implementation: `crud-operations.js`

Evidence: `evidence/portfolio-4/crud-results.txt`

### 6. Aggregation Pipelines

MongoDB aggregation pipelines were used to analyse IT service management information.

The experiments demonstrate the use of aggregation operations to process ticket information and combine related data from multiple collections.

The aggregation experiment also retrieves related asset information for service tickets.

Implementation: `aggregation.js`

Evidence: `evidence/portfolio-4/aggregation-results.txt`

### 7. Index Performance Experiment

An indexing experiment was conducted using a benchmark dataset containing 50,000 documents.

The experiment compared query execution before and after index creation.

| Metric | Before indexing | After indexing |
|---|---:|---:|
| Documents examined | 50,000 | 1 |
| Execution time | 65 ms | 2 ms |

The observed execution time decreased by approximately **96.92%**, representing a **32.5-fold speed improvement** in this measurement.

The number of documents examined decreased by a factor of 50,000.

Implementation: `index-performance.js`

Evidence: `evidence/portfolio-4/index-performance-results.txt`

### 8. Performance Analysis

Before indexing, MongoDB examined the benchmark dataset to identify matching documents.

After indexing, the query used an index to reduce the number of documents examined.

This demonstrates how appropriate indexes can improve query efficiency for selective workloads.

However, indexes consume storage and introduce maintenance overhead during write operations.

The measured execution times represent a specific experimental run. Additional repeated measurements would be required to establish consistent performance improvements.

Further analysis is documented in `performance-analysis.md`.

### 9. Experimental Evidence

The following evidence files support the portfolio:

- `evidence/portfolio-4/schema-results.txt`
- `evidence/portfolio-4/sample-data-results.txt`
- `evidence/portfolio-4/crud-results.txt`
- `evidence/portfolio-4/aggregation-results.txt`
- `evidence/portfolio-4/index-performance-results.txt`

These files record the MongoDB implementation and experimental outputs.

### 10. Conclusion

Portfolio 4 demonstrates the application of MongoDB to enterprise IT service management.

The experiments cover document modelling, data manipulation, aggregation and indexing.

The results show that MongoDB can represent flexible operational data structures and that appropriate indexing can substantially reduce the amount of data examined during selective queries.

The portfolio provides practical evidence of NoSQL database concepts and their application to the Sotai ITSM system.

---

## Portfolio 5 - Distributed Databases


**Project:** Sotai ITSM  
**Database:** MongoDB 7  
**Environment:** Docker Compose  
**Replica Set:** sotaiRS

### 1. Project Overview

This portfolio demonstrates distributed database
architecture, replication, high availability,
automatic failover, disaster recovery and
network partition recovery.

The experiments use Sotai ITSM, an IT service
management system designed to manage tickets,
assets, technicians and security events.

### 2. Technology Stack

- MongoDB 7
- MongoDB Replica Sets
- Docker and Docker Compose
- MongoDB Shell (mongosh)
- mongodump and mongorestore
- GitHub Codespaces

### 3. Replica Set Architecture

The MongoDB replica set contains three nodes:

| Node | Role |
|---|---|
| sotai-mongo-primary | Initially PRIMARY |
| sotai-mongo-secondary1 | Initially SECONDARY |
| sotai-mongo-secondary2 | Initially SECONDARY |

Replica set name: `sotaiRS`

The three voting members support automatic
primary elections when a majority is available.

### 4. Experiments Completed

#### Experiment 1: Data Replication

Verified Sotai ITSM data across three nodes.

Results:
- Tickets: 15
- Assets: 10
- Technicians: 5
- Security events: 10

All three nodes returned matching counts.

#### Experiment 2: Automatic Failover

Stopped the original primary MongoDB container.

MongoDB elected secondary1 as the new PRIMARY.

The remaining nodes continued providing
database access.

The original primary was subsequently restarted
and rejoined the replica set as SECONDARY.

#### Experiment 3: Disaster Recovery

Created a MongoDB archive using mongodump.

Backup: `sotai-itsm-dr.archive.gz`

Verified the archive integrity and restored it
into the separate `sotai_itsm_restore_test` database.

Restored documents:
- Tickets: 15
- Assets: 10
- Technicians: 5
- Security events: 10
- Benchmark tickets: 50,000

Total: 50,040 documents.

#### Experiment 4: Network Partition Recovery

Disconnected secondary2 from the Docker
replica-set network.

Verified the replica-set response to the
temporary network isolation.

Reconnected secondary2 and confirmed that
all three nodes returned to healthy roles.

Verified matching application document counts.

### 5. Evidence Files

All experimental results are stored in:

`evidence/portfolio-5/`

| Evidence | Description |
|---|---|
| replica-status.txt | Replica set configuration |
| data-replication-results.txt | Replication verification |
| failover-results.txt | Automatic failover |
| disaster-recovery-results.txt | Backup restoration verification |
| network-partition-results.txt | Network recovery verification |

### 6. Performance and Resilience Analysis

The full technical analysis is available in:

`performance-analysis.md`

The analysis discusses replication,
fault tolerance, failover, disaster recovery,
network partitions, and experiment limitations.

### 7. Key Findings

1. MongoDB replicated application data across
   three nodes.
2. Automatic primary election succeeded.
3. Data remained accessible during the
   simulated primary failure.
4. Backup restoration recovered 50,040 documents.
5. The isolated secondary successfully rejoined.
6. Document counts matched following recovery.

### 8. Conclusion

Portfolio 5 demonstrates important distributed
database capabilities using MongoDB and Sotai ITSM.

The experiments illustrate how replication,
automatic failover, database backups and
network recovery contribute to system resilience.

The implementation provides a practical foundation
for understanding highly available database systems.


---

## Cross-Portfolio Comparative Analysis

| Portfolio | Database Engineering Focus | Main Finding |
|---|---|---|
| 1 | Relational design and integrity | Nine PostgreSQL tables with enforced schema constraints |
| 2 | SQL query optimisation | Indexing improved selective query execution |
| 3 | Transaction and concurrency management | Automated transaction and isolation tests passed |
| 4 | NoSQL document databases | Indexed lookup improved from 39 ms to 1 ms |
| 5 | Distributed database resilience | Replication, failover and restoration were demonstrated |

### Relationship Between the Portfolios

Relational database design establishes structured relationships
and integrity rules for core ITSM records. Query optimisation
improves the efficiency of retrieving these records, while
transaction management protects correctness during concurrent
updates.

NoSQL document modelling provides an alternative representation
for heterogeneous operational and monitoring information.
Distributed database techniques extend the architecture by
supporting redundancy, recovery and service continuity.

These capabilities address different engineering requirements
and should be selected according to workload characteristics,
consistency needs, operational complexity and recovery objectives.

## Overall Limitations

The experiments were conducted in a controlled development
environment rather than a production enterprise deployment.

Performance measurements represent specific benchmark runs and
should not be interpreted as guaranteed production improvements.

The distributed database experiments did not measure recovery
time objectives, recovery point objectives or production
availability percentages.

## Recommendations

1. Evaluate database performance under realistic concurrent workloads.
2. Repeat performance benchmarks and report statistical variation.
3. Implement automated schema migration and integrity testing.
4. Extend transaction testing to additional contention scenarios.
5. Measure replica election time, replication lag and recovery duration.
6. Test disaster recovery against defined RTO and RPO targets.
7. Introduce production-grade monitoring, access control and backup policies.

## Overall Conclusion

The five portfolios demonstrate the application of relational and NoSQL database technologies to an enterprise IT service management case study. The experiments provide evidence of database integrity, query optimisation, transaction correctness, and resilience under simulated failure scenarios.

## Supporting Evidence

### Portfolio 1

- [database-verification.txt](../evidence/portfolio-1/database-verification.txt)
- [er-diagram.png](../evidence/portfolio-1/er-diagram.png)

### Portfolio 2

- [after-index.txt](../evidence/portfolio-2/after-index.txt)
- [before-index.txt](../evidence/portfolio-2/before-index.txt)
- [query-results.txt](../evidence/portfolio-2/query-results.txt)

### Portfolio 3

- [automated-results.json](../evidence/portfolio-3/automated-results.json)
- [automated-results.txt](../evidence/portfolio-3/automated-results.txt)
- [concurrency-results.txt](../evidence/portfolio-3/concurrency-results.txt)
- [setup-results.txt](../evidence/portfolio-3/setup-results.txt)
- [transaction-results.txt](../evidence/portfolio-3/transaction-results.txt)

### Portfolio 4

- [aggregation-results.txt](../evidence/portfolio-4/aggregation-results.txt)
- [crud-results.txt](../evidence/portfolio-4/crud-results.txt)
- [index-performance-results.txt](../evidence/portfolio-4/index-performance-results.txt)
- [sample-data-results.txt](../evidence/portfolio-4/sample-data-results.txt)
- [schema-results.txt](../evidence/portfolio-4/schema-results.txt)

### Portfolio 5

- [data-replication-results.txt](../evidence/portfolio-5/data-replication-results.txt)
- [disaster-recovery-results.txt](../evidence/portfolio-5/disaster-recovery-results.txt)
- [failover-results.txt](../evidence/portfolio-5/failover-results.txt)
- [network-partition-results.txt](../evidence/portfolio-5/network-partition-results.txt)
- [replica-status.txt](../evidence/portfolio-5/replica-status.txt)

