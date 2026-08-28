dynamic dashboard = {
  "status": "success",
  "data": {
    "customerProfile": {
      "userId": 1,
      "name": "S. Siva",
      "phone": "+91 98765 43210",
      "email": "siva@greenacres.in",
      "address": "Zone 3, Near Thudiyalur Road, Coimbatore, Tamil Nadu"
    },
    "metrics": {
      "totalComplaintsRaised": 4,
      "inProgressCount": 2,
      "resolvedCount": 2,
      "overallSatisfactionRating": 4.9
    },
    "requestByCategory": {
      "hardware": 2,
      "software": 1,
      "sensor": 4
    },
    "activeTickets": [
      {
        "ticketId": "tck-104-uuid",
        "ticketNumber": "TCK-104",
        "title": "Irrigation Valve Not Opening on Scheduled Cycle",
        "category": "Valves & Hydraulic Actuators",
        "priority": "High",
        "status": "In Progress",
        "currentMilestone": "Traveling to site",
        "supportMode": "visit",
        "siteLocation": "Green Acres Farm, Zone 3",
        "createdAt": "2026-08-20T09:14:00Z",
        "assignedDealer": [
          {
            "dealerId": "dlr-01-uuid",
            "name": "AgriTech Service Solutions",
            "phone": "+91 98765 40001",
            "assignedTechnician": [
              {
                "technicianId": "tech-01-uuid",
                "name": "Ramesh Kumar",
                "phone": "+91 98765 41001",
                "status": "En Route"
              }
            ]
          }
        ],
      }
    ],
    "recentTickets": [
      {
        "ticketId": "tck-104-uuid",
        "ticketNumber": "TCK-104",
        "title": "Irrigation Valve Not Opening on Scheduled Cycle",
        "status": "In Progress",
      },
      {
        "ticketId": "tck-105-uuid",
        "ticketNumber": "TCK-104",
        "title": "Irrigation Valve Not Opening on Scheduled Cycle",
        "status": "In Progress",
      },
      {
        "ticketId": "tck-106-uuid",
        "ticketNumber": "TCK-104",
        "title": "Irrigation Valve Not Opening on Scheduled Cycle",
        "status": "In Progress",
      },
    ]
  }
};

// (GET /api/v1/customer/tickets?status=all)
dynamic myServiceRequest = {
  "status": "success",
  "pagination": {
    "totalRecords": 4,
    "page": 1,
    "perPage": 20
  },
  "data": [
    {
      "ticketId": "tck-104-uuid",
      "ticketNumber": "TCK-104",
      "title": "Irrigation Valve Not Opening on Scheduled Cycle",
      "description": "Zone 3 solenoid valve does not trigger during 6:00 AM automation cycle.",
      "issueCategory": "Valves & Hydraulic Actuators",
      "priority": "High",
      "status": "In Progress",
      "supportMode": "visit",
      "siteLocation": "Green Acres Farm, Zone 3",
      "createdAt": "2026-08-20T09:14:00Z",
      "hasRating": false,
      "assignedDealersCount": 1,
      "assignedTechnicians": [
        {
          "name": "Ramesh Kumar",
          "phone": "+91 98765 41001"
        }
      ]
    },
    {
      "ticketId": "tck-101-uuid",
      "ticketNumber": "TCK-101",
      "title": "Drip Line Pressure Drop & Motor Tripping",
      "description": "Pressure dropped below 1.2 bar; main starter relay keeps tripping.",
      "productName": "Submersible High-Flow Pump 5HP",
      "serialNumber": "SHP-5HP-2023-102",
      "issueCategory": "Pumps & Starters",
      "priority": "Critical",
      "status": "Closed",
      "supportMode": "visit",
      "siteLocation": "Green Acres Farm, South Field",
      "createdAt": "2026-08-14T11:30:00Z",
      "hasRating": true,
      "customerRating": {
        "rating": 5,
        "feedback": "Promptly fixed the motor coupling and pressure is restored back to 2.4 bar."
      }
    }
  ]
};


// GET /api/v1/customer/tickets/{ticket_id})
dynamic selectedTicket = {
  "status": "success",
  "data": {
    "ticketId": "tck-104-uuid",
    "ticketNumber": "TCK-104",
    "title": "Irrigation Valve Not Opening on Scheduled Cycle",
    "description": "Zone 3 solenoid valve does not trigger during 6:00 AM automation cycle.",
    "issueCategory": "Valves & Hydraulic Actuators",
    "priority": "High",
    "status": "In Progress",
    "supportMode": "visit",
    "siteLocation": "Green Acres Farm, Zone 3",
    "preferredSlot": "Morning (9:00 AM - 1:00 PM)",
    "createdAt": "2026-08-20T09:14:00Z",
    "assignedDealer": [
      {
        "dealerId": "dlr-01",
        "name": "AgriTech Service Solutions",
        "phone": "+91 98765 40001",
        "email": "support@agritech.com",
        "region": "Coimbatore West",
        "assignedTechnician": [
          {
            "technicianId": "tech-01",
            "name": "Ramesh Kumar",
            "phone": "+91 98765 41001",
            "rating": 4.9,
            "totalResolved": 84,
            "travelDistance": "4.2 km",
            "estimatedEta": "12 mins"
          },
        ]
      },
    ],
    "stepperMilestones": [
      {
        "stepOrder": 1,
        "key": "submitted",
        "title": "Complaint Submitted",
        "description": "Logged via Customer App with site address and equipment tag.",
        "status": "done",
        "updatedAt": "Aug 20, 9:14 AM",
        "updatedBy": "S. Siva (Customer)"
      },
      {
        "stepOrder": 2,
        "key": "assignedDealer",
        "title": "Assigned to Regional Dealer",
        "description": "Routed to AgriTech Service Solutions (Coimbatore West).",
        "status": "done",
        "updatedAt": "Aug 20, 9:18 AM",
        "updatedBy": "Central Dispatch System"
      },
      {
        "stepOrder": 3,
        "key": "assignedTechnician",
        "title": "Technician Allocated",
        "description": "Technician Ramesh Kumar assigned based on Valve & Hydraulics certification.",
        "status": "done",
        "updatedAt": "Aug 20, 9:20 AM",
        "updatedBy": "AgriTech Service Solutions"
      },
      {
        "stepOrder": 4,
        "key": "inProgress",
        "title": "On-Site Inspection & Diagnostics",
        "description": "Technician en route to site. Check-in and repair verification pending.",
        "status": "current",
        "updatedAt": "Aug 20, 9:31 AM",
        "updatedBy": "Ramesh Kumar (Service Person)"
      },
      {
        "stepOrder": 5,
        "key": "taskCompleted",
        "title": "Task Resolution & Verification",
        "description": "Technician completes physical repair, tests flow cycle, and uploads proof.",
        "status": "pending",
        "updatedAt": null,
        "updatedBy": null
      },
      {
        "stepOrder": 6,
        "key": "closed",
        "title": "Customer Rating & Sign-off",
        "description": "Customer confirms satisfaction and rates service quality.",
        "status": "pending",
        "updatedAt": null,
        "updatedBy": null
      }
    ],
    "timelineEvents": [
      {
        "id": "tl-004",
        "timestamp": "Aug 20, 2026, 9:31 AM",
        "title": "Technician En Route to Site",
        "description": "Ramesh Kumar departed service center for Green Acres Farm.",
        "actor": "Ramesh Kumar",
        "actorRole": "servicePerson",
        "badgeType": "status"
      },
      {
        "id": "tl-003",
        "timestamp": "Aug 20, 2026, 9:20 AM",
        "title": "Job Accepted by Ramesh Kumar",
        "description": "Toolkit and spare parts allocated for 2-inch solenoid valve.",
        "actor": "Ramesh Kumar",
        "actorRole": "servicePerson",
        "badgeType": "status"
      },
      {
        "id": "tl-002",
        "timestamp": "Aug 20, 2026, 9:18 AM",
        "title": "Assigned to Dealer: AgriTech Solutions",
        "description": "Auto-routed by geographical proximity and technician availability.",
        "actor": "Admin Dispatch",
        "actorRole": "admin",
        "badgeType": "assignment"
      },
      {
        "id": "tl-001",
        "timestamp": "Aug 20, 2026, 9:14 AM",
        "title": "Complaint Logged",
        "description": "Customer reported valve failure on scheduled cycle.",
        "actor": "S. Siva",
        "actorRole": "customer",
        "badgeType": "create"
      }
    ],
    "attachedPhotos": [
      "https://example.com/uploads/valve_error_01.jpg"
    ]
  }
};


// (GET /api/v1/customer/reports?timeframe=this_year)
dynamic customerReport = {
  "status": "success",
  "data": {
    "timeframe": "2026 (Year to Date)",
    "summaryCards": {
      "totalServiceRequests": 6,
      "firstVisitResolvedRate": "100%",
      "averageTurnaroundHours": 3.2,
      "averageSatisfactionScore": 4.9
    },
    "categoryBreakdown": [
      {
        "category": "Valves & Hydraulic Actuators",
        "count": 3,
        "percentage": 50.0
      },
      {
        "category": "Pumps & Starters",
        "count": 2,
        "percentage": 33.3
      },
      {
        "category": "Sensors & Telemetry",
        "count": 1,
        "percentage": 16.7
      }
    ],
    "serviceHistory": [
      {
        "ticketNumber": "TCK-101",
        "product": "Submersible High-Flow Pump 5HP",
        "resolvedDate": "2026-08-15",
        "turnaroundTime": "2 hrs 10 mins",
        "technicianName": "Ramesh Kumar",
        "dealerName": "AgriTech Service Solutions",
        "ratingGiven": 5,
        "downloadPdfUrl": "https://example.com/reports/TCK-101-service-summary.pdf"
      },
      {
        "ticketNumber": "TCK-096",
        "product": "HydroMaster Solenoid Valve 2-Inch",
        "resolvedDate": "2026-07-22",
        "turnaroundTime": "1 hr 45 mins",
        "technicianName": "Ramesh Kumar",
        "dealerName": "AgriTech Service Solutions",
        "ratingGiven": 5,
        "downloadPdfUrl": "https://example.com/reports/TCK-096-service-summary.pdf"
      }
    ]
  }
};


// (POST /api/v1/customer/tickets)
dynamic createComplaint = {
  "title": "Controller Display Blank & No Power",
  "description": "The LCD panel is unresponsive after heavy rain; power switch shows red indicator.",
  "issueCategory": "Controllers & Electrical",
  "priority": "High",
  "latitude": 0.0,
  "longitude": 0.0,
  "siteLocation": "Green Acres Farm, Pump House #2",
  "preferredDate": "2026-08-25",
  "preferredTimeSlot": "Morning (9:00 AM - 1:00 PM)",
  "photos": [
    "data:image/jpeg;base64,/9j/4AAQSkZJRg..."
  ]
};