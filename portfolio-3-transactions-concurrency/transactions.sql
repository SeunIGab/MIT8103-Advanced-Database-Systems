-- Test 1: COMMIT
-- A technician begins working on ticket 101.

BEGIN;

UPDATE transaction_tickets
SET status = 'In Progress',
    version_number = version_number + 1,
    updated_at = CURRENT_TIMESTAMP
WHERE ticket_id = 101;

INSERT INTO transaction_audit
(ticket_id, action)
VALUES (101, 'Ticket assigned for investigation');

COMMIT;

SELECT ticket_id, status, version_number
FROM transaction_tickets
WHERE ticket_id = 101;


-- Test 2: ROLLBACK
-- An incorrect ticket closure is reversed.

BEGIN;

UPDATE transaction_tickets
SET status = 'Closed'
WHERE ticket_id = 102;

SELECT ticket_id, status
FROM transaction_tickets
WHERE ticket_id = 102;

ROLLBACK;

SELECT ticket_id, status
FROM transaction_tickets
WHERE ticket_id = 102;


-- Test 3: SAVEPOINT
-- Undo one operation without cancelling
-- the entire transaction.

BEGIN;

UPDATE transaction_tickets
SET status = 'In Progress'
WHERE ticket_id = 103;

SAVEPOINT before_closure;

UPDATE transaction_tickets
SET status = 'Closed'
WHERE ticket_id = 103;

ROLLBACK TO SAVEPOINT before_closure;

COMMIT;

SELECT ticket_id, status
FROM transaction_tickets
WHERE ticket_id = 103;


-- Test 4: Atomicity and Consistency
-- A constraint violation rolls back
-- both the ticket update and audit insert.

BEGIN;

UPDATE transaction_tickets
SET status = 'Resolved'
WHERE ticket_id = 104;

INSERT INTO transaction_audit
(ticket_id, action)
VALUES (9999, 'Invalid audit reference');

ROLLBACK;

SELECT ticket_id, status
FROM transaction_tickets
WHERE ticket_id = 104;
