import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/dashboard_repository_impl.dart';
import 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final DashboardRepository repository;

  DashboardCubit({required this.repository}) : super(const DashboardState());

  Future<void> loadDashboard() async {
    emit(state.copyWith(isLoading: true, activeTab: DashboardTab.overview));
    final result = await repository.getCustomerDashboard();
    result.fold(
      (failure) => emit(state.copyWith(isLoading: false, error: failure.message)),
      (data) => emit(state.copyWith(isLoading: false, dashboardData: data)),
    );
  }

  Future<void> changeTab(DashboardTab tab) async {
    emit(state.copyWith(activeTab: tab));
    if (tab == DashboardTab.complaints && state.tickets == null) {
      await loadTickets();
    } else if (tab == DashboardTab.overview && state.dashboardData == null) {
      await loadDashboard();
    } else if (tab == DashboardTab.reports && state.report == null) {
      await loadReport();
    }
  }

  Future<void> loadTickets({String status = 'all'}) async {
    emit(state.copyWith(isLoading: true));
    final result = await repository.getTickets(status);
    result.fold(
      (failure) => emit(state.copyWith(isLoading: false, error: failure.message)),
      (tickets) {
        emit(state.copyWith(isLoading: false, tickets: tickets));
        if (tickets.isNotEmpty && state.selectedTicket == null) {
          selectTicket(tickets.first.ticketId);
        }
      },
    );
  }

  Future<void> selectTicket(String ticketId) async {
    emit(state.copyWith(isLoading: true));
    final result = await repository.getTicketDetail(ticketId);
    result.fold(
      (failure) => emit(state.copyWith(isLoading: false, error: failure.message)),
      (detail) => emit(state.copyWith(isLoading: false, selectedTicket: detail)),
    );
  }

  Future<void> loadReport({String timeframe = 'this_year'}) async {
    emit(state.copyWith(isLoading: true));
    final result = await repository.getReport(timeframe);
    result.fold(
      (failure) => emit(state.copyWith(isLoading: false, error: failure.message)),
      (report) => emit(state.copyWith(isLoading: false, report: report)),
    );
  }
}
