CREATE INDEX IF NOT EXISTS idx_benchmark_status_created
ON benchmark_tickets(status, created_at DESC)
INCLUDE (client_id);

ANALYZE benchmark_tickets;
