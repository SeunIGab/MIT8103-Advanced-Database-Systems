-- MIT 8103 - Portfolio 2
-- Sotai Digital Solutions
-- Advanced SQL Query Processing

-- Query 1: Tickets with client and technician details
SELECT
    t.ticket_id,
    c.client_name,
    t.title,
    t.priority,
    t.status,
    COALESCE(tech.full_name, 'Unassigned') AS technician
FROM tickets t
JOIN clients c ON t.client_id = c.client_id
LEFT JOIN technicians tech
    ON t.technician_id = tech.technician_id
ORDER BY t.created_at DESC, t.ticket_id DESC;

-- Query 2: Ticket volume by client
SELECT
    c.client_name,
    COUNT(t.ticket_id) AS total_tickets,
    COUNT(t.ticket_id) FILTER (
        WHERE t.status IN ('Open', 'In Progress')
    ) AS active_tickets
FROM clients c
LEFT JOIN tickets t ON c.client_id = t.client_id
GROUP BY c.client_id, c.client_name
ORDER BY total_tickets DESC, c.client_name;

-- Query 3: Technician workload
SELECT
    tech.full_name,
    COUNT(t.ticket_id) AS assigned_tickets,
    COUNT(t.ticket_id) FILTER (
        WHERE t.status IN ('Open', 'In Progress')
    ) AS unresolved_tickets
FROM technicians tech
LEFT JOIN tickets t
    ON tech.technician_id = t.technician_id
GROUP BY tech.technician_id, tech.full_name
ORDER BY unresolved_tickets DESC, tech.full_name;

-- Query 4: Security agent compliance
SELECT
    c.client_name,
    a.hostname,
    sa.agent_name,
    sa.health_status,
    sa.last_seen
FROM security_agents sa
JOIN assets a ON sa.asset_id = a.asset_id
JOIN clients c ON a.client_id = c.client_id
WHERE sa.health_status <> 'Healthy'
ORDER BY c.client_name, a.hostname;

-- Query 5: High-priority unresolved incidents
SELECT
    t.ticket_id,
    c.client_name,
    t.title,
    t.priority,
    t.status
FROM tickets t
JOIN clients c ON t.client_id = c.client_id
WHERE t.priority IN ('High', 'Critical')
  AND t.status IN ('Open', 'In Progress')
ORDER BY t.created_at DESC, t.ticket_id DESC;

-- Query 6: Clients with at least two tickets
SELECT
    c.client_name,
    COUNT(t.ticket_id) AS total_tickets
FROM clients c
JOIN tickets t ON c.client_id = t.client_id
GROUP BY c.client_id, c.client_name
HAVING COUNT(t.ticket_id) >= 2
ORDER BY total_tickets DESC, c.client_name;

-- Query 7: Assets with recorded security alerts
SELECT
    a.hostname,
    c.client_name,
    COUNT(s.alert_id) AS alert_count
FROM assets a
JOIN clients c ON a.client_id = c.client_id
JOIN security_alerts s ON a.asset_id = s.asset_id
GROUP BY a.asset_id, a.hostname, c.client_name
ORDER BY alert_count DESC, a.hostname;

-- Query 8: Clients with above-average ticket volume
WITH client_ticket_counts AS (
    SELECT
        c.client_id,
        c.client_name,
        COUNT(t.ticket_id) AS ticket_count
    FROM clients c
    LEFT JOIN tickets t ON c.client_id = t.client_id
    GROUP BY c.client_id, c.client_name
)
SELECT client_name, ticket_count
FROM client_ticket_counts
WHERE ticket_count > (
    SELECT AVG(ticket_count)
    FROM client_ticket_counts
)
ORDER BY ticket_count DESC;

-- Query 9: Latest ticket per client using window function
SELECT client_name, ticket_id, title, created_at
FROM (
    SELECT
        c.client_name,
        t.ticket_id,
        t.title,
        t.created_at,
        ROW_NUMBER() OVER (
            PARTITION BY c.client_id
            ORDER BY t.created_at DESC, t.ticket_id DESC
        ) AS rn
    FROM tickets t
    JOIN clients c ON t.client_id = c.client_id
) ranked
WHERE rn = 1
ORDER BY client_name;

-- Query 10: Unresolved tickets past their SLA
-- Uses created_at as a simplified resolution deadline.
SELECT
    t.ticket_id,
    c.client_name,
    t.priority,
    t.created_at,
    s.resolution_minutes,
    t.created_at
        + s.resolution_minutes * INTERVAL '1 minute'
        AS deadline
FROM tickets t
JOIN clients c ON t.client_id = c.client_id
JOIN sla_agreements s
    ON s.client_id = t.client_id
   AND s.priority = t.priority
WHERE t.status IN ('Open', 'In Progress')
  AND CURRENT_TIMESTAMP >
      t.created_at
      + s.resolution_minutes * INTERVAL '1 minute'
ORDER BY deadline;
