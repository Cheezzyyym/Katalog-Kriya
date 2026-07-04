import 'category.dart';

class Product {
  final int id;
  final int categoryId;
  final String name;
  final int price;
  final int stock;
  final String? description;
  final Category? category;

  Product({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.price,
    required this.stock,
    this.description,
    this.category,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      categoryId: json['category_id'],
      name: json['name'],
      price: json['price'],
      stock: json['stock'],
      description: json['description'],
      category: json['category'] != null ? Category.fromJson(json['category']) : null,
    );
  }
}