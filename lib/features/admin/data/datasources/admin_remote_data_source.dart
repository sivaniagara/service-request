import '../models/admin_dashboard_model.dart';
import '../models/admin_ticket_model.dart';
import '../models/admin_ticket_detail_model.dart';
import '../models/admin_dealer_model.dart';
import '../models/admin_report_models.dart';

abstract class AdminRemoteDataSource {
  Future<AdminDashboardModel> getDashboardData();
  Future<AdminTicketModel> getAdminTickets();
  Future<AdminTicketDetailModel> getAdminTicketDetail(String ticketId);
  Future<AdminDealerModel> getAdminDealers();
  Future<AdminReportSummaryModel> getReportSummary();
  Future<AdminSlaComplianceModel> getSlaCompliance();
}

class AdminRemoteDataSourceImpl implements AdminRemoteDataSource {
  @override
  Future<AdminDashboardModel> getDashboardData() async {
    await Future.delayed(const Duration(milliseconds: 500));
    final mockData = {
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
    return AdminDashboardModel.fromJson(mockData);
  }

  @override
  Future<AdminTicketModel> getAdminTickets() async {
    await Future.delayed(const Duration(milliseconds: 500));
    final mockData = {
      "status": "success",
      "pagination": {"totalRecords": 142, "page": 1, "perPage": 20, "totalPages": 8},
      "dealerList": [
        {
          "dealerId": "dlr-01-uuid",
          "dealerCode": "DLR-01",
          "name": "Green Sprout Agro",
          "region": "Coimbatore West",
          "rating": 4.6,
          "techniciansCount": 4,
        },
        {
          "dealerId": "dlr-02-uuid",
          "dealerCode": "DLR-02",
          "name": "Sunrise Farm Tech",
          "region": "Bengaluru, KA",
          "rating": 4.5,
          "techniciansCount": 2,
        },
        {
          "dealerId": "dlr-03-uuid",
          "dealerCode": "DLR-03",
          "name": "AgroCare Solutions",
          "region": "Hyderabad, TS",
          "rating": 4.3,
          "techniciansCount": 0,
        },
      ],
      "data": [
        {
          "ticketId": "tck-105-uuid",
          "ticketNumber": "TCK-105",
          "title": "Moisture Sensor Drift & Valve Communication Loss",
          "description": "Sensors in Sector 4 are returning erratic readings (-999 error code) and the automatic solenoid valve is not responding to scheduled irrigation cycles.",
          "productName": "ChemDose Pro Fertigation Unit",
          "issueCategory": "Fertigation Dosing",
          "priority": "Critical",
          "status": "Pending Assignment",
          "customer": {
            "customerId": "c105-uuid",
            "name": "S. Priya",
            "phone": "+91 98765 44001",
            "siteLocation": "Warehouse — Pollachi"
          },
          "assignedDealers": [],
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
          "assignedDealers": [
            {
              "dealerId": "dlr-01-uuid",
              "dealerName": "Green Sprout Agro",
              "region": "Coimbatore West",
              "isPrimary": true,
              "assignedTechnicians": [
                {"technicianId": "tech-01-uuid", "name": "Ramesh Kumar", "phone": "+91 98765 41001", "status": "On site"}
              ],
            }
          ],
          "createdAt": "2026-08-20T09:14:00Z"
        }
      ]
    };
    return AdminTicketModel.fromJson(mockData);
  }

  @override
  Future<AdminTicketDetailModel> getAdminTicketDetail(String ticketId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final mockData = {
      "status": "success",
      "data": {
        "ticketId": ticketId,
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
        "attachedPhotos": ["https://example.com/uploads/valve_error_01.jpg"]
      }
    };
    return AdminTicketDetailModel.fromJson(mockData);
  }

  @override
  Future<AdminDealerModel> getAdminDealers() async {
    await Future.delayed(const Duration(milliseconds: 500));
    final mockData = {
      "status": "success",
      "pagination": {"totalRecords": 8, "page": 1, "perPage": 20, "totalPages": 1},
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
    return AdminDealerModel.fromJson(mockData);
  }

  @override
  Future<AdminReportSummaryModel> getReportSummary() async {
    await Future.delayed(const Duration(milliseconds: 500));
    final mockData = {
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
          {"date": "2026-08-01", "logged": 4, "resolved": 4},
          {"date": "2026-08-05", "logged": 6, "resolved": 5},
          {"date": "2026-08-10", "logged": 5, "resolved": 6},
          {"date": "2026-08-15", "logged": 8, "resolved": 7},
          {"date": "2026-08-20", "logged": 7, "resolved": 8},
          {"date": "2026-08-25", "logged": 3, "resolved": 3}
        ],
        "supportModeDistribution": {
          "siteVisits": {"count": 104, "percentage": 73.2},
          "remoteSupport": {"count": 38, "percentage": 26.8}
        },
        "priorityBreakdown": {"critical": 12, "high": 46, "medium": 64, "low": 20}
      }
    };
    return AdminReportSummaryModel.fromJson(mockData);
  }

  @override
  Future<AdminSlaComplianceModel> getSlaCompliance() async {
    await Future.delayed(const Duration(milliseconds: 500));
    final mockData = {
      "status": "success",
      "data": {
        "title": "SLA Compliance Breakdown",
        "timeframe": "thisMonth",
        "totalTickets": 100,
        "primaryMetric": {"value": 78, "percentage": 78.0, "label": "ON-TIME"},
        "breakdown": [
          {"id": "onTime", "label": "On-time (within SLA)", "count": 78, "percentage": 78.0, "colorHex": "#10B981"},
          {"id": "delayed", "label": "Delayed (> 24 hrs)", "count": 14, "percentage": 14.0, "colorHex": "#F59E0B"},
          {"id": "breached", "label": "Breached Escalations", "count": 8, "percentage": 8.0, "colorHex": "#EF4444"}
        ]
      }
    };
    return AdminSlaComplianceModel.fromJson(mockData);
  }
}
