import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/admin_dealer_model.dart';
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
      
      // Update the global dealer list by merging ticket-specific list with management list
      final mergedList = _mergeDealers(model.dealerList, state.dealers?.data);

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
      
      // Update the global dealer list for assignment consistency
      final mergedList = _mergeDealers(state.dealerList ?? [], model.data);
      
      emit(state.copyWith(
        isLoading: false, 
        dealers: model,
        dealerList: mergedList,
      ));
    } catch (e, stackTrace) {
      debugPrint("loadDealers error: $e");
      debugPrint("loadDealers : $stackTrace");
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  /// Synchronizes two dealer data sources (Assignment List and Management List)
  /// to ensure UI reflects newly added dealers immediately.
  List<AdminDealerListItem> _mergeDealers(
    List<AdminDealerListItem> currentList,
    List<DealerData>? freshData,
  ) {
    List<AdminDealerListItem> merged = List.from(currentList);
    
    if (freshData != null) {
      for (final dealer in freshData) {
        final index = merged.indexWhere((d) => d.dealerId == dealer.dealerId);
        if (index != -1) {
          // Update existing with fresh management data while preserving tech count if not present
          merged[index] = AdminDealerListItem(
            dealerId: dealer.dealerId,
            dealerCode: dealer.dealerCode,
            name: dealer.name,
            region: dealer.region,
            rating: dealer.performance.rating,
            techniciansCount: merged[index].techniciansCount, phone: dealer.phone,
          );
        } else {
          // Add new dealer
          merged.add(AdminDealerListItem(
            dealerId: dealer.dealerId,
            dealerCode: dealer.dealerCode,
            name: dealer.name,
            region: dealer.region,
            rating: dealer.performance.rating,
            techniciansCount: 0, phone: dealer.phone,
          ));
        }
      }
    }
    return merged;
  }


  Future<void> loadReports({String timeframe = '30D', String? region}) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final summary = await repository.getReportSummary(timeframe: timeframe, region: region);
      final sla = await repository.getSlaCompliance(timeframe: timeframe);
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
      
      // Multi-source refresh: ensure ticket details, dealer capacities, and dashboard metrics stay synced
      await selectTicket(ticketId);
      await loadDealers();
      await loadDashboard();
      
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
