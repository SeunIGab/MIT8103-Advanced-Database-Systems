# MIT 8103 – Portfolio 1
## Relational Database Design and Normalisation

**Project:** Sotai ITSM – Enterprise IT Service Management and Asset Monitoring System

**Organisation:** Sotai Digital Solutions

## 1. Project Overview

This portfolio presents the design of a relational database for Sotai ITSM, an enterprise IT service management and asset monitoring system.

The database supports client management, IT assets, service tickets, technician assignments, service-level agreements, security monitoring and audit records.

The implementation uses PostgreSQL and relational database design principles to improve data integrity, consistency and maintainability.

## 2. Database Architecture

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

## 3. Entity Relationship Design

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

## 4. Database Normalisation

The database was designed using the principles of First Normal Form (1NF), Second Normal Form (2NF) and Third Normal Form (3NF).

### 4.1 First Normal Form

Attributes are stored as atomic values, and repeating groups are avoided.

For example, each client asset is represented by a separate record in the assets table.

### 4.2 Second Normal Form

The design satisfies the documented 2NF requirements by ensuring that non-key attributes depend on their complete candidate keys.

Ticket attributes such as title, priority and status describe the associated ticket.

### 4.3 Third Normal Form

Client, technician and asset details are separated into dedicated tables to reduce redundant storage.

For example, tickets reference clients through client_id instead of duplicating client names and contact information.

This design reduces update anomalies and supports consistent data management.

Further details are available in `normalization.md`.

## 5. Integrity Constraints

The database applies several integrity constraints.

### Primary Keys

Each table uses a primary key to uniquely identify its records.

### Foreign Keys

Foreign keys maintain relationships between clients, assets, technicians, tickets, ticket history and security monitoring records.

### Unique Constraints

Uniqueness is enforced for:

- Client contact email
- Technician email
- Asset hostname within each client
- SLA priority within each client
- Security agent name within each asset

### NOT NULL Constraints

Required attributes include client names, technician names, ticket titles, ticket priorities and asset hostnames.

### CHECK Constraints

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

### Composite Foreign Key

The tickets table uses a composite foreign key:

`(asset_id, client_id)`

This references the corresponding columns in the assets table.

The constraint prevents a ticket from referencing an asset belonging to a different client.

Detailed explanations are provided in `constraints.md`.

## 6. Database Implementation

The relational schema is defined in:

`schema.sql`

Sample records are provided in:

`sample-data.sql`

The implementation uses PostgreSQL SQL statements to define tables, keys, relationships and integrity constraints.

## 7. Security and Auditing

The database supports security monitoring through the security_agents and security_alerts tables.

The audit_logs table stores audit event information, including action descriptions, entity identifiers and timestamps.

In the current implementation, automatic audit record generation is not configured.

Database triggers or application-level auditing could be introduced in a future implementation.

## 8. Design Benefits

The relational design provides:

- Reduced data redundancy
- Improved referential integrity
- Consistent ticket and asset relationships
- Structured technician assignments
- Service-level agreement management
- Security monitoring support
- Extensibility for future ITSM capabilities

## 9. Portfolio Files

| File | Description |
|---|---|
| README.md | Portfolio overview and documentation |
| schema.sql | PostgreSQL relational schema |
| sample-data.sql | Sample database records |
| er-diagram.md | Entity relationship diagram |
| normalization.md | Normalisation analysis |
| constraints.md | Database integrity constraints |

## 10. Conclusion

Portfolio 1 demonstrates the design of a relational database for an enterprise IT service management environment.

The Sotai ITSM schema integrates client management, asset tracking, ticket processing, service-level agreements and security monitoring within a structured relational model.

Normalisation, primary keys, foreign keys and integrity constraints provide a foundation for consistent and maintainable IT service data.

The design establishes the relational database foundation for subsequent MIT 8103 portfolio experiments.
