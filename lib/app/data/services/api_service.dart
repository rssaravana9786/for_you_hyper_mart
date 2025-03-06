import 'package:dio/dio.dart';
import '../models/product_model.dart';

class ApiService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: "https://foryouhypermart.com",
    connectTimeout: Duration(seconds: 10), // Set timeout
    receiveTimeout: Duration(seconds: 10),
  ));

  Future<List<Product>> fetchProductsByCategory(int categoryId) async {
    try {
      final response = await _dio.get("/fetch_category.php",
          queryParameters: {"category_id": categoryId});

      if (response.statusCode == 200) {
        final data = response.data;

        if (data is Map<String, dynamic> && data.containsKey("products")) {
          List<dynamic> productList = data["products"];
          return productList.map((item) => Product.fromMap(item)).toList();
        } else {
          print("Invalid response format: $data");
          return [];
        }
      } else {
        print("Failed to load products. Status code: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("Error fetching products: $e");
      return [];
    }
  }
}
