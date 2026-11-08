# Database Keys and Constraints
## Sotai Digital Solutions

### Primary Keys

Each table has a primary key:

- clients: client_id
- technicians: technician_id
- assets: asset_id
- sla_agreements: sla_id
- tickets: ticket_id
- ticket_history: history_id
- security_agents: agent_id
- security_alerts: alert_id
- audit_logs: audit_id

### Foreign Keys

Foreign keys establish relationships between clients,
assets, tickets, technicians, and monitoring records.

They prevent references to nonexistent parent records.

### Unique Constraints

The schema enforces uniqueness on:

- Client contact email
- Technician email
- Asset hostname within each client
- SLA priority within each client
- Security agent name within each asset

### NOT NULL Constraints

Required fields include client names, technician names,
ticket titles, priorities, and asset hostnames.

### CHECK Constraints

Ticket priority is restricted to:

Low, Medium, High, Critical

Ticket status is restricted to:

Open, In Progress, Resolved, Closed

SLA response and resolution times must be positive.

### Composite Foreign Key

The tickets table uses a composite foreign key
(asset_id, client_id) referencing assets.

This ensures that a ticket cannot be associated
with an asset owned by another client.

### Audit Logging

The audit_logs table stores action descriptions,
entity names, entity identifiers, and timestamps.

The current schema does not automatically generate
audit records. Automatic auditing would require
additional triggers or application logic.
