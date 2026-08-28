import '../models/dealer_dashboard_model.dart';
import '../models/dealer_ticket_model.dart';
import '../models/dealer_technician_model.dart';

abstract class DealerRemoteDataSource {
  Future<DealerDashboardData> getDealerDashboard();
  Future<List<DealerTicket>> getDealerTickets();
  Future<DealerTicketDetail> getDealerTicketDetail(String ticketId);
  Future<List<DealerTechnician>> getTechnicians();
}

class DealerRemoteDataSourceImpl implements DealerRemoteDataSource {
  @override
  Future<DealerDashboardData> getDealerDashboard() async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 500));

    final Map<String, dynamic> response = {
      "status": "success",
      "data": {
        "dealerProfile": {
          "dealerId": "dlr-01-uuid",
          "dealerCode": "DLR-01",
          "name": "Green Sprout Agro",
          "region": "Coimbatore, TN",
          "officeAddress": "12 Cross Cut Road, Gandhipuram, Coimbatore",
          "phone": "+91 98765 40001",
          "rating": 4.6
        },
        "metrics": {
          "totalActiveTickets": 37,
          "pendingTechnicianAssignment": 2,
          "inProgressTickets": 31,
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

    if (response['status'] == 'success') {
      return DealerDashboardData.fromJson(response['data']);
    } else {
      throw Exception("Failed to fetch dealer dashboard data");
    }
  }

  @override
  Future<List<DealerTicket>> getDealerTickets() async {
    await Future.delayed(const Duration(milliseconds: 500));
    final Map<String, dynamic> response = {
      "status": "success",
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

    if (response['status'] == 'success') {
      return (response['data'] as List).map((e) => DealerTicket.fromJson(e)).toList();
    } else {
      throw Exception("Failed to fetch dealer tickets");
    }
  }

  @override
  Future<DealerTicketDetail> getDealerTicketDetail(String ticketId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    final allDetails = {
      "tck-104-uuid": {
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
        "customer": {
          "customerId": "c101-uuid",
          "name": "S. Siva",
          "phone": "+91 98765 43210",
          "siteLocation": "Green Acres Farm, Zone 3"
        },
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

    final ticketData = allDetails[ticketId];
    if (ticketData != null) {
      return DealerTicketDetail.fromJson(ticketData);
    } else {
      // Fallback for other IDs to avoid breaking the UI during demo
      return DealerTicketDetail.fromJson(allDetails["tck-104-uuid"]!);
    }
  }

  @override
  Future<List<DealerTechnician>> getTechnicians() async {
    await Future.delayed(const Duration(milliseconds: 500));
    final List<Map<String, dynamic>> mockData = [
      {
        "technicianId": "tech-01-uuid",
        "techCode": "TECH-01",
        "name": "Ramesh Kumar",
        "phone": "+91 98765 41001",
        "email": "ramesh@agritech.com",
        "availabilityStatus": "On job",
        "currentlyAssignedCount": 3,
        "totalResolved": 58,
        "rating": 4.8,
        "skills": ["Repair", "Valve", "Hardware"],
        "isSkillsMatch": true,
      },
      {
        "technicianId": "tech-02-uuid",
        "techCode": "TECH-02",
        "name": "Divya Sundaram",
        "phone": "+91 98765 41002",
        "email": "divya@agritech.com",
        "availabilityStatus": "Available",
        "currentlyAssignedCount": 1,
        "totalResolved": 44,
        "rating": 4.7,
        "skills": ["Sensors", "Application", "Inspection"],
        "isSkillsMatch": false,
      },
      {
        "technicianId": "tech-03-uuid",
        "techCode": "TECH-03",
        "name": "Suresh Mani",
        "phone": "+91 98765 41003",
        "email": "suresh@agritech.com",
        "availabilityStatus": "On Site",
        "currentlyAssignedCount": 2,
        "totalResolved": 31,
        "rating": 4.4,
        "skills": ["Maintenance", "Installation", "Hardware"],
        "isSkillsMatch": true,
      },
      {
        "technicianId": "tech-04-uuid",
        "techCode": "TECH-04",
        "name": "Anitha R.",
        "phone": "+91 98765 55678",
        "email": "anitha@agritech.com",
        "availabilityStatus": "Available",
        "currentlyAssignedCount": 0,
        "totalResolved": 19,
        "rating": 4.6,
        "skills": ["Inspection", "Fertilizer", "Filter"],
        "isSkillsMatch": false,
      },
    ];

    return mockData.map((e) => DealerTechnician.fromJson(e)).toList();
  }
}
