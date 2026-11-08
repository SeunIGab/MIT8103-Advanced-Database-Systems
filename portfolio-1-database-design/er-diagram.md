# Sotai Digital Solutions
## Enterprise IT Service Management and Asset Monitoring System

### Entity Relationship Diagram

```mermaid
erDiagram
    CLIENTS ||--o{ ASSETS : owns
    CLIENTS ||--o{ TICKETS : submits
    CLIENTS ||--o{ SLA_AGREEMENTS : has
    TECHNICIANS |o--o{ TICKETS : assigned
    ASSETS |o--o{ TICKETS : associated
    TICKETS ||--o{ TICKET_HISTORY : records
    ASSETS ||--o{ SECURITY_AGENTS : runs
    ASSETS ||--o{ SECURITY_ALERTS : generates

    CLIENTS {
        int client_id PK
        varchar client_name
        varchar contact_email
        timestamp created_at
    }

    TECHNICIANS {
        int technician_id PK
        varchar full_name
        varchar email
        varchar department
    }

    ASSETS {
        int asset_id PK
        int client_id FK
        varchar hostname
        varchar asset_type
        varchar operating_system
        varchar status
    }

    SLA_AGREEMENTS {
        int sla_id PK
        int client_id FK
        varchar priority
        int response_minutes
        int resolution_minutes
    }

    TICKETS {
        int ticket_id PK
        int client_id FK
        int asset_id FK
        int technician_id FK
        varchar title
        varchar priority
        varchar status
        timestamp created_at
        timestamp resolved_at
    }

    TICKET_HISTORY {
        int history_id PK
        int ticket_id FK
        varchar old_status
        varchar new_status
        timestamp changed_at
    }

    SECURITY_AGENTS {
        int agent_id PK
        int asset_id FK
        varchar agent_name
        varchar health_status
        timestamp last_seen
    }

    SECURITY_ALERTS {
        int alert_id PK
        int asset_id FK
        varchar alert_type
        varchar severity
        timestamp detected_at
    }

    AUDIT_LOGS {
        int audit_id PK
        varchar action
        varchar entity_name
        int entity_id
        timestamp performed_at
    }
```

### Description

The database contains nine entities supporting IT service
management, asset monitoring, security tracking, and auditing.

Primary keys uniquely identify records, while foreign keys
maintain referential integrity between related entities.

The audit_logs table is standalone in the current schema.
