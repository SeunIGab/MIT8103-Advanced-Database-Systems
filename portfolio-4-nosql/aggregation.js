// MIT 8103 - Portfolio 4
// MongoDB Aggregation Pipeline Experiments

db = db.getSiblingDB("sotai_itsm");

print("===== 1. TICKETS BY PRIORITY =====");

db.itsm_tickets.aggregate([
  {
    $group: {
      _id: "$priority",
      total_tickets: {$sum: 1}
    }
  },
  {$sort: {total_tickets: -1, _id: 1}}
]).forEach(printjson);

print("\n===== 2. TICKETS BY STATUS =====");

db.itsm_tickets.aggregate([
  {
    $group: {
      _id: "$status",
      total_tickets: {$sum: 1}
    }
  },
  {$sort: {total_tickets: -1, _id: 1}}
]).forEach(printjson);

print("\n===== 3. HIGH PRIORITY TICKETS =====");

db.itsm_tickets.aggregate([
  {
    $match: {
      priority: {$in: ["High", "Critical"]}
    }
  },
  {
    $project: {
      _id: 0,
      ticket_id: 1,
      title: 1,
      priority: 1,
      status: 1
    }
  },
  {$sort: {ticket_id: 1}}
]).forEach(printjson);

print("\n===== 4. TECHNICIAN WORKLOAD =====");

db.itsm_tickets.aggregate([
  {
    $group: {
      _id: "$assigned_technician_id",
      assigned_tickets: {$sum: 1}
    }
  },
  {
    $lookup: {
      from: "itsm_technicians",
      localField: "_id",
      foreignField: "technician_id",
      as: "technician"
    }
  },
  {$unwind: "$technician"},
  {
    $project: {
      _id: 0,
      technician: "$technician.name",
      assigned_tickets: 1
    }
  },
  {$sort: {assigned_tickets: -1, technician: 1}}
]).forEach(printjson);

print("\n===== 5. SECURITY EVENTS BY SEVERITY =====");

db.itsm_security_events.aggregate([
  {
    $group: {
      _id: "$severity",
      total_events: {$sum: 1},
      unresolved_events: {
        $sum: {$cond: [{$eq: ["$resolved", false]}, 1, 0]}
      }
    }
  },
  {$sort: {total_events: -1, _id: 1}}
]).forEach(printjson);

print("\n===== 6. TICKETS WITH ASSET INFORMATION =====");

db.itsm_tickets.aggregate([
  {
    $lookup: {
      from: "itsm_assets",
      localField: "asset_id",
      foreignField: "asset_id",
      as: "asset"
    }
  },
  {$unwind: "$asset"},
  {
    $project: {
      _id: 0,
      ticket_id: 1,
      title: 1,
      hostname: "$asset.hostname",
      asset_type: "$asset.asset_type",
      health: "$asset.monitoring.health"
    }
  },
  {$sort: {ticket_id: 1}},
  {$limit: 10}
]).forEach(printjson);

print("\nAGGREGATION EXPERIMENTS COMPLETED");
