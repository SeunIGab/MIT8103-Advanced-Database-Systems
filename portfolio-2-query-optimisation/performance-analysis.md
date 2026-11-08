# MIT 8103 – Portfolio 2
## Query Processing and Optimisation

### Organisation
Sotai Digital Solutions

### System
Enterprise IT Service Management and Asset Monitoring System

### 1. Introduction

This experiment investigates SQL query processing and
optimisation in PostgreSQL.

The objective is to evaluate how database indexing
affects query execution performance when retrieving
IT service management records.

### 2. Database Environment

Database Management System: PostgreSQL 16

Development Environment: GitHub Codespaces

Database Name: sotai_itsm

Benchmark Table: benchmark_tickets

Benchmark Dataset: 100,000 synthetic records

### 3. SQL Query

The following query was tested before and after
creating a database index:

```sql
SELECT ticket_id, client_id, status, created_at
FROM benchmark_tickets
WHERE status = 'Open'
ORDER BY created_at DESC;
```

### 4. Indexing Strategy

A B-tree index was created using:

```sql
CREATE INDEX idx_benchmark_status_created
ON benchmark_tickets(status, created_at DESC)
INCLUDE (client_id);
```

The index was designed to support filtering by
ticket status and sorting by creation date.

### 5. Performance Comparison

The PostgreSQL EXPLAIN ANALYZE command was used
to evaluate query performance before and after
creating the B-tree index.

| Metric | Before Index | After Index |
|---|---|---|
| Execution Time | 5.723 ms | 0.549 ms |
| Planning Time | 0.236 ms | 0.322 ms |
| Scan Type | Sequential Scan | Bitmap Heap Scan + Bitmap Index Scan |
| Rows Returned | 100 | 100 |
| Top-Level Buffer Activity | 934 shared hits | 122 hits, 1 read |
| Index Used | No | Yes |

### 6. Analysis of Results

#### 6.1 Performance Before Indexing

Before indexing, PostgreSQL performed a sequential
scan on the benchmark_tickets table.

The query execution time was 5.723 milliseconds.

The sequential scan examined the table to locate
tickets with the status 'Open'.

The top-level plan reported 934 shared buffer hits.

#### 6.2 Performance After Indexing

After creating the B-tree index
idx_benchmark_status_created, PostgreSQL used
a Bitmap Index Scan followed by a Bitmap Heap Scan.

The execution time decreased to 0.549 milliseconds.

The index enabled PostgreSQL to locate matching
ticket records without performing a full sequential
table scan.

The top-level plan reported 122 shared buffer hits
and one shared buffer read.

#### 6.3 Performance Improvement

The percentage reduction in execution time was:

((5.723 - 0.549) / 5.723) * 100 = 90.41%

The speed ratio was:

5.723 / 0.549 = 10.42

Therefore, the indexed query executed approximately
10.42 times faster in this measurement.

Planning time increased slightly from 0.236 ms
to 0.322 ms.

These findings are based on one before-and-after
measurement. Repeated benchmark runs would be
needed to assess consistency and reduce the
influence of caching and runtime variability.

### 7. Conclusion

The experiment demonstrated the effect of B-tree
indexing on query processing in PostgreSQL.

Before indexing, PostgreSQL used a sequential scan.
After indexing, it selected a bitmap index scan
and bitmap heap scan.

The measured execution time decreased from
5.723 ms to 0.549 ms, representing a 90.41%
reduction in execution time.

The experiment illustrates how appropriate indexing
can improve selective query performance in an
Enterprise IT Service Management database.

However, indexes introduce storage and maintenance
overhead, and their effectiveness depends on query
patterns, data distribution, and workload.

### 8. Evidence

- evidence/portfolio-2/query-results.txt
- evidence/portfolio-2/before-index.txt
- evidence/portfolio-2/after-index.txt
