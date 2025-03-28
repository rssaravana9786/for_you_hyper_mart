import 'package:flutter/material.dart';
import 'package:for_you_hyper_mart/app/data/models/cart_model.dart';
import 'package:for_you_hyper_mart/app/data/models/product_model.dart';
import 'package:for_you_hyper_mart/app/modules/cart/cart_controller.dart';
import 'package:for_you_hyper_mart/app/modules/home/home_controller.dart';
import 'package:get/get.dart';

class ProductDetailsView extends StatelessWidget {
  final Product product;
  final HomeController homeController = Get.find();
  final CartController cartController = Get.find();
  final RxInt quantity = 1.obs; // Observable for quantity
  final RxString selectedWeight = "1Kg".obs; // Observable for weight selection
  final Rx<Product> selectedProduct; // Reactive selected product

  final Map<String, double> weightOptions = {
    "250g": 0.25,
    "500g": 0.5,
    "750g": 0.75,
    "1Kg": 1.0,
    "2Kg": 2.0
  };

  ProductDetailsView({required this.product})
      : selectedProduct = product.obs; // Initialize with passed product

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        onPopInvokedWithResult: (s, didPop) {
          if (!s) {
            Get.back();
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: Obx(() => Text(selectedProduct.value.name)),
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Image
                Obx(() => Container(
                  height: 250,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                          "https://foryouhypermart.com/images/${selectedProduct.value.image}"),
                      fit: BoxFit.cover,
                    ),
                  ),
                )),

                // Product Name & Price
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(() => Text(selectedProduct.value.name,
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold))),
                      SizedBox(height: 8),

                      // Dynamic price update
                      Obx(() {
                        bool isFruitsAndVeg =
                            selectedProduct.value.categoryName == "Fruits & Veg";
                        double price = selectedProduct.value.price;
                        double totalPrice = isFruitsAndVeg
                            ? price *
                            (weightOptions[selectedWeight.value] ?? 1.0)
                            : price * quantity.value;

                        return Text(
                          "Total: Rs. ${totalPrice.toStringAsFixed(2)}",
                          style: TextStyle(fontSize: 18, color: Colors.green),
                        );
                      }),

                      SizedBox(height: 8),
                      Divider(),

                      // Quantity or Weight Selector
                      Obx(() {
                        bool isFruitsAndVeg =
                            selectedProduct.value.categoryName == "Fruits & Veg";
                        return isFruitsAndVeg
                            ? _buildWeightSelector()
                            : _buildQuantitySelector();
                      }),

                      SizedBox(height: 16),

                      // Product Description
                      Text("Product Description",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 8),
                      Obx(() => Text(
                        "This is a high-quality ${selectedProduct.value.name}. Get it now at the best price from our store!",
                        style: TextStyle(fontSize: 16),
                      )),
                      SizedBox(height: 16),
                    ],
                  ),
                ),

                // Add to Cart Button
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: ElevatedButton(
                    onPressed: () {
                      bool isFruitsAndVeg =
                          selectedProduct.value.categoryName == "Fruits & Veg";
                      double finalPrice = selectedProduct.value.price *
                          (isFruitsAndVeg
                              ? (weightOptions[selectedWeight.value] ?? 1.0)
                              : quantity.value);

                      cartController.addToCart(CartItem(
                        name: selectedProduct.value.name,
                        imageUrl:
                        "https://foryouhypermart.com/images/${selectedProduct.value.image}",
                        weight:
                        isFruitsAndVeg ? selectedWeight.value : "1 unit",
                        pricePerUnit: finalPrice,
                        quantity: isFruitsAndVeg ? 1 : quantity.value,
                      ));

                      Get.snackbar("Added to Cart",
                          "${isFruitsAndVeg ? selectedWeight.value : quantity.value} of ${selectedProduct.value.name} added.");
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      minimumSize: Size(double.infinity, 50),
                    ),
                    child: Text("Add to Cart",
                        style: TextStyle(color: Colors.white, fontSize: 18)),
                  ),
                ),
                buildSuggestedProducts(homeController)
              ],
            ),
          ),
        ));
  }

  Widget _buildWeightSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text("Select Weight:",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(width: 10),
        Obx(() => DropdownButton<String>(
          value: selectedWeight.value,
          onChanged: (String? newWeight) {
            if (newWeight != null) {
              selectedWeight.value = newWeight;
            }
          },
          items: weightOptions.keys.map((String weight) {
            return DropdownMenuItem<String>(
              value: weight,
              child: Text(weight),
            );
          }).toList(),
        )),
      ],
    );
  }

  Widget _buildQuantitySelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text("Quantity:",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(width: 10),
        IconButton(
          icon: Icon(Icons.remove_circle_outline, color: Colors.red),
          onPressed: () {
            if (quantity.value > 1) {
              quantity.value--;
            }
          },
        ),
        Obx(() => Text(
          "${quantity.value}",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        )),
        IconButton(
          icon: Icon(Icons.add_circle_outline, color: Colors.green),
          onPressed: () {
            quantity.value++;
          },
        ),
      ],
    );
  }

  Widget buildSuggestedProducts(HomeController homeController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text("You may also like",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        SizedBox(
          height: 150,
          child: Obx(() {
            var suggestedProducts = homeController.products
                .where((p) =>
            p.categoryId == selectedProduct.value.categoryId &&
                p.id != selectedProduct.value.id)
                .toList();

            if (suggestedProducts.isEmpty) {
              return Center(child: Text("No suggestions available"));
            }

            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: suggestedProducts.length,
              itemBuilder: (context, index) {
                var suggestedProduct = suggestedProducts[index];

                return GestureDetector(
                  onTap: () {
                    selectedProduct.value = suggestedProduct; // Update product dynamically
                  },
                  child: Container(
                    width: 120,
                    margin: EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 4)],
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: Image.network(
                            "https://foryouhypermart.com/images/${suggestedProduct.image}",
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Icon(Icons.broken_image),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: Text(
                            suggestedProduct.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }),
        ),
      ],
    );
  }
}
