-- Demonstrate optimistic concurrency control
-- using version numbers.

-- Reset the test ticket
UPDATE transaction_tickets
SET status = 'Open',
    version_number = 1
WHERE ticket_id = 105;

-- Technician A reads version 1 and updates it.
UPDATE transaction_tickets
SET status = 'In Progress',
    version_number = version_number + 1
WHERE ticket_id = 105
  AND version_number = 1
RETURNING ticket_id, status, version_number;

-- Technician B attempts an update based
-- on the same previously read version.
UPDATE transaction_tickets
SET status = 'Closed',
    version_number = version_number + 1
WHERE ticket_id = 105
  AND version_number = 1
RETURNING ticket_id, status, version_number;

-- Verify final state
SELECT ticket_id, status, version_number
FROM transaction_tickets
WHERE ticket_id = 105;
