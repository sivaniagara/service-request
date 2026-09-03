
// GET /api/v1/service-persons/id
dynamic technicianProfile = {
  "success": true,
  "technician": {
    "id": "tech-1",
    "name": "Arjun Kumar",
    "phone": "+91 98450 12345",
    "email": "arjun.k@karnatakadealers.com",
    "dealerName": "Karnataka Agri Power Machinery Hub",
    "subDealerBranchName": "Hoskote Agro Spares & Service Branch",
    "availabilityStatus": "Available",
    "experienceYears": 6,
    "skills": [
      "Tractor Hydraulics",
      "Combine Harvester Engine",
      "GPS & Telematics",
      "Laser Leveling",
      "High-Pressure Spool Valves",
      "CRDI Fuel Injection"
    ],
  },

  "metrics": {
    "activeJobsCount": 2,
    "criticalJobsCount": 1,
    "completedJobsCount": 142,
    "averageRating": 4.9,
    "firstTimeFixRate": 96.2
  },

  "assignedJobs": [
    {
      "ticketId": "t-001",
      "ticketNumber": "TK-84920",
      "title": "Severe Hydraulic Cylinder Fluid Leakage Under Load",
      "priority": "Critical",
      "status": "In Progress",
      "techWorkState": "assigned",
      "requiredSkillMatch": "Tractor Hydraulics",
      "customerName": "Ramesh Gowda",
      "siteLocation": "Hoskote Farm Cluster 4, Bangalore Rural — Plot 12B",
      "createdAt": "2026-08-28T09:15:00Z"
    }
  ]
};
