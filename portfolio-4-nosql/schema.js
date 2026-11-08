// MIT 8103 - Portfolio 4
// Sotai Digital Solutions - NoSQL Database Design

db = db.getSiblingDB("sotai_itsm");

// Create collections
[
  "itsm_tickets",
  "itsm_assets",
  "itsm_technicians",
  "itsm_security_events"
].forEach(name => {
  if (!db.getCollectionNames().includes(name)) {
    db.createCollection(name);
    print("Created collection: " + name);
  }
});

// Unique identifiers
db.itsm_tickets.createIndex(
  { ticket_id: 1 },
  { unique: true }
);

db.itsm_assets.createIndex(
  { asset_id: 1 },
  { unique: true }
);

db.itsm_technicians.createIndex(
  { technician_id: 1 },
  { unique: true }
);

db.itsm_security_events.createIndex(
  { event_id: 1 },
  { unique: true }
);

print("\nPortfolio 4 MongoDB schema created.");
printjson(db.getCollectionNames());
