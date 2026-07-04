import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/models/product.dart';
import '../blocs/product/product_blok.dart';
import '../blocs/product/product_event.dart';

class EditProductScreen extends StatefulWidget {
  final Product product;

  const EditProductScreen({super.key, required this.product});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _stockController;
  late TextEditingController _descController;
  late int _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    // Mengisi kolom input dengan data produk yang sudah ada saat ini
    _nameController = TextEditingController(text: widget.product.name);
    _priceController = TextEditingController(text: widget.product.price.toString());
    _stockController = TextEditingController(text: widget.product.stock.toString());
    _descController = TextEditingController(text: widget.product.description ?? '');
    _selectedCategoryId = widget.product.categoryId;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Produk Kriya')),
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
                decoration: const InputDecoration(labelText: 'Cerita/Deskripsi Produk'),
                maxLines: 3,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final updatedData = {
                      'category_id': _selectedCategoryId.toString(),
                      'name': _nameController.text,
                      'price': _priceController.text,
                      'stock': _stockController.text,
                      'description': _descController.text,
                    };

                    // Trigger event UpdateProduct ke BLoC
                    context.read<ProductBloc>().add(UpdateProduct(widget.product.id, updatedData));
                    
                    Navigator.pop(context);
                  }
                },
                child: const Text('Simpan Perubahan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}