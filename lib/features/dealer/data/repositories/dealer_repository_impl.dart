import '../datasources/dealer_remote_data_source.dart';
import '../models/dealer_dashboard_model.dart';
import '../models/dealer_ticket_model.dart';
import '../models/dealer_technician_model.dart';

abstract class DealerRepository {
  Future<DealerDashboardData> getDealerDashboard();
  Future<List<DealerTicket>> getDealerTickets();
  Future<DealerTicketDetail> getDealerTicketDetail(String ticketId);
  Future<List<DealerTechnician>> getTechnicians();
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
}
