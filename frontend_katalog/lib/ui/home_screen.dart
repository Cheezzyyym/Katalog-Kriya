import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_event.dart';
import '../blocs/product/product_blok.dart';
import '../blocs/product/product_event.dart';
import '../blocs/product/product_state.dart';
import 'add_product_screen.dart';
import 'edit_product_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProductBloc>().add(FetchProducts());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // Warna latar belakang abu-abu sangat muda
      appBar: AppBar(
        title: const Text(
          'Katalog Kriya',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black87),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: Colors.redAccent),
            tooltip: 'Keluar',
            onPressed: () {
              context.read<AuthBloc>().add(LoggedOut());
            },
          )
        ],
      ),
      
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is ProductLoading || state is ProductInitial) {
            return const Center(child: CircularProgressIndicator(color: Colors.brown));
          } 
          else if (state is ProductError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Terjadi kesalahan:\n${state.message}', textAlign: TextAlign.center),
                ],
              )
            );
          } 
          else if (state is ProductLoaded) {
            final products = state.products;

            if (products.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    const Text('Belum ada produk kriya.', style: TextStyle(fontSize: 16, color: Colors.grey)),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16), // Sudut kartu lebih melengkung
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Baris 1: Nama Produk & Label Kategori
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                product.name,
                                style: const TextStyle(
                                  fontSize: 18, 
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.brown.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                product.category?.name ?? "-",
                                style: const TextStyle(
                                  fontSize: 12, 
                                  color: Colors.brown,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        
                        // Baris 2: Harga & Stok
                        Row(
                          children: [
                            const Icon(Icons.sell_outlined, size: 16, color: Colors.green),
                            const SizedBox(width: 4),
                            Text(
                              'Rp ${product.price}',
                              style: const TextStyle(
                                fontSize: 16, 
                                color: Colors.green, 
                                fontWeight: FontWeight.bold
                              ),
                            ),
                            const Spacer(),
                            const Icon(Icons.inventory_2_outlined, size: 16, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text(
                              'Stok: ${product.stock}',
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                          ],
                        ),
                        
                        // Garis pemisah tipis
                        const Divider(height: 24, thickness: 1),
                        
                        // Baris 3: Tombol Aksi
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            OutlinedButton.icon(
                              icon: const Icon(Icons.edit, size: 16),
                              label: const Text('Edit'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.blue,
                                side: const BorderSide(color: Colors.blue),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => EditProductScreen(product: product)),
                                );
                              },
                            ),
                            const SizedBox(width: 12),
                            ElevatedButton.icon(
                              icon: const Icon(Icons.delete_outline, size: 16),
                              label: const Text('Hapus'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red[50],
                                foregroundColor: Colors.red,
                                elevation: 0,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                      title: const Text('Hapus Produk'),
                                      content: Text('Yakin ingin menghapus ${product.name}?'),
                                      actions: [
                                        TextButton(
                                          child: const Text('Batal', style: TextStyle(color: Colors.grey)),
                                          onPressed: () => Navigator.pop(context),
                                        ),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                          child: const Text('Hapus', style: TextStyle(color: Colors.white)),
                                          onPressed: () {
                                            context.read<ProductBloc>().add(DeleteProduct(product.id));
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
          
          return const Center(child: Text('Tidak ada data'));
        },
      ),
      
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.brown,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Produk', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddProductScreen()),
          );
        },
      ),
    );
  }
}