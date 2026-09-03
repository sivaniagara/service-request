import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/network/token_manager.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_side_navigation.dart';
import '../../../../injection_container.dart';
import '../../data/models/technician_model.dart';
import '../../data/models/technician_report_model.dart';
import '../../data/models/technician_ticket_model.dart';
import '../widgets/technician_dashboard_view.dart';
import '../widgets/technician_reports_view.dart';
import '../widgets/technician_service_requests_view.dart';

enum TechnicianTab { dashboard, serviceRequests, reports }

class TechnicianDashboardPage extends StatefulWidget {
  const TechnicianDashboardPage({super.key});

  @override
  State<TechnicianDashboardPage> createState() => _TechnicianDashboardPageState();
}

class _TechnicianDashboardPageState extends State<TechnicianDashboardPage> {
  TechnicianTab _activeTab = TechnicianTab.dashboard;
  String _targetTicketId = '';

  // Data
  late TechnicianProfile _profile;
  List<TechnicianTicket> _tickets = [];
  late TechnicianReportData _reportData;
  List<TechnicianHistoryItem> _history = [];

  final Map<String, dynamic> _mockProfilePayload = {
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
      "skills": ["Tractor Hydraulics", "Combine Harvester Engine", "GPS & Telematics", "Laser Leveling", "High-Pressure Spool Valves", "CRDI Fuel Injection"],
    },
    "metrics": {"activeJobsCount": 2, "criticalJobsCount": 1, "completedJobsCount": 142, "averageRating": 4.9, "firstTimeFixRate": 96.2},
    "assignedJobs": [
      {
        "ticketId": "tk-1002",
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

  final Map<String, dynamic> _mockTicketsPayload = {
    "data": [
      {
        "ticketId": "tk-1002",
        "ticketNumber": "TK-84920",
        "title": "Severe Hydraulic Cylinder Fluid Leakage Under Load",
        "category": "Hydraulic System",
        "priority": "High",
        "status": "In Progress",
        "equipmentModel": "Mahindra 575 DI Tractor 45HP (2022)",
        "equipmentSerialNo": "MHD-TRAC-2022-8419",
        "customer": {"id": "cust-1", "name": "Ramesh Gowda", "phone": "+91 98451 22334", "siteLocation": "Hoskote Farm Cluster 4, Bangalore Rural — Plot 12B"},
        "delegatedSubDealer": {"id": "sub-dealer-hoskote", "name": "Hoskote Agro Spares & Service Branch", "contactPerson": "Naveen Kumar", "phone": "+91 98450 77112"},
        "scheduledTime": "2026-09-01T10:30:00Z",
        "supportMode": "Site Visit",
        "stepperSteps": [
          {"stepOrder": 1, "title": "Ticket Created", "description": "Farmer Ramesh reported the issue", "status": "done", "updatedAt": "Aug 28, 09:15 AM"},
          {"stepOrder": 2, "title": "Dealer Assigned", "description": "Assigned to Karnataka Agri Hub", "status": "done", "updatedAt": "Aug 28, 10:45 AM"},
          {"stepOrder": 3, "title": "Technician Dispatched", "description": "Arjun dispatched to site", "status": "done", "updatedAt": "Sep 01, 09:00 AM"},
          {"stepOrder": 4, "title": "On-Site Diagnosis", "description": "Inspecting hydraulic system", "status": "current", "updatedAt": "Sep 01, 10:45 AM"},
          {"stepOrder": 5, "title": "Resolution", "description": "Repair in progress", "status": "pending"}
        ],
        "timelineEvents": [
          {"id": "ev-1", "timestamp": "10:45 AM", "title": "Diagnosis Started", "description": "Technician arrived at site and started inspection."},
          {"id": "ev-2", "timestamp": "09:00 AM", "title": "Technician Dispatched", "description": "Arjun Kumar is en-route to the customer location."}
        ]
      },
      {
        "ticketId": "tk-1003",
        "ticketNumber": "TK-84921",
        "title": "Starter Motor Relay Failure — Tractor Won’t Crank",
        "category": "Electrical System",
        "priority": "Critical",
        "status": "Pending Assignment",
        "equipmentModel": "John Deere 5105 Tractor 40HP (2021)",
        "equipmentSerialNo": "JD-5105-2021-5521",
        "customer": {"id": "cust-2", "name": "Lakshmi Narayan", "phone": "+91 98765 11223", "siteLocation": "Tumkur Agro Field, Plot 7A"},
        "delegatedSubDealer": {"id": "sub-dealer-tumkur", "name": "Tumkur Tractor Service Hub", "contactPerson": "Prakash", "phone": "+91 98453 77890"},
        "scheduledTime": null,
        "supportMode": "Remote Support",
        "stepperSteps": [
          {"stepOrder": 1, "title": "Ticket Created", "description": "Complaint registered", "status": "done", "updatedAt": "Aug 30, 02:00 PM"},
          {"stepOrder": 2, "title": "Dealer Assigned", "description": "Waiting for assignment", "status": "pending"}
        ],
        "timelineEvents": [
          {"id": "ev-3", "timestamp": "02:00 PM", "title": "Ticket Created", "description": "Complaint registered by customer via app."}
        ]
      }
    ]
  };

  final Map<String, dynamic> _mockReportPayload = {
    "success": true,
    "technician": {
      "id": "tech-1",
      "name": "Arjun Kumar",
      "dealerName": "Karnataka Agri Power Machinery Hub",
      "subDealerBranchName": "Hoskote Agro Spares & Service Branch"
    },
    "timeRange": "this_month",
    "period": {"startDate": "2026-08-01", "endDate": "2026-08-31"},
    "kpis": {
      "totalJobsAssigned": 40,
      "totalJobsResolved": 38,
      "pendingJobs": 2,
      "completionRatePercentage": 95.0,
      "firstTimeFixRatePercentage": 94.7,
      "averageResolutionTimeHours": 3.2,
      "averageTravelTimeMinutes": 32,
      "onTimeSlaCompliancePercentage": 97.4,
      "averageRating": 4.9,
      "totalReviewsCount": 36,
      "ratingDistribution": {"5_star": 33, "4_star": 3, "3_star": 0, "2_star": 0, "1_star": 0}
    },
    "incentivesAndEarnings": {
      "baseDoorstepVisitsCount": 38,
      "distanceTravelledKm": 412.5,
      "totalLaborHours": 68.5,
      "sparePartsReplacementValueINR": 84250.00,
      "earnedIncentiveINR": 6840.00
    }
  };

  final Map<String, dynamic> _mockHistoryPayload = {
    "history": [
      {
        "ticketId": "t-001",
        "ticketNumber": "TK-84920",
        "title": "Severe Hydraulic Cylinder Fluid Leakage Under Load",
        "category": "Hydraulics",
        "product": "Mahindra 575 DI XP Plus Tractor (47 HP)",
        "priority": "Critical",
        "status": "Task Completed",
        "supportMode": "visit",
        "customer": {"name": "Ramesh Gowda", "siteLocation": "Hoskote Farm Cluster 4, Bangalore Rural — Plot 12B"},
        "customerFeedback": {"rating": 5, "comment": "Very quick doorstep arrival by Arjun. Tractor lifting perfectly now."}
      },
      {
        "ticketId": "t-004",
        "ticketNumber": "TK-84915",
        "title": "Alternator Wiring Harness Short Circuit & Battery Drain",
        "category": "Electrical",
        "product": "Sonalika DI 60 Sikander Tractor",
        "priority": "High",
        "status": "Task Completed",
        "supportMode": "visit",
        "customer": {"name": "Suresh Reddy", "siteLocation": "Devanahalli, Plot 4A"},
        "customerFeedback": {"rating": 5, "comment": "Replaced wiring on site cleanly."}
      }
    ]
  };

  @override
  void initState() {
    super.initState();
    _profile = TechnicianProfile.fromJson(_mockProfilePayload);
    final List ticketData = _mockTicketsPayload['data'];
    _tickets = ticketData.map((e) => TechnicianTicket.fromJson(e)).toList();
    _reportData = TechnicianReportData.fromJson(_mockReportPayload);
    final List historyData = _mockHistoryPayload['history'];
    _history = historyData.map((e) => TechnicianHistoryItem.fromJson(e)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Row(
        children: [
          AppSideNavigation(
            brandName: 'Green Sprout',
            brandSubtext: 'Technician Console',
            onProfileTap: () {},
            onLogoutTap: () async {
              await sl<TokenManager>().deleteToken();
              if (mounted) context.go(RouteNames.login);
            },
            items: [
              NavItem(
                icon: Icons.dashboard_outlined,
                label: 'Dashboard',
                isActive: _activeTab == TechnicianTab.dashboard,
                onTap: () => setState(() => _activeTab = TechnicianTab.dashboard),
              ),
              NavItem(
                icon: Icons.build_outlined,
                label: 'Service Request',
                isActive: _activeTab == TechnicianTab.serviceRequests,
                onTap: () => setState(() {
                  _activeTab = TechnicianTab.serviceRequests;
                  _targetTicketId = '';
                }),
              ),
              NavItem(
                icon: Icons.analytics_outlined,
                label: 'Report',
                isActive: _activeTab == TechnicianTab.reports,
                onTap: () => setState(() => _activeTab = TechnicianTab.reports),
              ),
            ],
          ),
          Expanded(
            child: _buildBody(),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    switch (_activeTab) {
      case TechnicianTab.dashboard:
        return TechnicianDashboardView(
          profile: _profile,
          onOpenQueue: () => setState(() => _activeTab = TechnicianTab.serviceRequests),
          onViewTicket: (id) => setState(() {
            _activeTab = TechnicianTab.serviceRequests;
            _targetTicketId = id;
          }),
        );
      case TechnicianTab.serviceRequests:
        return TechnicianServiceRequestsView(
          tickets: _tickets,
          initialTicketId: _targetTicketId,
          onStatusUpdate: (id, status) {
            setState(() {
              final index = _tickets.indexWhere((t) => t.ticketId == id);
              if (index != -1) {
                _tickets[index] = _tickets[index].copyWith(status: status);
              }
            });
          },
          onSupportModeChange: (id, mode) {
            setState(() {
              final index = _tickets.indexWhere((t) => t.ticketId == id);
              if (index != -1) {
                _tickets[index] = _tickets[index].copyWith(supportMode: mode);
              }
            });
          },
        );
      case TechnicianTab.reports:
        return TechnicianReportsView(reportData: _reportData, history: _history);
    }
  }
}
