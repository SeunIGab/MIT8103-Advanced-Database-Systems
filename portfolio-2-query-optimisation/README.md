
# MIT 8103 – Portfolio 2
## Query Optimisation and Performance Analysis

**Project:** Sotai ITSM – Enterprise IT Service Management and Asset Monitoring System

## 1. Project Overview

This portfolio evaluates the effect of PostgreSQL B-tree indexing on query performance in the Sotai ITSM database.

## 2. Technology Stack

- PostgreSQL 16
- SQL and EXPLAIN ANALYZE
- B-tree indexes
- Docker
- GitHub Codespaces

## 3. Experimental Database

The `benchmark_tickets` table contains 100,000 records. The tested query filters tickets by status and orders results by creation date in descending order. Both measured plans returned 100 matching records.

## 4. Experimental Methodology

1. Prepare the benchmark dataset.
2. Execute the query before indexing.
3. Capture the execution plan.
4. Create a composite B-tree index.
5. Update table statistics using ANALYZE.
6. Execute the query after indexing.
7. Compare execution times and query plans.

## 5. Index Definition

```sql
CREATE INDEX IF NOT EXISTS idx_benchmark_status_created
ON benchmark_tickets(status, created_at DESC)
INCLUDE (client_id);

ANALYZE benchmark_tickets;
```

## 6. Performance Results

| Metric | Before Index | After Index |
|---|---|---|
| Execution time | 5.723 ms | 0.549 ms |
| Planning time | 0.236 ms | 0.322 ms |
| Query access method | Sequential Scan | Bitmap Index Scan and Bitmap Heap Scan |
| Matching records | 100 | 100 |

The indexed query executed approximately 10.42 times faster, representing a 90.41% reduction in execution time.

## 7. Analysis

Before indexing, PostgreSQL performed a sequential scan and filtered out 99,900 nonmatching rows. After indexing, PostgreSQL used a bitmap index scan followed by a bitmap heap scan.

The results demonstrate the potential benefit of indexing selective queries. However, the comparison is based on one before-and-after measurement. Repeated benchmark runs are needed to evaluate consistency and the influence of caching and runtime variability.

Indexes also introduce storage and maintenance overhead.

## 8. Evidence

- evidence/portfolio-2/query-results.txt
- evidence/portfolio-2/before-index.txt
- evidence/portfolio-2/after-index.txt

## 9. Conclusion

The experiment demonstrated that appropriate B-tree indexing can substantially improve selective query performance in PostgreSQL. The observed execution time decreased from 5.723 ms to 0.549 ms, while the execution plan changed from a sequential scan to indexed access.
  