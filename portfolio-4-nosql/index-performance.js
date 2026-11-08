// MIT 8103 - Portfolio 4
// MongoDB Indexing and Performance Experiment

db = db.getSiblingDB("sotai_itsm");

const collection = db.itsm_benchmark_tickets;

print("===== PREPARING BENCHMARK DATA =====");

// Dedicated synthetic collection.
// Does not modify production-style ITSM collections.
collection.drop();

const total = 50000;
const batchSize = 1000;

for (let start = 0; start < total; start += batchSize) {
  const documents = [];

  for (let i = start; i < Math.min(start + batchSize, total); i++) {
    documents.push({
      ticket_id: i + 1,
      client_id: (i % 100) + 1,
      priority: ["Low", "Medium", "High", "Critical"][i % 4],
      status: ["Open", "In Progress", "Resolved", "Closed"][i % 4],
      title: "Synthetic benchmark ticket " + (i + 1),
      created_at: new Date(Date.UTC(2026, 0, 1 + (i % 300)))
    });
  }

  collection.insertMany(documents);
}

print("Benchmark documents: " + collection.countDocuments({}));

// Highly selective query, matching one ticket.
const query = {ticket_id: 42000};

function report(label, result) {
  const stats = result.executionStats;

  print("\n===== " + label + " =====");
  print("Execution time (ms): " + stats.executionTimeMillis);
  print("Documents examined: " + stats.totalDocsExamined);
  print("Index keys examined: " + stats.totalKeysExamined);
  print("Documents returned: " + stats.nReturned);
  print("Winning plan:");
  printjson(result.queryPlanner.winningPlan);
}

// Before index
const before = collection.find(query).explain("executionStats");

report("BEFORE INDEXING", before);

// Create index
print("\n===== CREATING INDEX =====");

printjson(
  collection.createIndex({ticket_id: 1})
);

// After index
const after = collection.find(query).explain("executionStats");

report("AFTER INDEXING", after);

print("\n===== PERFORMANCE COMPARISON =====");

print("Before documents examined: " +
  before.executionStats.totalDocsExamined);

print("After documents examined: " +
  after.executionStats.totalDocsExamined);

print("Before execution time (ms): " +
  before.executionStats.executionTimeMillis);

print("After execution time (ms): " +
  after.executionStats.executionTimeMillis);

const beforeDocs = before.executionStats.totalDocsExamined;
const afterDocs = after.executionStats.totalDocsExamined;

if (afterDocs > 0) {
  print("Document examination reduction factor: " +
    (beforeDocs / afterDocs).toFixed(2) + "x");
}

if (
  beforeDocs === total &&
  afterDocs === 1 &&
  after.executionStats.nReturned === 1
) {
  print("INDEX OPTIMISATION VERIFIED");
} else {
  print("Review query execution statistics");
}

print("\nINDEX PERFORMANCE EXPERIMENT COMPLETED");
