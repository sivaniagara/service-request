import '../datasources/technician_remote_data_source.dart';
import '../models/technician_dashboard_model.dart';
import '../models/technician_ticket_model.dart';
import '../models/technician_report_model.dart';

abstract class TechnicianRepository {
  Future<TechnicianDashboardData> getTechnicianDashboard();
  Future<List<TechnicianTicket>> getTechnicianTickets();
  Future<TechnicianTicketDetail> getTechnicianTicketDetail(String ticketId);
  Future<TechnicianReportData> getTechnicianReports();
  Future<List<TechnicianHistoryItem>> getTechnicianHistory();
  Future<void> updateSupportMode(String ticketId, String supportMode);
  Future<Map<String, dynamic>> completeTechnicianTask(String ticketId, String notes);
}

class TechnicianRepositoryImpl implements TechnicianRepository {
  final TechnicianRemoteDataSource remoteDataSource;

  TechnicianRepositoryImpl({required this.remoteDataSource});

  @override
  Future<TechnicianDashboardData> getTechnicianDashboard() async {
    return await remoteDataSource.getTechnicianDashboard();
  }

  @override
  Future<List<TechnicianTicket>> getTechnicianTickets() async {
    return await remoteDataSource.getTechnicianTickets();
  }

  @override
  Future<TechnicianTicketDetail> getTechnicianTicketDetail(String ticketId) async {
    return await remoteDataSource.getTechnicianTicketDetail(ticketId);
  }

  @override
  Future<TechnicianReportData> getTechnicianReports() async {
    return await remoteDataSource.getTechnicianReports();
  }

  @override
  Future<List<TechnicianHistoryItem>> getTechnicianHistory() async {
    return await remoteDataSource.getTechnicianHistory();
  }

  @override
  Future<void> updateSupportMode(String ticketId, String supportMode) async {
    await remoteDataSource.updateSupportMode(ticketId, supportMode);
  }

  @override
  Future<Map<String, dynamic>> completeTechnicianTask(String ticketId, String notes) async {
    return await remoteDataSource.completeTechnicianTask(ticketId, notes);
  }
}
