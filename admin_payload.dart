// (GET /api/v1/admin/dashboard)
dynamic admin = {
  "status": "success",
  "data": {
    "summaryMetrics": {
      "totalTickets": 142,
      "pendingAssignment": 6,
      "inProgress": 28,
      "escalated": 3,
      "resolvedToday": 12,
      "activeDealersCount": 8,
      "activeFieldTechnicians": 34,
      "slaComplianceRate": "96.4%",
      "avgFirstResponseMinutes": 18
    },
    "regionalDistribution": [
      {
        "regionCode": "CBE-W",
        "regionName": "Coimbatore West",
        "activeTickets": 14,
        "dealersCount": 2,
        "availableTechnicians": 6,
        "capacityUtilizationPct": 70.0,
        "status": "normal"
      },
      {
        "regionCode": "PLK-S",
        "regionName": "Pollachi South",
        "activeTickets": 11,
        "dealersCount": 2,
        "availableTechnicians": 1,
        "capacityUtilizationPct": 92.0,
        "status": "nearCapacityWarning"
      },
      {
        "regionCode": "TPR-C",
        "regionName": "Tirupur Central",
        "activeTickets": 3,
        "dealersCount": 1,
        "availableTechnicians": 4,
        "capacityUtilizationPct": 30.0,
        "status": "normal"
      }
    ],
    "urgentAttentionQueue": [
      {
        "ticketId": "tck-105-uuid",
        "ticketNumber": "TCK-105",
        "title": "Dosing pump failure with fertilizer leak",
        "customerName": "K. Balan",
        "siteLocation": "Pollachi South Farm Block B",
        "priority": "Critical",
        "status": "Pending Assignment",
        "ageInHours": 2.4,
        "slaBreachInHours": 1.6
      },
      {
        "ticketId": "tck-103-uuid",
        "ticketNumber": "TCK-103",
        "title": "Motor relay tripped repeatedly",
        "customerName": "Green Valley Agro",
        "siteLocation": "Annur North",
        "priority": "High",
        "status": "Escalated",
        "escalationReason": "Dealer capacity exceeded in Zone 2",
        "ageInHours": 8.1
      }
    ]
  }
};


// (GET /api/v1/admin/tickets)
dynamic adminComplaint = {
  "status": "success",
  "pagination": {
    "totalRecords": 142,
    "page": 1,
    "perPage": 20,
    "totalPages": 8
  },
  "dealerList": [
    {
      "dealerId": "dlr-01-uuid",
      "dealerCode": "DLR-01",
      "name": "AgriTech Service Solutions",
      "region": "Coimbatore West",
      "rating": 4.9,
      "techniciansCount": 4,
    },
    {
      "dealerId": "dlr-01-uuid",
      "dealerCode": "DLR-01",
      "name": "AgriTech Service Solutions",
      "region": "Coimbatore West",
      "rating": 4.9,
      "techniciansCount": 4,
    },
    {
      "dealerId": "dlr-01-uuid",
      "dealerCode": "DLR-01",
      "name": "AgriTech Service Solutions",
      "region": "Coimbatore West",
      "rating": 4.9,
      "techniciansCount": 4,
    },
  ],
  "data": [
    {
      "ticketId": "tck-105-uuid",
      "ticketNumber": "TCK-105",
      "title": "Dosing pump failure with fertilizer leak",
      "description": "Continuous drip observed at manifold coupling; injection rate dropping.",
      "productName": "ChemDose Pro Fertigation Unit",
      "issueCategory": "Fertigation Dosing",
      "priority": "Critical",
      "status": "Pending Assignment",
      "customer": {
        "customerId": "c105-uuid",
        "name": "K. Balan",
        "phone": "+91 98765 44001",
        "siteLocation": "Pollachi South, Farm Block B"
      },
      "createdAt": "2026-08-24T18:30:00Z"
    },
    {
      "ticketId": "tck-104-uuid",
      "ticketNumber": "TCK-104",
      "title": "Irrigation Valve Not Opening on Scheduled Cycle",
      "description": "Zone 3 solenoid valve does not trigger during 6:00 AM automation cycle.",
      "productName": "HydroMaster Solenoid Valve 2-Inch",
      "issueCategory": "Valves & Hydraulic Actuators",
      "priority": "High",
      "status": "In Progress",
      "supportMode": "visit",
      "customer": {
        "customerId": "c101-uuid",
        "name": "S. Siva",
        "phone": "+91 98765 43210",
        "siteLocation": "Green Acres Farm, Zone 3"
      },
      "createdAt": "2026-08-20T09:14:00Z"
    }
  ]
};


// (GET /api/v1/admin/dealers)
dynamic dealerList = {
  "status": "success",
  "pagination": {
    "totalRecords": 8,
    "page": 1,
    "perPage": 20,
    "totalPages": 1
  },
  "summary": {
    "totalDealers": 8,
    "activeDealers": 7,
    "totalTechnicians": 34,
    "avgDealerRating": 4.82
  },
  "data": [
    {
      "dealerId": "dlr-01-uuid",
      "dealerCode": "DLR-01",
      "name": "AgriTech Service Solutions",
      "region": "Coimbatore West",
      "territoryZones": ["Zone 1", "Zone 2", "Zone 3 - Thudiyalur"],
      "officeAddress": "12 Cross Cut Road, Gandhipuram, Coimbatore, TN 641012",
      "contactPerson": {
        "userId": "usr-d1-uuid",
        "name": "Saravanan",
        "designation": "Dealer Principal / Admin",
        "email": "support@agritech.com",
        "phone": "+91 98765 40001"
      },
      "capacity": {
        "maxConcurrentTickets": 15,
        "activeAssignedTickets": 8,
        "utilizationPercentage": 53.3,
        "capacityStatus": "optimal"
      },
      "techniciansCount": 4,
      "performance": {
        "rating": 4.9,
        "totalTicketsResolved": 312,
        "slaComplianceRate": "98.2%",
        "avgResolutionHours": 2.4
      },
      "isActive": true,
      "onboardedDate": "2024-01-15T10:00:00Z"
    },
    {
      "dealerId": "dlr-02-uuid",
      "dealerCode": "DLR-02",
      "name": "Kovai Irrigation Hub",
      "region": "Pollachi South",
      "territoryZones": ["Pollachi Central", "Anamalai Sector"],
      "officeAddress": "84 Meenkarai Road, Pollachi, TN 642001",
      "contactPerson": {
        "userId": "usr-d2-uuid",
        "name": "Karthik Rajan",
        "designation": "Branch Manager",
        "email": "kovai.irrigation@gmail.com",
        "phone": "+91 98765 40002"
      },
      "capacity": {
        "maxConcurrentTickets": 10,
        "activeAssignedTickets": 9,
        "utilizationPercentage": 90.0,
        "capacityStatus": "nearCapacity"
      },
      "techniciansCount": 3,
      "performance": {
        "rating": 4.7,
        "totalTicketsResolved": 198,
        "slaComplianceRate": "94.1%",
        "avgResolutionHours": 3.8
      },
      "isActive": true,
      "onboardedDate": "2024-03-20T10:00:00Z"
    }
  ]
};

// (POST /api/v1/admin/createDealer)
dynamic addDealer = {
  "name": "Delta Agri Machinery & Spares",
  "region": "Erode Central",
  "territoryZones": [
    "Erode Town",
    "Bhavani Agro Sector",
    "Perundurai Industrial Zone"
  ],
  "officeAddress": "104 Brough Road, Erode, Tamil Nadu 638001",
  "phone": "+91 98765 40005",
  "email": "contact@deltaagri.in",
  "maxConcurrentTickets": 20,
};


// (GET /api/v1/admin/reports/summary)
dynamic summary = {
  "status": "success",
  "data": {
    "filter": {
      "timeframe": "this_month",
      "startDate": "2026-08-01",
      "endDate": "2026-08-31",
      "region": "All Regions"
    },
    "kpiMetrics": {
      "totalTicketsLogged": 142,
      "totalTicketsResolved": 136,
      "pendingTickets": 6,
      "slaComplianceRate": 96.4,
      "averageFirstResponseMinutes": 18.5,
      "averageResolutionHours": 3.6,
      "firstVisitFixRatio": 93.4,
      "overallCustomerSatisfactionScore": 4.86,
      "totalRatingsReceived": 118
    },
    "ticketVolumeTrends": [
      { "date": "2026-08-01", "logged": 4, "resolved": 4 },
      { "date": "2026-08-05", "logged": 6, "resolved": 5 },
      { "date": "2026-08-10", "logged": 5, "resolved": 6 },
      { "date": "2026-08-15", "logged": 8, "resolved": 7 },
      { "date": "2026-08-20", "logged": 7, "resolved": 8 },
      { "date": "2026-08-25", "logged": 3, "resolved": 3 }
    ],
    "supportModeDistribution": {
      "siteVisits": { "count": 104, "percentage": 73.2 },
      "remoteSupport": { "count": 38, "percentage": 26.8 }
    },
    "priorityBreakdown": {
      "critical": 12,
      "high": 46,
      "medium": 64,
      "low": 20
    }
  }
};


// (GET /api/v1/admin/reports/dealers)
// ?timeframe=this_month&sort_by=sla_compliance&order=desc
dynamic dealerComplaint = {
  "status": "success",
  "data": {
    "dealersCount": 8,
    "averageDealerSla": 95.8,
    "rankings": [
      {
        "rank": 1,
        "dealerId": "dlr-01-uuid",
        "dealerCode": "DLR-01",
        "dealerName": "AgriTech Service Solutions",
        "region": "Coimbatore West",
        "totalAssigned": 49,
        "totalResolved": 48,
        "activeBacklog": 1,
        "avgTurnaroundHours": 2.4,
        "firstVisitFixPct": 96.0,
        "slaMetPct": 98.0,
        "slaBreachedCount": 1,
        "csatRating": 4.92,
        "status": "exceptional"
      },
      {
        "rank": 2,
        "dealerId": "dlr-02-uuid",
        "dealerCode": "DLR-02",
        "dealerName": "Kovai Irrigation Hub",
        "region": "Pollachi South",
        "totalAssigned": 36,
        "totalResolved": 34,
        "activeBacklog": 2,
        "avgTurnaroundHours": 3.8,
        "firstVisitFixPct": 91.2,
        "slaMetPct": 94.4,
        "slaBreachedCount": 2,
        "csatRating": 4.75,
        "status": "good"
      },
      {
        "rank": 3,
        "dealerId": "dlr-03-uuid",
        "dealerCode": "DLR-03",
        "dealerName": "HydroCare Engineering",
        "region": "Tirupur Central",
        "totalAssigned": 28,
        "totalResolved": 28,
        "activeBacklog": 0,
        "avgTurnaroundHours": 3.1,
        "firstVisitFixPct": 92.8,
        "slaMetPct": 96.4,
        "slaBreachedCount": 1,
        "csatRating": 4.81,
        "status": "good"
      }
    ]
  }
};


// GET /api/v1/admin/reports/sla-compliance
// ?timeframe=this_month&region=all&dealer_id=all
dynamic  slaCompliance = {
  "status": "success",
  "data": {
    "title": "SLA Compliance Breakdown",
    "timeframe": "thisMonth",
    "totalTickets": 100,
    "primaryMetric": {
      "value": 78,
      "percentage": 78.0,
      "label": "ON-TIME"
    },
    "breakdown": [
      {
        "id": "onTime",
        "label": "On-time (within SLA)",
        "count": 78,
        "percentage": 78.0,
        "colorHex": "#10B981"
      },
      {
        "id": "delayed",
        "label": "Delayed (> 24 hrs)",
        "count": 14,
        "percentage": 14.0,
        "colorHex": "#F59E0B"
      },
      {
        "id": "breached",
        "label": "Breached Escalations",
        "count": 8,
        "percentage": 8.0,
        "colorHex": "#EF4444"
      }
    ]
  }
};