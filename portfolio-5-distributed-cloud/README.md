# MIT 8103 – Portfolio 5
## Distributed Databases, Replication and Cloud Resilience

**Project:** Sotai ITSM  
**Database:** MongoDB 7  
**Environment:** Docker Compose  
**Replica Set:** sotaiRS

## 1. Project Overview

This portfolio demonstrates distributed database
architecture, replication, high availability,
automatic failover, disaster recovery and
network partition recovery.

The experiments use Sotai ITSM, an IT service
management system designed to manage tickets,
assets, technicians and security events.

## 2. Technology Stack

- MongoDB 7
- MongoDB Replica Sets
- Docker and Docker Compose
- MongoDB Shell (mongosh)
- mongodump and mongorestore
- GitHub Codespaces

## 3. Replica Set Architecture

The MongoDB replica set contains three nodes:

| Node | Role |
|---|---|
| sotai-mongo-primary | Initially PRIMARY |
| sotai-mongo-secondary1 | Initially SECONDARY |
| sotai-mongo-secondary2 | Initially SECONDARY |

Replica set name: `sotaiRS`

The three voting members support automatic
primary elections when a majority is available.

## 4. Experiments Completed

### Experiment 1: Data Replication

Verified Sotai ITSM data across three nodes.

Results:
- Tickets: 15
- Assets: 10
- Technicians: 5
- Security events: 10

All three nodes returned matching counts.

### Experiment 2: Automatic Failover

Stopped the original primary MongoDB container.

MongoDB elected secondary1 as the new PRIMARY.

The remaining nodes continued providing
database access.

The original primary was subsequently restarted
and rejoined the replica set as SECONDARY.

### Experiment 3: Disaster Recovery

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

### Experiment 4: Network Partition Recovery

Disconnected secondary2 from the Docker
replica-set network.

Verified the replica-set response to the
temporary network isolation.

Reconnected secondary2 and confirmed that
all three nodes returned to healthy roles.

Verified matching application document counts.

## 5. Evidence Files

All experimental results are stored in:

`evidence/portfolio-5/`

| Evidence | Description |
|---|---|
| replica-status.txt | Replica set configuration |
| data-replication-results.txt | Replication verification |
| failover-results.txt | Automatic failover |
| disaster-recovery-results.txt | Backup restoration verification |
| network-partition-results.txt | Network recovery verification |

## 6. Performance and Resilience Analysis

The full technical analysis is available in:

`performance-analysis.md`

The analysis discusses replication,
fault tolerance, failover, disaster recovery,
network partitions, and experiment limitations.

## 7. Key Findings

1. MongoDB replicated application data across
   three nodes.
2. Automatic primary election succeeded.
3. Data remained accessible during the
   simulated primary failure.
4. Backup restoration recovered 50,040 documents.
5. The isolated secondary successfully rejoined.
6. Document counts matched following recovery.

## 8. Conclusion

Portfolio 5 demonstrates important distributed
database capabilities using MongoDB and Sotai ITSM.

The experiments illustrate how replication,
automatic failover, database backups and
network recovery contribute to system resilience.

The implementation provides a practical foundation
for understanding highly available database systems.
