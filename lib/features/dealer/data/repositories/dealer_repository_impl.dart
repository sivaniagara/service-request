import '../datasources/dealer_remote_data_source.dart';
import '../models/dealer_dashboard_model.dart';
import '../models/dealer_ticket_model.dart';
import '../models/dealer_technician_model.dart';
import '../models/sub_dealer_model.dart';

abstract class DealerRepository {
  Future<DealerDashboardData> getDealerDashboard();
  Future<List<DealerTicket>> getDealerTickets();
  Future<DealerTicketDetail> getDealerTicketDetail(String ticketId);
  Future<List<DealerTechnician>> getTechnicians();
  Future<DealerServiceTeamModel> getServiceTeam();
  Future<SubDealerManagementData> getSubDealers();
  Future<void> addSubDealer(Map<String, dynamic> data);
  Future<void> addTechnician(Map<String, dynamic> data);
  Future<void> assignTechnicians(String ticketId, List<String> technicianIds, String notes);
}

class DealerRepositoryImpl implements DealerRepository {
  final DealerRemoteDataSource remoteDataSource;

  DealerRepositoryImpl({required this.remoteDataSource});

  @override
  Future<DealerDashboardData> getDealerDashboard() async {
    return await remoteDataSource.getDealerDashboard();
  }

  @override
  Future<List<DealerTicket>> getDealerTickets() async {
    return await remoteDataSource.getDealerTickets();
  }

  @override
  Future<DealerTicketDetail> getDealerTicketDetail(String ticketId) async {
    return await remoteDataSource.getDealerTicketDetail(ticketId);
  }

  @override
  Future<List<DealerTechnician>> getTechnicians() async {
    return await remoteDataSource.getTechnicians();
  }

  @override
  Future<DealerServiceTeamModel> getServiceTeam() async {
    return await remoteDataSource.getServiceTeam();
  }

  @override
  Future<SubDealerManagementData> getSubDealers() async {
    return await remoteDataSource.getSubDealers();
  }

  @override
  Future<void> addSubDealer(Map<String, dynamic> data) async {
    await remoteDataSource.addSubDealer(data);
  }

  @override
  Future<void> addTechnician(Map<String, dynamic> data) async {
    await remoteDataSource.addTechnician(data);
  }

  @override
  Future<void> assignTechnicians(String ticketId, List<String> technicianIds, String notes) async {
    await remoteDataSource.assignTechnicians(ticketId, technicianIds, notes);
  }
}
