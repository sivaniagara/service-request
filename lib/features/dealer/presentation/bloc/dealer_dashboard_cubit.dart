import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/dealer_repository_impl.dart';
import 'dealer_dashboard_state.dart';

class DealerDashboardCubit extends Cubit<DealerDashboardState> {
  final DealerRepository repository;

  DealerDashboardCubit({required this.repository}) : super(DealerDashboardState());

  Future<void> loadDashboard() async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final data = await repository.getDealerDashboard();
      emit(state.copyWith(isLoading: false, dashboardData: data));
    } catch (e) {
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
    } else if (tab == DealerDashboardTab.team && state.technicians == null) {
      loadTechnicians();
    }
  }
}
