import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/dealer_repository_impl.dart';
import '../../data/models/dealer_report_model.dart';
import '../../data/models/sub_dealer_model.dart';
import 'dealer_dashboard_state.dart';

class DealerDashboardCubit extends Cubit<DealerDashboardState> {
  final DealerRepository repository;

  DealerDashboardCubit({required this.repository}) : super(DealerDashboardState());

  Future<void> loadDashboard() async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final data = await repository.getDealerDashboard();
      emit(state.copyWith(isLoading: false, dashboardData: data));
    } catch (e, stackTrace) {
      debugPrint("loadDashboard error: $e");
      debugPrint("loadDashboard : $stackTrace");
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> loadTickets() async {
    emit(state.copyWith(isTicketsLoading: true, error: null));
    try {
      final tickets = await repository.getDealerTickets();
      emit(state.copyWith(
        isTicketsLoading: false,
        tickets: tickets,
        selectedTicket: tickets.isNotEmpty ? tickets.first : null,
      ));
      if (tickets.isNotEmpty) {
        loadTicketDetail(tickets.first.ticketId);
      }
    } catch (e) {
      emit(state.copyWith(isTicketsLoading: false, error: e.toString()));
    }
  }

  Future<void> loadTicketDetail(String ticketId) async {
    emit(state.copyWith(isDetailLoading: true, error: null));
    try {
      final detail = await repository.getDealerTicketDetail(ticketId);
      emit(state.copyWith(isDetailLoading: false, selectedTicketDetail: detail));
    } catch (e) {
      emit(state.copyWith(isDetailLoading: false, error: e.toString()));
    }
  }

  Future<void> loadTechnicians() async {
    emit(state.copyWith(isTechniciansLoading: true, error: null));
    try {
      final technicians = await repository.getTechnicians();
      emit(state.copyWith(isTechniciansLoading: false, technicians: technicians));
    } catch (e) {
      emit(state.copyWith(isTechniciansLoading: false, error: e.toString()));
    }
  }

  Future<void> loadServiceTeam() async {
    emit(state.copyWith(isTechniciansLoading: true, error: null));
    try {
      final data = await repository.getServiceTeam();
      emit(state.copyWith(
        isTechniciansLoading: false,
        serviceTeamData: data,
        technicians: data.technicians,
      ));
    } catch (e) {
      emit(state.copyWith(isTechniciansLoading: false, error: e.toString()));
      rethrow;
    }
  }

  Future<void> loadPerformanceReport() async {
    emit(state.copyWith(isReportLoading: true, error: null));
    try {
      // Using dummy data as backend is not ready
      await Future.delayed(const Duration(milliseconds: 500));
      final report = DealerPerformanceReport.fromJson({
        "header": {
          "title": "Dealer Service Request Report: Green Sprout Agro",
          "subtitle": "Requests raised by your customer base and how fast your team resolves them",
          "dealerName": "Green Sprout Agro",
          "selectedTimeframe": "30D",
          "availableTimeframes": ["7D", "30D", "90D", "1Y"]
        },
        "weeklyRequestTrends": {
          "chartTitle": "Weekly Request Trends",
          "dataPoints": [
            {"weekLabel": "Wk1", "count": 14},
            {"weekLabel": "Wk2", "count": 11},
            {"weekLabel": "Wk3", "count": 18},
            {"weekLabel": "Wk4", "count": 16},
            {"weekLabel": "Wk5", "count": 22},
            {"weekLabel": "Wk6", "count": 20},
            {"weekLabel": "Wk7", "count": 25},
            {"weekLabel": "Wk8", "count": 23}
          ]
        },
        "requestsByCategory": {
          "title": "Requests by Category",
          "maxCount": 20,
          "categories": [
            {
              "id": "repair",
              "name": "Repair",
              "subtitle": "Pumps, motors, mechanics",
              "count": 16,
              "colorHex": "#3B82F6"
            },
            {
              "id": "installation",
              "name": "Installation",
              "subtitle": "X200 units, sensors",
              "count": 12,
              "colorHex": "#8B5CF6"
            },
            {
              "id": "maintenance",
              "name": "Maintenance",
              "subtitle": "Filters, fertigation valves",
              "count": 7,
              "colorHex": "#F59E0B"
            },
            {
              "id": "inspection",
              "name": "Inspection",
              "subtitle": "Periodic farm checkups",
              "count": 2,
              "colorHex": "#10B981"
            }
          ]
        },
        "requestStatusBreakdown": {
          "title": "Request Status Breakdown",
          "totalCount": 37,
          "totalLabel": "TOTAL",
          "statuses": [
            {
              "id": "closedVerified",
              "label": "Closed & Verified",
              "count": 31,
              "percentage": 62.0,
              "colorHex": "#10B981"
            },
            {
              "id": "inProgress",
              "label": "In Progress",
              "count": 11,
              "percentage": 22.0,
              "colorHex": "#3B82F6"
            },
            {
              "id": "onHold",
              "label": "On Hold / Needs Tech",
              "count": 8,
              "percentage": 16.0,
              "colorHex": "#F59E0B"
            }
          ]
        }
      });
      emit(state.copyWith(isReportLoading: false, performanceReport: report));
    } catch (e) {
      emit(state.copyWith(isReportLoading: false, error: e.toString()));
    }
  }

  Future<void> loadSubDealers() async {
    emit(state.copyWith(isSubDealersLoading: true, error: null));
    try {
      // Mock data for Sub Dealers
      await Future.delayed(const Duration(milliseconds: 500));
      final List<SubDealer> subDealers = [
        SubDealer(
          id: 'SD-001',
          branchName: 'Salem West Branch',
          location: 'Salem, TN',
          technicianCount: 12,
          rating: 4.8,
          isActive: true,
          createdAt: DateTime.now().subtract(const Duration(days: 120)),
          contactNumber: '+91 98765 43210',
          managerName: 'Rajesh Kumar',
        ),
        SubDealer(
          id: 'SD-002',
          branchName: 'Erode East Hub',
          location: 'Erode, TN',
          technicianCount: 8,
          rating: 4.5,
          isActive: true,
          createdAt: DateTime.now().subtract(const Duration(days: 95)),
          contactNumber: '+91 98765 43211',
          managerName: 'Suresh Raina',
        ),
        SubDealer(
          id: 'SD-003',
          branchName: 'Madurai North Service',
          location: 'Madurai, TN',
          technicianCount: 15,
          rating: 4.2,
          isActive: false,
          createdAt: DateTime.now().subtract(const Duration(days: 200)),
          contactNumber: '+91 98765 43212',
          managerName: 'Vijay Sethu',
        ),
      ];
      emit(state.copyWith(isSubDealersLoading: false, subDealers: subDealers));
    } catch (e) {
      emit(state.copyWith(isSubDealersLoading: false, error: e.toString()));
    }
  }

  Future<void> addSubDealer(SubDealer subDealer) async {
    // In a real app, this would call the repository
    final currentSubDealers = List<SubDealer>.from(state.subDealers ?? []);
    currentSubDealers.add(subDealer);
    emit(state.copyWith(subDealers: currentSubDealers));
  }

  void selectTicket(String ticketId) {
    if (state.tickets != null) {
      final selected = state.tickets!.firstWhere((t) => t.ticketId == ticketId);
      emit(state.copyWith(selectedTicket: selected));
      loadTicketDetail(ticketId);
    }
  }

  void changeTab(DealerDashboardTab tab) {
    emit(state.copyWith(activeTab: tab));
    if (tab == DealerDashboardTab.serviceRequests && state.tickets == null) {
      loadTickets();
    } else if (tab == DealerDashboardTab.dashboard && state.dashboardData == null) {
      loadDashboard();
    } else if (tab == DealerDashboardTab.team && state.serviceTeamData == null) {
      loadServiceTeam();
    } else if (tab == DealerDashboardTab.reports && state.performanceReport == null) {
      loadPerformanceReport();
    } else if (tab == DealerDashboardTab.subDealerManagement && state.subDealers == null) {
      loadSubDealers();
    }
  }

  Future<void> assignTechnician(String ticketId, String technicianId, String notes) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      await repository.assignTechnician(ticketId, technicianId, notes);
      await loadTicketDetail(ticketId); // Refresh details
      emit(state.copyWith(isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
      rethrow;
    }
  }

  Future<void> addTechnician(Map<String, dynamic> data) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      await repository.addTechnician(data);
      await loadServiceTeam(); // Refresh the team list
      emit(state.copyWith(isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
      rethrow;
    }
  }
}
