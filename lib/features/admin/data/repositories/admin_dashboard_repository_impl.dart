import '../datasources/admin_remote_data_source.dart';
import '../models/admin_dashboard_model.dart';
import '../models/admin_ticket_model.dart';
import '../models/admin_ticket_detail_model.dart';
import '../models/admin_dealer_model.dart';
import '../models/admin_report_models.dart';

abstract class AdminDashboardRepository {
  Future<AdminDashboardModel> getDashboardData();
  Future<AdminTicketModel> getAdminTickets();
  Future<AdminTicketDetailModel> getAdminTicketDetail(String ticketId);
  Future<AdminDealerModel> getAdminDealers();
  Future<AdminReportSummaryModel> getReportSummary();
  Future<AdminSlaComplianceModel> getSlaCompliance();
  Future<void> addDealer(Map<String, dynamic> data);
  Future<void> assignDealer(String ticketId, List<String> dealerIds, String instructions);
  Future<void> verifyCompletion(String ticketId, String notes);
  Future<void> sendCloseOtp(String ticketId);
  Future<void> verifyCloseOtp(String ticketId, String otp);
}

class AdminDashboardRepositoryImpl implements AdminDashboardRepository {
  final AdminRemoteDataSource remoteDataSource;

  AdminDashboardRepositoryImpl({required this.remoteDataSource});

  @override
  Future<AdminDashboardModel> getDashboardData() async {
    return await remoteDataSource.getDashboardData();
  }

  @override
  Future<AdminTicketModel> getAdminTickets() async {
    return await remoteDataSource.getAdminTickets();
  }

  @override
  Future<AdminTicketDetailModel> getAdminTicketDetail(String ticketId) async {
    return await remoteDataSource.getAdminTicketDetail(ticketId);
  }

  @override
  Future<AdminDealerModel> getAdminDealers() async {
    return await remoteDataSource.getAdminDealers();
  }

  @override
  Future<AdminReportSummaryModel> getReportSummary() async {
    return await remoteDataSource.getReportSummary();
  }

  @override
  Future<AdminSlaComplianceModel> getSlaCompliance() async {
    return await remoteDataSource.getSlaCompliance();
  }

  @override
  Future<void> addDealer(Map<String, dynamic> data) async {
    await remoteDataSource.addDealer(data);
  }

  @override
  Future<void> assignDealer(String ticketId, List<String> dealerIds, String instructions) async {
    await remoteDataSource.assignDealer(ticketId, dealerIds, instructions);
  }

  @override
  Future<void> verifyCompletion(String ticketId, String notes) async {
    await remoteDataSource.verifyCompletion(ticketId, notes);
  }

  @override
  Future<void> sendCloseOtp(String ticketId) async {
    await remoteDataSource.sendCloseOtp(ticketId);
  }

  @override
  Future<void> verifyCloseOtp(String ticketId, String otp) async {
    await remoteDataSource.verifyCloseOtp(ticketId, otp);
  }
}
