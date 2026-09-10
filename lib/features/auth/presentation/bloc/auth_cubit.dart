import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/auth_repository.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository repository;

  AuthCubit({required this.repository}) : super(AuthInitial());

  Future<void> sendOtp(String phone) async {
    emit(AuthLoading());
    final result = await repository.sendOtp(phone);
    result.fold(
      (failure) {
        debugPrint('AuthCubit sendOtp Error: ${failure.message}');
        emit(AuthError(failure.message));
      },
      (message) => emit(AuthOtpSent(message)),
    );
  }

  Future<void> verifyOtp(String phone, String otp) async {
    emit(AuthLoading());
    final result = await repository.verifyOtp(phone, otp);
    result.fold(
      (failure) {
        debugPrint('AuthCubit verifyOtp Error: ${failure.message}');
        emit(AuthError(failure.message));
      },
      (data) => emit(AuthVerified(data)),
    );
  }

  Future<void> profileSetup({
    required String name,
    required String email,
    required String role,
    String? address,
  }) async {
    emit(AuthLoading());
    final result = await repository.profileSetup(
      name: name,
      email: email,
      role: role,
      address: address,
    );
    result.fold(
      (failure) {
        debugPrint('AuthCubit profileSetup Error: ${failure.message}');
        emit(AuthError(failure.message));
      },
      (data) => emit(AuthProfileUpdated(data)),
    );
  }
}
