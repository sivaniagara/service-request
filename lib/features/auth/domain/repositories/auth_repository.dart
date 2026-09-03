import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';

abstract class AuthRepository {
  Future<Either<Failure, String>> sendOtp(String phone);
  Future<Either<Failure, Map<String, dynamic>>> verifyOtp(String phone, String otp);
  Future<Either<Failure, Map<String, dynamic>>> profileSetup({
    required String name,
    required String email,
    required String role,
    String? address,
  });
}
