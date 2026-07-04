import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/api_service.dart';
import '../../data/storage_service.dart';
import 'product_event.dart';
import 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ApiService apiService;
  final StorageService storageService;

  ProductBloc({required this.apiService, required this.storageService}) : super(ProductInitial()) {
    
    // Logika mengambil data
    on<FetchProducts>((event, emit) async {
      emit(ProductLoading());
      try {
        final token = await storageService.getToken();
        if (token == null) throw Exception('Token tidak ditemukan, silakan login ulang.');

        final products = await apiService.getProducts(token);
        
        emit(ProductLoaded(products));
      } catch (e) {
        emit(ProductError(e.toString()));
      }
    });

    // Logika menambah data
    on<AddProduct>((event, emit) async {
      emit(ProductLoading());
      try {
        final token = await storageService.getToken();
        if (token == null) throw Exception('Token hilang, silakan login ulang.');

        await apiService.createProduct(token, event.productData);
        
        final products = await apiService.getProducts(token);
        emit(ProductLoaded(products));
      } catch (e) {
        emit(ProductError(e.toString()));
      }
    });

    // Logika menghapus data (belum diisi)
    // 3. Logika saat Event DeleteProduct dipanggil (Menghapus Data)
    on<DeleteProduct>((event, emit) async {
      try {
        final token = await storageService.getToken();
        if (token == null) throw Exception('Token hilang, silakan login ulang.');

        // Panggil API untuk hapus data berdasarkan ID
        await apiService.deleteProduct(token, event.id);
        
        // Ambil ulang daftar produk terbaru setelah data berhasil dihapus
        final products = await apiService.getProducts(token);
        emit(ProductLoaded(products));
      } catch (e) {
        emit(ProductError(e.toString()));
      }
    });
    // 4. Logika saat Event UpdateProduct dipanggil (Mengubah Data)
    on<UpdateProduct>((event, emit) async {
      emit(ProductLoading());
      try {
        final token = await storageService.getToken();
        if (token == null) throw Exception('Token hilang, silakan login ulang.');

        // Panggil API untuk update data berdasarkan ID
        await apiService.updateProduct(token, event.id, event.productData);
        
        // Ambil ulang data produk terbaru dari database setelah berhasil di-update
        final products = await apiService.getProducts(token);
        emit(ProductLoaded(products));
      } catch (e) {
        emit(ProductError(e.toString()));
      }
    });
  }
}