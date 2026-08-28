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
}
