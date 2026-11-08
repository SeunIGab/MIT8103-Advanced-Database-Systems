# MIT 8103 – Portfolio 4
## NoSQL Database Implementation and Performance Analysis

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