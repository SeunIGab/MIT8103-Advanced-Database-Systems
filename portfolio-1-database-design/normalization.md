# Database Normalisation
## Sotai Digital Solutions

### 1. Introduction

The Enterprise IT Service Management and Asset Monitoring
System uses a relational database designed to minimise
redundancy, improve data integrity, and maintain
consistency across IT service operations.

The database consists of nine tables:
clients, technicians, assets, sla_agreements, tickets,
ticket_history, security_agents, security_alerts,
and audit_logs.

### 2. First Normal Form (1NF)

Each table contains atomic attributes, and each record
is uniquely identified by a primary key.

For example, the clients table stores client_name and
contact_email in separate columns.

Multiple assets belonging to one client are stored
as separate rows in the assets table rather than
repeating groups within a single client record.

### 3. Second Normal Form (2NF)

The database satisfies 2NF because its tables satisfy
1NF and their non-key attributes depend on the whole
candidate key.

For example, in the tickets table, title, priority,
status, and created_at describe the ticket identified
by ticket_id.

Client details are stored separately in clients and
referenced through client_id.

### 4. Third Normal Form (3NF)

The schema is designed to satisfy 3NF by separating
information about distinct business entities.

For example, the tickets table stores client_id
rather than duplicating client_name and contact_email.

Similarly, technician details are stored in the
technicians table, and assets are stored in the
assets table.

This reduces update anomalies and unnecessary
duplication.

### 5. Referential Integrity

Foreign keys maintain relationships between tables.

Examples:

- assets.client_id references clients.client_id
- tickets.client_id references clients.client_id
- tickets.technician_id references technicians.technician_id
- ticket_history.ticket_id references tickets.ticket_id
- security_agents.asset_id references assets.asset_id
- security_alerts.asset_id references assets.asset_id

The composite foreign key from tickets(asset_id, client_id)
to assets(asset_id, client_id) prevents a ticket from
referencing an asset belonging to a different client.

### 6. Conclusion

Normalisation and referential integrity help the
Sotai Digital Solutions database maintain accurate,
consistent, and manageable enterprise IT service data.
