import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/product/product_blok.dart';
import '../blocs/product/product_event.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController();
  final _descController = TextEditingController();
  
  // Nilai default kategori (1 = Anyaman, 2 = Tekstil yang tadi dibuat di Tinker)
  int _selectedCategoryId = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Produk Kriya')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<int>(
                initialValue: _selectedCategoryId,
                decoration: const InputDecoration(labelText: 'Kategori Kriya'),
                items: const [
                  DropdownMenuItem(value: 1, child: Text('Anyaman')),
                  DropdownMenuItem(value: 2, child: Text('Tekstil')),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedCategoryId = value!;
                  });
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nama Produk'),
                validator: (value) => value!.isEmpty ? 'Nama tidak boleh kosong' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Harga (Rp)'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Harga tidak boleh kosong' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _stockController,
                decoration: const InputDecoration(labelText: 'Stok Barang'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Stok tidak boleh kosong' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descController,
                decoration: const InputDecoration(labelText: 'Cerita/Deskripsi Produk (Opsional)'),
                maxLines: 3,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Menyusun data untuk dikirim ke API
                    final productData = {
                      'category_id': _selectedCategoryId.toString(),
                      'name': _nameController.text,
                      'price': _priceController.text,
                      'stock': _stockController.text,
                      'description': _descController.text,
                    };

                    // Trigger event AddProduct ke BLoC
                    context.read<ProductBloc>().add(AddProduct(productData));
                    
                    // Kembali ke halaman sebelumnya (HomeScreen)
                    Navigator.pop(context);
                  }
                },
                child: const Text('Simpan Produk'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}