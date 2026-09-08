import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/admin_ticket_model.dart';
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
    } catch (e, stackTrace) {
      debugPrint("loadDashboard error: $e");
      debugPrint("loadDashboard : $stackTrace");
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> loadTickets() async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final model = await repository.getAdminTickets();
      
      // Safety Merge: If we have dealers from the management API, ensure they are in the assignment list
      List<AdminDealerListItem> mergedList = List.from(model.dealerList);
      if (state.dealers != null) {
        for (final dealerData in state.dealers!.data) {
          final exists = mergedList.any((d) => d.dealerId == dealerData.dealerId);
          if (!exists) {
            mergedList.add(AdminDealerListItem(
              dealerId: dealerData.dealerId,
              dealerCode: dealerData.dealerCode,
              name: dealerData.name,
              region: dealerData.region,
              rating: dealerData.performance.rating,
              techniciansCount: 0, // Default for newly added dealers until synced
            ));
          }
        }
      }

      emit(state.copyWith(
        isLoading: false,
        tickets: model.data,
        dealerList: mergedList,
      ));
      if (model.data.isNotEmpty && state.selectedTicket == null) {
        selectTicket(model.data.first.ticketId);
      }
    } catch (e, stackTrace) {
      debugPrint("loadTickets error: $e");
      debugPrint("loadTickets : $stackTrace");
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
      } catch (e, stackTrace) {
        debugPrint("selectTicket error: $e");
        debugPrint("selectTicket : $stackTrace");
        emit(state.copyWith(isDetailLoading: false, error: e.toString()));
      }
    }
  }

  Future<void> loadDealers() async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final model = await repository.getAdminDealers();
      emit(state.copyWith(isLoading: false, dealers: model));
    } catch (e, stackTrace) {
      debugPrint("loadDealers error: $e");
      debugPrint("loadDealers : $stackTrace");
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

  Future<void> addDealer(Map<String, dynamic> data) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      await repository.addDealer(data);
      
      // Force refresh all relevant data sources to ensure consistency
      await loadDashboard();
      await loadDealers();
      await loadTickets();
      
      emit(state.copyWith(isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
      rethrow;
    }
  }

  Future<void> assignDealer(String ticketId, List<String> dealerIds, String instructions) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      await repository.assignDealer(ticketId, dealerIds, instructions);
      await selectTicket(ticketId); // Refresh ticket details
      emit(state.copyWith(isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
      rethrow;
    }
  }

  Future<void> verifyCompletion(String ticketId, String notes) async {
    emit(state.copyWith(isVerifyingCompletion: true, error: null, verifyCompletionSuccess: null));
    try {
      await repository.verifyCompletion(ticketId, notes);
      await selectTicket(ticketId); // Refresh ticket details to see updated milestone
      emit(state.copyWith(isVerifyingCompletion: false, verifyCompletionSuccess: true));
    } catch (e) {
      emit(state.copyWith(isVerifyingCompletion: false, verifyCompletionSuccess: false, error: e.toString()));
    }
  }

  Future<void> sendCloseOtp(String ticketId) async {
    emit(state.copyWith(isSendingOtp: true, error: null, otpSentSuccess: null));
    try {
      await repository.sendCloseOtp(ticketId);
      emit(state.copyWith(isSendingOtp: false, otpSentSuccess: true));
    } catch (e) {
      emit(state.copyWith(isSendingOtp: false, otpSentSuccess: false, error: e.toString()));
    }
  }

  Future<void> verifyCloseOtp(String ticketId, String otp) async {
    emit(state.copyWith(isClosingTicket: true, error: null, closeTicketSuccess: null));
    try {
      await repository.verifyCloseOtp(ticketId, otp);
      await selectTicket(ticketId); // Refresh to see "Closed" status
      emit(state.copyWith(isClosingTicket: false, closeTicketSuccess: true));
    } catch (e) {
      emit(state.copyWith(isClosingTicket: false, closeTicketSuccess: false, error: e.toString()));
    }
  }
}
