import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/token_manager.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final TokenManager tokenManager;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.tokenManager,
  });

  @override
  Future<Either<Failure, String>> sendOtp(String phone) async {
    try {
      final message = await remoteDataSource.sendOtp(phone);
      return Right(message);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> verifyOtp(String phone, String otp) async {
    try {
      final result = await remoteDataSource.verifyOtp(phone, otp);
      if (result['token'] != null) {
        await tokenManager.saveToken(result['token']);
      }
      if (result['user'] != null) {
        if (result['user']['role'] != null) {
          await tokenManager.saveRole(result['user']['role']);
        }
        if (result['user']['isProfileComplete'] != null) {
          await tokenManager.saveProfileComplete(result['user']['isProfileComplete']);
        }
      }
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> profileSetup({
    required String name,
    required String email,
    required String role,
    String? address,
  }) async {
    try {
      final result = await remoteDataSource.profileSetup(
        name: name,
        email: email,
        role: role,
        address: address,
      );
      if (result['user'] != null) {
        if (result['user']['role'] != null) {
          await tokenManager.saveRole(result['user']['role']);
        }
        if (result['user']['isProfileComplete'] != null) {
          await tokenManager.saveProfileComplete(result['user']['isProfileComplete']);
        }
      }
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
