# MIT 8103 - Portfolio 3
## Transactions and Concurrency Control

### Organisation
Sotai Digital Solutions

### System
Enterprise IT Service Management and Asset Monitoring System

### Objective
To demonstrate transaction processing, ACID
properties, concurrency control, transaction
isolation, and deadlock handling in PostgreSQL.

### Database Environment
- PostgreSQL 16
- GitHub Codespaces
- Docker Compose
- Database: sotai_itsm

### ACID Properties

**Atomicity:** A transaction succeeds completely
or is rolled back.

**Consistency:** Database constraints remain
enforced during transaction processing.

**Isolation:** Concurrent transactions are
controlled using PostgreSQL isolation levels
and locking mechanisms.

**Durability:** Committed changes persist in
PostgreSQL storage across sessions and normal
database restarts.

### Experiments

1. COMMIT transaction
2. ROLLBACK transaction
3. SAVEPOINT transaction
4. Constraint violation and atomicity
5. Optimistic concurrency control
6. READ COMMITTED isolation
7. REPEATABLE READ isolation
8. Deadlock detection and recovery

### Evidence

- evidence/portfolio-3/setup-results.txt
- evidence/portfolio-3/transaction-results.txt
- evidence/portfolio-3/concurrency-results.txt
- Screenshots of isolation-level experiments
- Screenshots of deadlock detection

### Conclusion

The experiments are designed to demonstrate
how PostgreSQL manages transactions, maintains
data consistency, and controls conflicting
database operations.

Final observations should be documented
using the actual execution results.
