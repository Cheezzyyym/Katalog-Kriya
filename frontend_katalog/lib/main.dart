import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Import Auth
import 'blocs/auth/auth_bloc.dart';
import 'blocs/auth/auth_event.dart';
import 'blocs/auth/auth_state.dart';

// Import Product (Baru ditambahkan)
import 'blocs/product/product_blok.dart';
import 'data/api_service.dart';
import 'data/storage_service.dart';
import 'ui/login_screen.dart';
import 'ui/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          // Inisialisasi AuthBloc dan langsung jalankan event AppStarted
          create: (context) => AuthBloc(
            apiService: ApiService(),
            storageService: StorageService(),
          )..add(AppStarted()),
        ),

        // Inisialisasi ProductBloc agar bisa dipakai di HomeScreen
        BlocProvider<ProductBloc>(
          create: (context) => ProductBloc(
            apiService: ApiService(),
            storageService: StorageService(),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Katalog Kriya',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const AppNavigator(), // Komponen penentu arah navigasi
      ),
    );
  }
}

// AppNavigator bertugas mengecek State dari AuthBloc
class AppNavigator extends StatelessWidget {
  const AppNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthInitial || state is AuthLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (state is Authenticated) {
          return const HomeScreen(); // Jika token ada, masuk Beranda
        }
        return const LoginScreen(); // Jika belum punya token, masuk halaman Login
      },
    );
  }
}
