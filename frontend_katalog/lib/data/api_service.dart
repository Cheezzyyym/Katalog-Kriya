import 'dart:convert';
import 'package:http/http.dart' as http;
import 'models/category.dart';
import 'models/product.dart';

class ApiService {
  final String baseUrl = 'http://10.160.196.251:8000/api';

  // --- AUTH ---
  Future<String?> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      body: {'email': email, 'password': password},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['token'];
    } else {
      throw Exception('Email atau password salah');
    }
  }

  // --- KATEGORI ---
  Future<List<Category>> getCategories(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/categories'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      return data.map((json) => Category.fromJson(json)).toList();
    } else {
      throw Exception('Gagal mengambil data kategori');
    }
  }

  // --- BACA PRODUK ---
  Future<List<Product>> getProducts(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/products'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      return data.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Gagal mengambil data produk');
    }
  }

  // --- TAMBAH PRODUK ---
  Future<void> createProduct(String token, Map<String, dynamic> productData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/products'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
      body: productData, 
    );

    if (response.statusCode != 201) {
      throw Exception('Gagal menambahkan produk');
    }
  }

  // --- HAPUS PRODUK ---
  Future<void> deleteProduct(String token, int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/products/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Gagal menghapus produk');
    }
  }

  // --- UBAH PRODUK ---
  Future<void> updateProduct(String token, int id, Map<String, dynamic> productData) async {
    final response = await http.put(
      Uri.parse('$baseUrl/products/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
      body: productData,
    );

    if (response.statusCode != 200) {
      throw Exception('Gagal mengubah data produk');
    }
  }
} 