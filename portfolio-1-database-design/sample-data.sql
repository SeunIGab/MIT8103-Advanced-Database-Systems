-- Sotai Digital Solutions
-- MIT 8103: Sample Database Records

INSERT INTO clients (client_name, contact_email)
VALUES
('Apex Business Group', 'it@apex.example'),
('Nova Financial Services', 'support@nova.example'),
('Prime Healthcare', 'helpdesk@prime.example'),
('Summit Engineering', 'it@summit.example'),
('Horizon Logistics', 'support@horizon.example');

INSERT INTO technicians (full_name, email, department)
VALUES
('Daniel Okoro', 'daniel@sotai.example', 'Service Desk'),
('Grace Adeyemi', 'grace@sotai.example', 'Infrastructure'),
('Michael Johnson', 'michael@sotai.example', 'Cybersecurity'),
('Sarah Williams', 'sarah@sotai.example', 'Service Desk'),
('Emeka Obi', 'emeka@sotai.example', 'Infrastructure');

INSERT INTO assets
(client_id, hostname, asset_type, operating_system)
VALUES
(1, 'APEX-LT-001', 'Laptop', 'Windows 11'),
(1, 'APEX-SRV-001', 'Server', 'Windows Server 2022'),
(2, 'NOVA-LT-001', 'Laptop', 'Windows 11'),
(2, 'NOVA-SRV-001', 'Server', 'Windows Server 2022'),
(3, 'PRIME-LT-001', 'Laptop', 'Windows 11'),
(3, 'PRIME-SRV-001', 'Server', 'Ubuntu 22.04'),
(4, 'SUMMIT-LT-001', 'Laptop', 'Windows 11'),
(4, 'SUMMIT-SRV-001', 'Server', 'Windows Server 2022'),
(5, 'HORIZON-LT-001', 'Laptop', 'Windows 11'),
(5, 'HORIZON-SRV-001', 'Server', 'Ubuntu 22.04');

INSERT INTO sla_agreements
(client_id, priority, response_minutes, resolution_minutes)
VALUES
(1, 'Critical', 15, 240),
(1, 'High', 30, 480),
(2, 'Critical', 15, 180),
(2, 'High', 30, 360),
(3, 'Critical', 15, 240),
(4, 'High', 60, 480),
(5, 'Medium', 120, 1440);

INSERT INTO tickets
(client_id, asset_id, technician_id, title, description, priority, status)
VALUES
(1, 1, 1, 'VPN connection failure', 'User unable to connect to VPN', 'High', 'Open'),
(1, 2, 2, 'Server performance issue', 'High CPU utilisation', 'Critical', 'In Progress'),
(2, 3, 3, 'Antivirus agent missing', 'Endpoint protection agent not reporting', 'High', 'Open'),
(2, 4, 5, 'Server backup failure', 'Scheduled backup unsuccessful', 'Critical', 'In Progress'),
(3, 5, 4, 'Outlook authentication issue', 'User unable to sign in', 'Medium', 'Resolved'),
(3, 6, 2, 'Linux server alert', 'Disk space threshold exceeded', 'High', 'Open'),
(4, 7, 1, 'Password reset request', 'User account locked', 'Low', 'Closed'),
(4, 8, 5, 'Network connectivity issue', 'Intermittent connection', 'High', 'Open'),
(5, 9, 3, 'Security alert investigation', 'Suspicious activity detected', 'Critical', 'In Progress'),
(5, 10, 2, 'Backup verification', 'Verify server backup status', 'Medium', 'Resolved');

INSERT INTO security_agents
(asset_id, agent_name, health_status, last_seen)
VALUES
(1, 'Huntress', 'Healthy', CURRENT_TIMESTAMP),
(2, 'Huntress', 'Healthy', CURRENT_TIMESTAMP),
(3, 'Huntress', 'Missing', NULL),
(4, 'Huntress', 'Healthy', CURRENT_TIMESTAMP),
(5, 'Huntress', 'Healthy', CURRENT_TIMESTAMP),
(6, 'Huntress', 'Unhealthy', CURRENT_TIMESTAMP),
(7, 'Huntress', 'Healthy', CURRENT_TIMESTAMP),
(8, 'Huntress', 'Healthy', CURRENT_TIMESTAMP),
(9, 'Huntress', 'Unhealthy', CURRENT_TIMESTAMP),
(10, 'Huntress', 'Healthy', CURRENT_TIMESTAMP);

INSERT INTO security_alerts
(asset_id, alert_type, severity)
VALUES
(3, 'Missing Antivirus Agent', 'High'),
(6, 'Disk Space Warning', 'Medium'),
(9, 'Suspicious Login Attempt', 'Critical');

INSERT INTO ticket_history
(ticket_id, old_status, new_status)
VALUES
(2, 'Open', 'In Progress'),
(4, 'Open', 'In Progress'),
(5, 'Open', 'Resolved'),
(7, 'Resolved', 'Closed'),
(9, 'Open', 'In Progress');

INSERT INTO audit_logs
(action, entity_name, entity_id)
VALUES
('Created client', 'clients', 1),
('Assigned technician', 'tickets', 2),
('Updated ticket status', 'tickets', 5);
