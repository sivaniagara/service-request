import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../datasources/dashboard_remote_data_source.dart';
import '../models/complaint_models.dart';
import '../models/dashboard_models.dart';

abstract class DashboardRepository {
  Future<Either<Failure, CustomerDashboardData>> getCustomerDashboard();
  Future<Either<Failure, List<ServiceTicket>>> getTickets(String status);
  Future<Either<Failure, ServiceTicketDetail>> getTicketDetail(String ticketId);
  Future<Either<Failure, CustomerReport>> getReport(String timeframe);
  Future<Either<Failure, RaiseComplaintResponse>> raiseTicket(RaiseComplaintRequest request);
}

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardRemoteDataSource remoteDataSource;

  DashboardRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, CustomerDashboardData>> getCustomerDashboard() async {
    try {
      final data = await remoteDataSource.getCustomerDashboard();
      return Right(data);
    } catch (e, stackTrace) {
      print("stackTrace : $stackTrace");
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ServiceTicket>>> getTickets(String status) async {
    try {
      final data = await remoteDataSource.getTickets(status);
      return Right(data);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ServiceTicketDetail>> getTicketDetail(String ticketId) async {
    try {
      final data = await remoteDataSource.getTicketDetail(ticketId);
      return Right(data);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, CustomerReport>> getReport(String timeframe) async {
    try {
      final data = await remoteDataSource.getReport(timeframe);
      return Right(data);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, RaiseComplaintResponse>> raiseTicket(RaiseComplaintRequest request) async {
    try {
      final data = await remoteDataSource.raiseTicket(request);
      return Right(data);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
