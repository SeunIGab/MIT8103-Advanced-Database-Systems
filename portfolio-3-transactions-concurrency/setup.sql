-- MIT 8103 - Portfolio 3
-- Sotai Digital Solutions
-- Transaction and Concurrency Testing

DROP TABLE IF EXISTS transaction_audit;
DROP TABLE IF EXISTS transaction_tickets;

CREATE TABLE transaction_tickets (
    ticket_id INT PRIMARY KEY,
    client_name VARCHAR(150) NOT NULL,
    assigned_technician VARCHAR(150),
    priority VARCHAR(20) NOT NULL,
    status VARCHAR(30) NOT NULL
        CHECK (status IN (
            'Open',
            'In Progress',
            'Resolved',
            'Closed'
        )),
    version_number INT NOT NULL DEFAULT 1
        CHECK (version_number > 0),
    updated_at TIMESTAMPTZ
        NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE transaction_audit (
    audit_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    ticket_id INT NOT NULL
        REFERENCES transaction_tickets(ticket_id),
    action VARCHAR(100) NOT NULL,
    created_at TIMESTAMPTZ
        NOT NULL DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO transaction_tickets
(ticket_id, client_name, assigned_technician,
 priority, status)
VALUES
(101, 'Apex Business Group',
 'Daniel Okoro', 'High', 'Open'),

(102, 'Nova Financial Services',
 'Grace Adeyemi', 'Critical', 'Open'),

(103, 'Prime Healthcare',
 'Michael Johnson', 'Medium', 'Open'),

(104, 'Summit Engineering',
 'Sarah Williams', 'High', 'Open'),

(105, 'Horizon Logistics',
 'Emeka Obi', 'Critical', 'Open');

SELECT * FROM transaction_tickets
ORDER BY ticket_id;
