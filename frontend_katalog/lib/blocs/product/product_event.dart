import 'package:equatable/equatable.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object> get props => [];
}

// Event untuk mengambil daftar produk
class FetchProducts extends ProductEvent {}

// Event untuk menghapus produk
class DeleteProduct extends ProductEvent {
  final int id;
  const DeleteProduct(this.id);

  @override
  List<Object> get props => [id];
}
// Event untuk menambah produk baru
class AddProduct extends ProductEvent {
  final Map<String, dynamic> productData;
  const AddProduct(this.productData);

  @override
  List<Object> get props => [productData];
}
// Event untuk mengubah produk yang sudah ada
class UpdateProduct extends ProductEvent {
  final int id;
  final Map<String, dynamic> productData;

  const UpdateProduct(this.id, this.productData);

  @override
  List<Object> get props => [id, productData];
}