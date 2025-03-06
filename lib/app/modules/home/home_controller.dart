import 'package:for_you_hyper_mart/app/data/models/product_model.dart';
import 'package:for_you_hyper_mart/app/data/services/api_service.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  var products = <Product>[].obs;
  var isLoading = true.obs;
  var selectedLocation = "Select Location".obs; // Default location

  @override
  void onInit() {
    fetchProducts(1);
    super.onInit();
  }

  void updateLocation(String newLocation) {
    selectedLocation.value = newLocation;
  }

  void fetchProducts(int categoryId) async {
    isLoading(true);
    try {
      var productList = await ApiService().fetchProductsByCategory(categoryId);
      if (productList.isEmpty) {
        print("No products found for category $categoryId");
      }
      products.value = productList;
    } finally {
      isLoading(false);
    }
  }
}
