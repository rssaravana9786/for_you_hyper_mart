import 'dart:convert';

class ProductResponse {
  final String status;
  final List<Product> products;

  ProductResponse({required this.status, required this.products});

  factory ProductResponse.fromJson(String str) =>
      ProductResponse.fromMap(json.decode(str));

  factory ProductResponse.fromMap(Map<String, dynamic> json) => ProductResponse(
    status: json["status"],
    products: List<Product>.from(
        json["products"].map((x) => Product.fromMap(x))),
  );
}

class Product {
  final int id;
  final String name;
  final double price;
  final String image;
  final int categoryId;
  final int subCategoryId;
  final String categoryName;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    required this.categoryId,
    required this.subCategoryId,
    required this.categoryName,
  });

  factory Product.fromMap(Map<String, dynamic> json) => Product(
    id: json["id"],
    name: json["name"],
    price: double.tryParse(json["price"] ?? "0") ?? 0.0,
    image: json["image"],
    categoryId: json["category_id"],
    subCategoryId: json["sub_category_id"],
    categoryName: json["category_name"],
  );
}
