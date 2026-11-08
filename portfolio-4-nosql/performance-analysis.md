# MIT 8103 – Portfolio 4
## NoSQL Database Implementation and Performance Analysis

### Organisation
Sotai Digital Solutions

### System
Enterprise IT Service Management and Asset Monitoring System

## 1. Introduction
This portfolio demonstrates the implementation of a
NoSQL database using MongoDB for managing IT service
tickets, assets, technicians and security events.

## 2. Database Environment
- DBMS: MongoDB 7.0.45
- Database: sotai_itsm
- Development environment: GitHub Codespaces
- Deployment: Docker container (sotai-mongodb)
- Shell: mongosh

## 3. Database Design
Four MongoDB collections were implemented:

1. itsm_tickets
2. itsm_assets
3. itsm_technicians
4. itsm_security_events

The design supports flexible documents, nested objects,
arrays and references between related records.

## 4. Sample Data
The following sample records were loaded:

| Collection | Documents |
|---|---:|
| itsm_tickets | 15 |
| itsm_assets | 10 |
| itsm_technicians | 5 |
| itsm_security_events | 10 |

## 5. CRUD Operations
MongoDB CRUD operations were demonstrated:

- Create: Insert service ticket records.
- Read: Retrieve documents using query filters.
- Update: Modify ticket status and comments.
- Delete: Remove a temporary test ticket.

The final verification confirmed that 15 original
ITSM tickets remained in the database.

## 6. Aggregation
MongoDB aggregation pipelines were used to analyse
ITSM records and join tickets with asset information.

The $lookup stage connected ticket records to their
associated assets, including hostnames, asset types
and monitoring health status.

## 7. Indexing and Query Optimisation

### 7.1 Methodology
A dedicated benchmark collection containing 50,000
synthetic ticket documents was created.

The same ticket lookup query was executed before
and after creating an ascending index on ticket_id.

MongoDB explain("executionStats") was used to measure
query execution performance.

### 7.2 Results

| Metric | Before | After |
|---|---:|---:|
| Documents examined | 50,000 | 1 |
| Index keys examined | 0 | 1 |
| Execution time | 39 ms | 1 ms |

### 7.3 Performance Analysis
Creating the index reduced the number of documents
examined from 50,000 to 1.

The measured execution time decreased from 39 ms
to 1 ms, representing a 97.44% reduction.

The measured execution time speedup was 39 times.

Document examination was reduced by a factor
of 50,000.

### 7.4 Interpretation
Before indexing, MongoDB performed a collection scan
to locate the matching ticket.

After indexing, MongoDB used the ticket_id index
to locate the document more efficiently.

These results demonstrate the importance of indexing
for selective queries in large NoSQL collections.

The execution times represent one benchmark run and
may vary with caching, hardware and workload.

## 8. Evidence
Supporting experimental outputs are stored in:

- evidence/portfolio-4/schema-results.txt
- evidence/portfolio-4/sample-data-results.txt
- evidence/portfolio-4/crud-results.txt
- evidence/portfolio-4/aggregation-results.txt
- evidence/portfolio-4/index-performance-results.txt

## 9. Conclusion
The portfolio demonstrated MongoDB document modelling,
CRUD operations, aggregation and query optimisation
within the Sotai ITSM system.

The indexing experiment showed a substantial reduction
in document examination and query execution time.

MongoDB provides a flexible document-oriented approach
for storing heterogeneous ITSM and asset monitoring data.
