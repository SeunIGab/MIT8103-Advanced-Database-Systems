// MIT 8103 - Portfolio 4: Synthetic ITSM Data
db = db.getSiblingDB("sotai_itsm");

// Synthetic data only; safe to rerun.
// Upsert records rather than creating duplicates.

const technicians = Array.from({length: 5}, (_, i) => ({
  technician_id: i + 1,
  name: `Technician ${i + 1}`,
  team: i < 2 ? "Service Desk" : "Infrastructure",
  skills: i % 2 === 0
    ? ["Windows", "Microsoft 365", "Networking"]
    : ["Linux", "MongoDB", "Security"],
  active: true
}));

const assets = Array.from({length: 10}, (_, i) => ({
  asset_id: i + 1,
  hostname: `SOTAI-${String(i + 1).padStart(3, "0")}`,
  asset_type: ["Laptop", "Desktop", "Server", "Firewall"][i % 4],
  client_id: (i % 5) + 1,
  specifications: {
    operating_system: i % 2 === 0 ? "Windows 11" : "Ubuntu 24.04",
    memory_gb: [8, 16, 32][i % 3],
    storage_gb: 512
  },
  monitoring: {
    agent_installed: true,
    health: i % 4 === 0 ? "Warning" : "Healthy"
  },
  tags: ["managed", "production"]
}));

const priorities = ["Low", "Medium", "High", "Critical"];
const statuses = ["Open", "In Progress", "Resolved", "Closed"];

const tickets = Array.from({length: 15}, (_, i) => ({
  ticket_id: i + 1,
  title: [
    "VPN connectivity issue",
    "Email access failure",
    "Endpoint security alert",
    "Server performance issue",
    "Printer configuration request"
  ][i % 5],
  client_id: (i % 5) + 1,
  asset_id: (i % 10) + 1,
  assigned_technician_id: (i % 5) + 1,
  priority: priorities[i % 4],
  status: statuses[i % 4],
  created_at: new Date(Date.UTC(2026, 10, 1 + i)),
  comments: [
    { author: "Service Desk", message: "Ticket created" },
    { author: "Technician", message: "Initial investigation completed" }
  ],
  sla: {
    response_minutes: i % 4 === 3 ? 15 : 60,
    resolution_minutes: i % 4 === 3 ? 120 : 480
  }
}));

const securityEvents = Array.from({length: 10}, (_, i) => ({
  event_id: i + 1,
  asset_id: (i % 10) + 1,
  event_type: ["Malware", "Phishing", "Suspicious Login"][i % 3],
  severity: priorities[i % 4],
  detected_at: new Date(Date.UTC(2026, 10, 1 + i)),
  resolved: i % 2 === 0,
  indicators: {
    source: "Synthetic Security Monitor",
    confidence: 0.75 + (i % 5) * 0.05
  }
}));

function upsertMany(collection, key, records) {
  const operations = records.map(record => ({
    replaceOne: {
      filter: {[key]: record[key]},
      replacement: record,
      upsert: true
    }
  }));
  collection.bulkWrite(operations);
}

upsertMany(db.itsm_technicians, "technician_id", technicians);
upsertMany(db.itsm_assets, "asset_id", assets);
upsertMany(db.itsm_tickets, "ticket_id", tickets);
upsertMany(db.itsm_security_events, "event_id", securityEvents);

print("Sotai ITSM sample data loaded.");
for (const name of [
  "itsm_technicians",
  "itsm_assets",
  "itsm_tickets",
  "itsm_security_events"
]) {
  print(`${name}: ${db.getCollection(name).countDocuments({})}`);
}
