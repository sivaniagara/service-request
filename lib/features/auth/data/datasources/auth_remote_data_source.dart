import '../../../../core/network/http_service.dart';
import '../../../../core/error/exceptions.dart';

abstract class AuthRemoteDataSource {
  Future<String> sendOtp(String phone);
  Future<Map<String, dynamic>> verifyOtp(String phone, String otp);
  Future<Map<String, dynamic>> profileSetup({
    required String name,
    required String email,
    required String role,
    String? address,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final HttpService httpService;

  AuthRemoteDataSourceImpl({required this.httpService});

  @override
  Future<String> sendOtp(String phone) async {
    final data = await httpService.post(
      "/api/auth/send-otp",
      body: {"phone": phone},
    );
    return data['message'] ?? 'OTP sent successfully';
  }

  @override
  Future<Map<String, dynamic>> verifyOtp(String phone, String otp) async {
    return await httpService.post(
      "/api/auth/verify-otp",
      body: {"phone": phone, "otp": otp},
    );
  }

  @override
  Future<Map<String, dynamic>> profileSetup({
    required String name,
    required String email,
    required String role,
    String? address,
  }) async {
    return await httpService.post(
      "/api/auth/profile-setup",
      body: {
        "name": name,
        "email": email,
        "role": role,
        "address": address ?? "",
      },
    );
  }
}
