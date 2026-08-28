import '../models/dashboard_models.dart';

abstract class DashboardRemoteDataSource {
  Future<CustomerDashboardData> getCustomerDashboard();
  Future<List<ServiceTicket>> getTickets(String status);
  Future<ServiceTicketDetail> getTicketDetail(String ticketId);
  Future<CustomerReport> getReport(String timeframe);
}

class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  @override
  Future<CustomerDashboardData> getCustomerDashboard() async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 500));

    final Map<String, dynamic> response = {
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
        "requestByCategory": [
          {"category": "Completed", "count": 2, "color": "#28A745"},
          {"category": "In Progress", "count": 1, "color": "#FFC107"},
          {"category": "Pending", "count": 4, "color": "#DC3545"}
        ],
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

    if (response['status'] == 'success') {
      return CustomerDashboardData.fromJson(response['data']);
    } else {
      throw Exception("Failed to fetch dashboard data");
    }
  }

  @override
  Future<List<ServiceTicket>> getTickets(String status) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final Map<String, dynamic> response = {
      "status": "success",
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
            {"name": "Ramesh Kumar", "phone": "+91 98765 41001"}
          ]
        },
        {
          "ticketId": "tck-105-uuid",
          "ticketNumber": "TCK-105",
          "title": "Moisture Sensor Drift & Valve Communication Loss",
          "description": "Sensors in Sector 4 are returning erratic readings (-999 error code).",
          "issueCategory": "Sensors & Calibration",
          "priority": "Medium",
          "status": "Pending Assignment",
          "supportMode": "remote",
          "siteLocation": "Warehouse",
          "createdAt": "2026-08-21T10:00:00Z",
          "hasRating": false,
          "assignedDealersCount": 0,
          "assignedTechnicians": []
        },
        {
          "ticketId": "tck-102-uuid",
          "ticketNumber": "TCK-102",
          "title": "Fertigation Dosing Unit Flow Restriction",
          "description": "Secondary venturi valve is clogged with fertilizer residue.",
          "issueCategory": "Fertilizer & Filter",
          "priority": "High",
          "status": "Assigned to Handler",
          "supportMode": "visit",
          "siteLocation": "Field Site",
          "createdAt": "2026-08-19T08:00:00Z",
          "hasRating": false,
          "assignedDealersCount": 1,
          "assignedTechnicians": []
        },
        {
          "ticketId": "tck-101-uuid",
          "ticketNumber": "TCK-101",
          "title": "Drip Line Pressure Drop & Motor Tripping",
          "description": "Pressure dropped below 1.2 bar; main starter relay keeps tripping.",
          "issueCategory": "Pumps & Starters",
          "priority": "Critical",
          "status": "Closed",
          "supportMode": "visit",
          "siteLocation": "Green Acres Farm, South Field",
          "createdAt": "2026-08-14T11:30:00Z",
          "hasRating": true,
        }
      ]
    };

    if (response['status'] == 'success') {
      return (response['data'] as List).map((e) => ServiceTicket.fromJson(e)).toList();
    } else {
      throw Exception("Failed to fetch tickets");
    }
  }

  @override
  Future<ServiceTicketDetail> getTicketDetail(String ticketId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final Map<String, dynamic> response = {
      "status": "success",
      "data": {
        "ticketId": "tck-104-uuid",
        "ticketNumber": "TCK-104",
        "title": "Irrigation Valve Not Opening on Scheduled Cycle",
        "description":
            "Loud grinding noise and high vibration from the main agricultural water pump line 2 since yesterday morning. Water pressure dropping intermittently.",
        "issueCategory": "Valves & Hydraulic Actuators",
        "priority": "High",
        "status": "In Progress",
        "supportMode": "visit",
        "siteLocation": "Field Site — Coimbatore",
        "preferredSlot": "Morning (9:00 AM - 1:00 PM)",
        "createdAt": "2026-08-20T09:30:00Z",
        "assignedDealer": [
          {
            "dealerId": "dlr-01",
            "name": "Green Sprout Agro",
            "phone": "+91 98765 40001",
            "email": "support@agritech.com",
            "region": "Coimbatore, TN",
            "assignedTechnician": [
              {
                "technicianId": "tech-01",
                "name": "Ramesh Kumar",
                "phone": "+91 98765 43210",
                "rating": 4.6,
                "totalResolved": 84,
                "travelDistance": "4.2 km",
                "estimatedEta": "12 mins",
                "status": "On job"
              },
            ]
          },
        ],
        "stepperMilestones": [
          {
            "stepOrder": 1,
            "key": "submitted",
            "title": "Complaint Raised",
            "description": "Submitted via customer web portal with site location & error log",
            "status": "done",
            "updatedAt": "Aug 20, 09:30 AM",
            "updatedBy": "S. Priya (Customer)"
          },
          {
            "stepOrder": 2,
            "key": "assignedDealer",
            "title": "Assigned to Service Handler (Dealer)",
            "description": "Admin routed ticket to Green Sprout Agro (Primary Handler)",
            "status": "done",
            "updatedAt": "Aug 20, 10:15 AM",
            "updatedBy": "Super Admin"
          },
          {
            "stepOrder": 3,
            "key": "assignedTechnician",
            "title": "Service Person Assigned & Dispatched",
            "description": "Dealer assigned Senior Technician Ramesh K. (+91 98765 43210)",
            "status": "done",
            "updatedAt": "Aug 20, 11:00 AM",
            "updatedBy": "Green Sprout Agro (Dealer)"
          },
          {
            "stepOrder": 4,
            "key": "inProgress",
            "title": "Site Inspection & Repair In Progress",
            "description": "Technician is on-site conducting diagnostic run and replacing motor coupler",
            "status": "current",
            "updatedAt": "Aug 21, 02:30 PM",
            "updatedBy": "Ramesh K. (Service Person)"
          },
          {
            "stepOrder": 5,
            "key": "taskCompleted",
            "title": "Task Completed & Service Report",
            "description": "Technician finalizes work order and uploads test verification",
            "status": "pending",
            "updatedAt": null,
            "updatedBy": null
          },
          {
            "stepOrder": 6,
            "key": "closed",
            "title": "Customer Verification & Rating",
            "description": "Customer reviews service quality and provides satisfaction rating",
            "status": "pending",
            "updatedAt": null,
            "updatedBy": null
          }
        ],
        "timelineEvents": [
          {
            "id": "tl-004",
            "timestamp": "Aug 21, 2026 02:30 PM",
            "title": "Status Updated: In Progress",
            "description": "Technician arrived at site and commenced diagnostics on motor coupler.",
            "actor": "Ramesh K.",
            "actorRole": "Service Person",
            "badgeType": "Dealer Handle"
          },
          {
            "id": "tl-003",
            "timestamp": "Aug 20, 2026 11:00 AM",
            "title": "Technician Assigned",
            "description": "Green Sprout Agro assigned technician Ramesh K. to the complaint.",
            "actor": "Green Sprout Agro",
            "actorRole": "Dealer Handle",
            "badgeType": "Dealer Handle"
          },
          {
            "id": "tl-002",
            "timestamp": "Aug 20, 2026 10:15 AM",
            "title": "Dealer Assigned by Admin",
            "description": "Admin assigned Green Sprout Agro as the primary Service Handler.",
            "actor": "Super Admin",
            "actorRole": "Admin",
            "badgeType": "Admin"
          },
          {
            "id": "tl-001",
            "timestamp": "Aug 20, 2026 09:30 AM",
            "title": "Complaint Created",
            "description": "Customer S. Priya raised complaint for Pump Noise & Vibration Anomaly at Field Site — Coimbatore.",
            "actor": "S. Priya",
            "actorRole": "Customer",
            "badgeType": "Customer"
          }
        ],
        "attachedPhotos": []
      }
    };

    if (response['status'] == 'success') {
      return ServiceTicketDetail.fromJson(response['data']);
    } else {
      throw Exception("Failed to fetch ticket detail");
    }
  }

  @override
  Future<CustomerReport> getReport(String timeframe) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final Map<String, dynamic> response = {
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
          {"category": "Valves & Hydraulic Actuators", "count": 3, "percentage": 50.0, "color": "#3B82F6"},
          {"category": "Pumps & Starters", "count": 2, "percentage": 33.3, "color": "#7C6CF0"},
          {"category": "Sensors & Telemetry", "count": 1, "percentage": 16.7, "color": "#F59E0B"}
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

    if (response['status'] == 'success') {
      return CustomerReport.fromJson(response['data']);
    } else {
      throw Exception("Failed to fetch report");
    }
  }
}
