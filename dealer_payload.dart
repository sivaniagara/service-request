// (GET /api/v1/dealer/dashboard)
dynamic dashboard = {
  "status": "success",
  "data": {
    "dealerProfile": {
      "dealerId": "dlr-01-uuid",
      "dealerCode": "DLR-01",
      "name": "AgriTech Service Solutions",
      "region": "Coimbatore West",
      "officeAddress": "12 Cross Cut Road, Gandhipuram, Coimbatore",
      "phone": "+91 98765 40001",
      "rating": 4.9
    },
    "metrics": {
      "totalActiveTickets": 8,
      "pendingTechnicianAssignment": 2,
      "inProgressTickets": 5,
      "resolvedToday": 3,
      "maxCapacity": 15,
      "capacityUtilizationPct": 53.3,
      "availableTechniciansCount": 2,
      "totalTechniciansCount": 4
    },
    "urgentActionQueue": [
      {
        "ticketId": "tck-105-uuid",
        "ticketNumber": "TCK-105",
        "title": "Dosing pump failure with fertilizer leak",
        "category": "Fertigation Dosing",
        "priority": "Critical",
        "status": "Assigned to Dealer",
        "customerName": "K. Balan",
        "siteLocation": "Pollachi South Farm Block B",
        "createdAt": "2026-08-27T18:30:00Z",
        "actionRequired": "Assign Field Technician"
      }
    ],
    "technicianSummary": {
      "available": 2,
      "onJob": 2,
      "offline": 0
    }
  }
};

// (GET /api/v1/dealer/tickets)
dynamic complaint = {
  "status": "success",
  "pagination": {
    "totalRecords": 8,
    "page": 1,
    "perPage": 20,
    "totalPages": 1
  },
  "data": [
    {
      "ticketId": "tck-105-uuid",
      "ticketNumber": "TCK-105",
      "title": "Dosing pump failure with fertilizer leak",
      "description": "Continuous drip observed at manifold coupling; injection rate dropping.",
      "productName": "ChemDose Pro Fertigation Unit",
      "serialNumber": "CDP-2024-901",
      "issueCategory": "Fertigation Dosing",
      "priority": "Critical",
      "status": "Assigned to Dealer",
      "supportMode": "visit",
      "siteLocation": "Pollachi South Farm Block B",
      "customer": {
        "customerId": "c105-uuid",
        "name": "K. Balan",
        "phone": "+91 98765 44001"
      },
      "assignedTechnicians": [],
      "createdAt": "2026-08-27T18:30:00Z",
      "slaStatus": "warning"
    },
    {
      "ticketId": "tck-104-uuid",
      "ticketNumber": "TCK-104",
      "title": "Irrigation Valve Not Opening on Scheduled Cycle",
      "description": "Zone 3 solenoid valve does not trigger during 6:00 AM automation cycle.",
      "productName": "HydroMaster Solenoid Valve 2-Inch",
      "serialNumber": "HMS-V2-2023-412",
      "issueCategory": "Valves & Hydraulic Actuators",
      "priority": "High",
      "status": "In Progress",
      "supportMode": "visit",
      "siteLocation": "Green Acres Farm, Zone 3, Coimbatore",
      "customer": {
        "customerId": "c101-uuid",
        "name": "S. Siva",
        "phone": "+91 98765 43210"
      },
      "assignedTechnicians": [
        {
          "technicianId": "tech-01-uuid",
          "name": "Ramesh Kumar",
          "phone": "+91 98765 41001",
          "status": "On site"
        }
      ],
      "createdAt": "2026-08-20T09:14:00Z",
      "slaStatus": "onTime"
    }
  ]
};


// (GET /api/v1/dealer/technicians)
dynamic servicePerson = {
  "status": "success",
  "data": [
    {
      "technicianId": "tech-01-uuid",
      "techCode": "TECH-01",
      "name": "Ramesh Kumar",
      "phone": "+91 98765 41001",
      "email": "ramesh@agritech.com",
      "availabilityStatus": "Available",
      "currentlyAssignedCount": 1,
      "totalResolved": 84,
      "rating": 4.9,
      "skills": [
        "Valves & Solenoids",
        "Drip Irrigation Systems",
        "Motor Pump Maintenance"
      ]
    },
    {
      "technicianId": "tech-02-uuid",
      "techCode": "TECH-02",
      "name": "Divya Sundaram",
      "phone": "+91 98765 41002",
      "email": "divya@agritech.com",
      "availabilityStatus": "On job",
      "currentlyAssignedCount": 2,
      "totalResolved": 62,
      "rating": 4.8,
      "skills": [
        "Fertigation Dosing Units",
        "Sensors & Telemetry",
        "IoT Controllers"
      ]
    }
  ]
};