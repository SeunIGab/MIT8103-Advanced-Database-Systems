-- MIT 8103 Advanced Database Systems
-- Organisation: Sotai Digital Solutions
-- System: Enterprise IT Service Management

CREATE TABLE clients (
    client_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    client_name VARCHAR(150) NOT NULL,
    contact_email VARCHAR(150) UNIQUE NOT NULL,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE technicians (
    technician_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    full_name VARCHAR(150) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    department VARCHAR(100)
);

CREATE TABLE assets (
    asset_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    client_id INT NOT NULL REFERENCES clients(client_id),
    hostname VARCHAR(100) NOT NULL,
    asset_type VARCHAR(50) NOT NULL,
    operating_system VARCHAR(100),
    status VARCHAR(30) DEFAULT 'Active',
    UNIQUE(client_id, hostname),
    UNIQUE(asset_id, client_id)
);

CREATE TABLE sla_agreements (
    sla_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    client_id INT NOT NULL REFERENCES clients(client_id),
    priority VARCHAR(20) NOT NULL,
    response_minutes INT NOT NULL CHECK (response_minutes > 0),
    resolution_minutes INT NOT NULL CHECK (resolution_minutes > 0),
    UNIQUE(client_id, priority)
);

CREATE TABLE tickets (
    ticket_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    client_id INT NOT NULL REFERENCES clients(client_id),
    asset_id INT,
    technician_id INT REFERENCES technicians(technician_id),
    title VARCHAR(200) NOT NULL,
    description TEXT,
    priority VARCHAR(20) NOT NULL
        CHECK(priority IN ('Low','Medium','High','Critical')),
    status VARCHAR(30) NOT NULL DEFAULT 'Open'
        CHECK(status IN ('Open','In Progress','Resolved','Closed')),
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    resolved_at TIMESTAMPTZ,
    FOREIGN KEY(asset_id, client_id)
        REFERENCES assets(asset_id, client_id)
);

CREATE TABLE ticket_history (
    history_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    ticket_id INT NOT NULL REFERENCES tickets(ticket_id),
    old_status VARCHAR(30),
    new_status VARCHAR(30) NOT NULL,
    changed_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE security_agents (
    agent_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    asset_id INT NOT NULL REFERENCES assets(asset_id),
    agent_name VARCHAR(100) NOT NULL,
    health_status VARCHAR(30) NOT NULL,
    last_seen TIMESTAMPTZ,
    UNIQUE(asset_id, agent_name)
);

CREATE TABLE security_alerts (
    alert_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    asset_id INT NOT NULL REFERENCES assets(asset_id),
    alert_type VARCHAR(100) NOT NULL,
    severity VARCHAR(20) NOT NULL,
    detected_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE audit_logs (
    audit_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    action VARCHAR(150) NOT NULL,
    entity_name VARCHAR(100) NOT NULL,
    entity_id INT,
    performed_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);
