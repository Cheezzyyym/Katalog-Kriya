import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/api_service.dart';
import '../../data/storage_service.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final ApiService apiService;
  final StorageService storageService;

  AuthBloc({required this.apiService, required this.storageService}) : super(AuthInitial()) {
    
    // Saat aplikasi dibuka: Cek apakah token JWT sudah ada di storage
    on<AppStarted>((event, emit) async {
      final token = await storageService.getToken();
      if (token != null) {
        emit(Authenticated(token: token)); // Jika ada token, langsung masuk
      } else {
        emit(Unauthenticated()); // Jika tidak ada, suruh login
      }
    });

    // Saat tombol login ditekan
    on<LoginPressed>((event, emit) async {
      emit(AuthLoading()); // Tampilkan efek loading
      try {
        final token = await apiService.login(event.email, event.password);
        if (token != null) {
          await storageService.saveToken(token); // Simpan token ke HP
          emit(Authenticated(token: token)); // Login sukses!
        }
      } catch (e) {
        emit(AuthFailure(error: e.toString())); // Login gagal
      }
    });

    // Saat tombol logout ditekan
    on<LoggedOut>((event, emit) async {
      emit(AuthLoading());
      await storageService.deleteToken(); // Hapus token dari HP
      emit(Unauthenticated()); // Kembali ke halaman login
    });
  }
}