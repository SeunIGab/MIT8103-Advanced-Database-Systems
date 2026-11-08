-- Baseline query performance

EXPLAIN (ANALYZE, BUFFERS)
SELECT ticket_id, client_id, status, created_at
FROM benchmark_tickets
WHERE status = 'Open'
ORDER BY created_at DESC;
