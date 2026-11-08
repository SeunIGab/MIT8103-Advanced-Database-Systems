# MIT 8103 – Portfolio 5
## Distributed Databases, Replication and Resilience
### Sotai ITSM – MongoDB Replica Set

## 1. Introduction
This portfolio evaluates MongoDB replication, high availability,
automatic failover, disaster recovery and network partition
recovery using the Sotai ITSM database.

## 2. System Architecture
The environment uses MongoDB 7 and Docker Compose.

Replica set: sotaiRS

Nodes:
- sotai-mongo-primary
- sotai-mongo-secondary1
- sotai-mongo-secondary2

The replica set uses three voting members, supporting
automatic primary election and data replication.

## 3. Data Replication
Replication was verified across all three MongoDB nodes.

| Collection | Primary | Secondary 1 | Secondary 2 |
|---|---:|---:|---:|
| Tickets | 15 | 15 | 15 |
| Assets | 10 | 10 | 10 |
| Technicians | 5 | 5 | 5 |
| Security Events | 10 | 10 | 10 |

All document counts matched during verification.

## 4. Automatic Failover
The original primary was deliberately stopped.

MongoDB automatically elected sotai-mongo-secondary1
as the new PRIMARY.

The remaining secondary continued operating as SECONDARY.

All four Sotai ITSM collections remained readable.

This demonstrates successful automatic primary election
when a majority of voting nodes remains available.

## 5. Disaster Recovery
A MongoDB archive backup was created using mongodump.

Backup file:
sotai-itsm-dr.archive.gz

The backup passed gzip integrity verification.

The archive was restored into an isolated database:
sotai_itsm_restore_test

Restoration results:
- Tickets: 15
- Assets: 10
- Technicians: 5
- Security events: 10
- Benchmark tickets: 50000

Total restored documents: 50040

The restore completed without document failures.

## 6. Network Partition and Recovery
The sotai-mongo-secondary2 container was disconnected
from the Docker replica-set network.

The remaining nodes continued operating.

After reconnection, the replica set returned to:
- 1 PRIMARY
- 2 SECONDARY nodes

All application collection counts matched across
the three nodes.

This demonstrates recovery from a temporary
secondary-node network partition.

## 7. Performance and Resilience Evaluation
The experiments demonstrate:

1. Data redundancy across three MongoDB nodes.
2. Automatic primary election following node failure.
3. Continued service availability with a voting majority.
4. Successful database backup and restoration.
5. Recovery following temporary network isolation.
6. Consistent application document counts after recovery.

The tests validate resilience under the simulated
failure scenarios, but do not establish production
availability percentages, recovery time objectives,
or recovery point objectives.

## 8. Limitations
- Tests were conducted in a local Docker environment.
- No geographically distributed deployment was tested.
- Replication lag was not quantitatively measured.
- Election and recovery durations were not benchmarked.
- Matching document counts do not prove byte-level
  consistency across replicas.

## 9. Conclusion
Portfolio 5 successfully demonstrated MongoDB
replication, automatic failover, disaster recovery
and network partition recovery for Sotai ITSM.

The results show how distributed database
architecture improves application resilience
and supports service continuity.
