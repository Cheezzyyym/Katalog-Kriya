import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}
class AuthLoading extends AuthState {}

// State jika user berhasil login
class Authenticated extends AuthState {
  final String token;
  const Authenticated({required this.token});

  @override
  List<Object> get props => [token];
}

// State jika user belum login atau sudah logout
class Unauthenticated extends AuthState {}

// State jika login gagal (error)
class AuthFailure extends AuthState {
  final String error;
  const AuthFailure({required this.error});

  @override
  List<Object> get props => [error];
}