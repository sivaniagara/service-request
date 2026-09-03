import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthOtpSent extends AuthState {
  final String message;
  const AuthOtpSent(this.message);

  @override
  List<Object?> get props => [message];
}

class AuthVerified extends AuthState {
  final Map<String, dynamic> userData;
  const AuthVerified(this.userData);

  @override
  List<Object?> get props => [userData];
}

class AuthProfileUpdated extends AuthState {
  final Map<String, dynamic> userData;
  const AuthProfileUpdated(this.userData);

  @override
  List<Object?> get props => [userData];
}

class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}
