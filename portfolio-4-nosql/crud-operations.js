// MIT 8103 - Portfolio 4
// MongoDB CRUD Operations
// Sotai Digital Solutions

db = db.getSiblingDB("sotai_itsm");

print("===== CREATE OPERATION =====");

// Remove previous test record to allow reruns
db.itsm_tickets.deleteOne({ticket_id: 1001});

const createResult = db.itsm_tickets.insertOne({
  ticket_id: 1001,
  title: "VPN Connection Failure",
  client_id: 1,
  asset_id: 1,
  assigned_technician_id: 1,
  priority: "High",
  status: "Open",
  created_at: new Date(),
  comments: [
    {
      author: "Service Desk",
      message: "User reported VPN connectivity issue"
    }
  ],
  sla: {
    response_minutes: 30,
    resolution_minutes: 240
  }
});

print("Inserted ID: " + createResult.insertedId);

print("\n===== READ OPERATION =====");

printjson(
  db.itsm_tickets.findOne({ticket_id: 1001})
);

print("\n===== FILTERED READ =====");

db.itsm_tickets.find(
  {priority: "High"},
  {_id: 0, ticket_id: 1, title: 1, status: 1}
).forEach(printjson);

print("\n===== UPDATE OPERATION =====");

const updateResult = db.itsm_tickets.updateOne(
  {ticket_id: 1001},
  {
    $set: {
      status: "In Progress",
      assigned_technician_id: 2
    },
    $push: {
      comments: {
        author: "Technician 2",
        message: "Investigation started"
      }
    }
  }
);

print("Modified documents: " + updateResult.modifiedCount);

printjson(
  db.itsm_tickets.findOne({ticket_id: 1001})
);

print("\n===== DELETE OPERATION =====");

const deleteResult = db.itsm_tickets.deleteOne(
  {ticket_id: 1001}
);

print("Deleted documents: " + deleteResult.deletedCount);

print("\n===== FINAL VERIFICATION =====");

print("Remaining test tickets: " +
  db.itsm_tickets.countDocuments({ticket_id: 1001})
);

print("Total ITSM tickets: " +
  db.itsm_tickets.countDocuments({})
);

print("\nCRUD OPERATIONS COMPLETED");
