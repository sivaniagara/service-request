import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/admin_dashboard_repository_impl.dart';
import 'admin_dashboard_state.dart';

class AdminDashboardCubit extends Cubit<AdminDashboardState> {
  final AdminDashboardRepository repository;

  AdminDashboardCubit(this.repository) : super(AdminDashboardState());

  Future<void> loadDashboard() async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final model = await repository.getDashboardData();
      emit(state.copyWith(isLoading: false, dashboardData: model.data));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> loadTickets() async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final model = await repository.getAdminTickets();
      emit(state.copyWith(
        isLoading: false,
        tickets: model.data,
        dealerList: model.dealerList,
      ));
      if (model.data.isNotEmpty) {
        selectTicket(model.data.first.ticketId);
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> selectTicket(String ticketId) async {
    if (state.tickets != null) {
      final ticket = state.tickets!.firstWhere((t) => t.ticketId == ticketId);
      emit(state.copyWith(selectedTicket: ticket, isDetailLoading: true));
      
      try {
        final detailModel = await repository.getAdminTicketDetail(ticketId);
        emit(state.copyWith(isDetailLoading: false, selectedTicketDetail: detailModel.data));
      } catch (e) {
        emit(state.copyWith(isDetailLoading: false, error: e.toString()));
      }
    }
  }

  Future<void> loadDealers() async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final model = await repository.getAdminDealers();
      emit(state.copyWith(isLoading: false, dealers: model));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> loadReports() async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final summary = await repository.getReportSummary();
      final sla = await repository.getSlaCompliance();
      emit(state.copyWith(
        isLoading: false,
        reportSummary: summary.data,
        slaCompliance: sla.data,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  void changeTab(AdminDashboardTab tab) {
    emit(state.copyWith(activeTab: tab));
    if (tab == AdminDashboardTab.serviceRequests && state.tickets == null) {
      loadTickets();
    } else if (tab == AdminDashboardTab.overview && state.dashboardData == null) {
      loadDashboard();
    } else if (tab == AdminDashboardTab.dealerManagement && state.dealers == null) {
      loadDealers();
    } else if (tab == AdminDashboardTab.reports && state.reportSummary == null) {
      loadReports();
    }
  }
}
