-- Sotai Digital Solutions
-- Synthetic query optimisation benchmark

DROP TABLE IF EXISTS benchmark_tickets;

CREATE TABLE benchmark_tickets (
    ticket_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    client_id INT NOT NULL,
    priority VARCHAR(20) NOT NULL,
    status VARCHAR(30) NOT NULL,
    created_at TIMESTAMPTZ NOT NULL
);

INSERT INTO benchmark_tickets
(client_id, priority, status, created_at)
SELECT
    (n % 5) + 1,
    CASE
        WHEN n % 20 = 0 THEN 'Critical'
        WHEN n % 5 = 0 THEN 'High'
        WHEN n % 3 = 0 THEN 'Medium'
        ELSE 'Low'
    END,
    CASE
        WHEN n % 1000 = 0 THEN 'Open'
        WHEN n % 4 = 0 THEN 'In Progress'
        ELSE 'Resolved'
    END,
    TIMESTAMPTZ '2026-01-01 00:00:00+00'
        + n * INTERVAL '1 minute'
FROM generate_series(1, 100000) AS n;

ANALYZE benchmark_tickets;

SELECT COUNT(*) AS total_benchmark_tickets
FROM benchmark_tickets;
