import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/technician_repository.dart';
import 'technician_dashboard_state.dart';

class TechnicianDashboardCubit extends Cubit<TechnicianDashboardState> {
  final TechnicianRepository repository;

  TechnicianDashboardCubit({required this.repository})
      : super(const TechnicianDashboardState());

  Future<void> loadDashboard() async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final data = await repository.getTechnicianDashboard();
      emit(state.copyWith(isLoading: false, dashboardData: data));
    } catch (e, stackTrace) {
      debugPrint("loadDashboard error: $e");
      debugPrint("loadDashboard stackTrace: $stackTrace");
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> loadTickets() async {
    emit(state.copyWith(isTicketsLoading: true, error: null));
    try {
      final tickets = await repository.getTechnicianTickets();
      emit(state.copyWith(isTicketsLoading: false, tickets: tickets));
      // Only load first ticket detail if no ticket is currently selected
      if (tickets.isNotEmpty && state.selectedTicketDetail == null) {
        loadTicketDetail(tickets.first.ticketId);
      }
    } catch (e, stackTrace) {
      debugPrint("loadTickets error: $e");
      debugPrint("loadTickets stackTrace: $stackTrace");
      emit(state.copyWith(isTicketsLoading: false, error: e.toString()));
    }
  }

  Future<void> loadTicketDetail(String ticketId) async {
    // Only set loading if we are switching to a DIFFERENT ticket
    final isNewTicket = state.selectedTicketDetail == null || state.selectedTicketDetail!.ticketId != ticketId;
    if (isNewTicket) {
      emit(state.copyWith(isDetailLoading: true, error: null));
    }
    
    try {
      final detail = await repository.getTechnicianTicketDetail(ticketId);
      emit(state.copyWith(isDetailLoading: false, selectedTicketDetail: detail));
    } catch (e, stackTrace) {
      debugPrint("loadTicketDetail error: $e");
      debugPrint("loadTicketDetail stackTrace: $stackTrace");
      emit(state.copyWith(isDetailLoading: false, error: e.toString()));
    }
  }

  Future<void> loadReports() async {
    emit(state.copyWith(isReportLoading: true, error: null));
    try {
      final reportData = await repository.getTechnicianReports();
      final history = await repository.getTechnicianHistory();
      emit(state.copyWith(
        isReportLoading: false,
        reportData: reportData,
        history: history,
      ));
    } catch (e, stackTrace) {
      debugPrint("loadReports error: $e");
      debugPrint("loadReports stackTrace: $stackTrace");
      emit(state.copyWith(isReportLoading: false, error: e.toString()));
    }
  }

  Future<bool> updateSupportMode(String ticketId, String supportMode) async {
    emit(state.copyWith(isDetailLoading: true, error: null));
    try {
      await repository.updateSupportMode(ticketId, supportMode);
      // Refresh all relevant data
      await Future.wait([
        loadTicketDetail(ticketId),
        loadTickets(),
        loadDashboard(),
      ]);
      return true;
    } catch (e) {
      debugPrint("updateSupportMode error: $e");
      emit(state.copyWith(isDetailLoading: false, error: e.toString()));
      return false;
    }
  }

  Future<Map<String, dynamic>?> completeTechnicianTask(String ticketId, String notes) async {
    debugPrint("completeTechnicianTask...");
    emit(state.copyWith(isSubmitting: true, error: null));
    try {
      final response = await repository.completeTechnicianTask(ticketId, notes);
      // Refresh all relevant data
      await Future.wait([
        loadTicketDetail(ticketId),
        loadTickets(),
        loadDashboard(),
      ]);
      emit(state.copyWith(isSubmitting: false));
      return response;
    } catch (e) {
      debugPrint("completeTechnicianTask error: $e");
      emit(state.copyWith(isSubmitting: false, error: e.toString()));
      return null;
    }
  }

  void changeTab(TechnicianDashboardTab tab) {
    emit(state.copyWith(activeTab: tab));
    if (tab == TechnicianDashboardTab.dashboard && state.dashboardData == null) {
      loadDashboard();
    } else if (tab == TechnicianDashboardTab.serviceRequests &&
        state.tickets == null) {
      loadTickets();
    } else if (tab == TechnicianDashboardTab.reports &&
        state.reportData == null) {
      loadReports();
    }
  }
}
