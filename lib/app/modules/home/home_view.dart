import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:get/get.dart';
import 'home_controller.dart';
import '../cart/cart_controller.dart';

class HomeView extends StatelessWidget {
  final HomeController controller = Get.put(HomeController());
  final CartController cartController = Get.put(CartController());
  Color themeColor = const Color(0xff4caf50);
  String url = "https://foryouhypermart.com";
  var selectedCategory = 1.obs;
  var locations = ["Select Location", "Chennai", "Coimbatore", "Madurai"];
  var selectedLocation = "Select Location".obs;
  final List<String> image = [
    "https://foryouhypermart.com/images/fruitandveg.jpg",
    "https://foryouhypermart.com/images/cart.jpg",
    "https://foryouhypermart.com/images/plastic.jpg",
    "https://foryouhypermart.com/images/basmathi-rice.webp",
    "https://foryouhypermart.com/images/cook.webp",
    "https://foryouhypermart.com/images/edible.webp"
  ];
  final List<String> cat = [
    "Fruits & Veg",
    "Groceries",
    "Plastic Products",
    "Rice & Flours",
    "Cookware",
    "Edible Oil"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeColor,
        elevation: 0,
        title: Container(
          height: 40,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            decoration: InputDecoration(
              hintText: "Search for products...",
              hintStyle: TextStyle(color: Colors.grey),
              border: InputBorder.none,
              prefixIcon: Icon(Icons.search, color: Colors.grey),
              contentPadding: EdgeInsets.symmetric(vertical: 10),
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart, color: Colors.white),
            onPressed: () => Get.toNamed("/cart"),
          ),
          IconButton(
            icon: Icon(Icons.account_circle, color: Colors.white),
            onPressed: () => Get.toNamed("/user"),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: LocationSelector(),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Shop by Category",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 120,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: List.generate(6, (index) {
                return GestureDetector(
                  onTap: () {
                    selectedCategory.value = index + 1;
                    controller.fetchProducts(selectedCategory.value);
                  },
                  child: Obx(() => Container(
                        margin: EdgeInsets.symmetric(horizontal: 3),
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: selectedCategory.value == index + 1
                              ? Colors.blue
                              : Colors.grey,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            Container(
                              width: 75,
                              height: 75,
                              child: Image.network(image[index],
                                  fit: BoxFit.fitHeight),
                            ),
                            Text(cat[index],
                                style: TextStyle(color: Colors.white))
                          ],
                        ),
                      )),
                );
              }),
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return GridView.builder(
                  padding: EdgeInsets.all(10),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: 6,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Column(
                          children: [
                            Expanded(
                              child: Container(
                                  width: double.infinity, color: Colors.white),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      height: 10,
                                      width: 80,
                                      color: Colors.white),
                                  SizedBox(height: 5),
                                  Container(
                                      height: 10,
                                      width: 50,
                                      color: Colors.white),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
              if (controller.products.isEmpty) {
                return Center(child: Text("No products found"));
              }
              return GridView.builder(
                padding: EdgeInsets.all(10),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: controller.products.length,
                itemBuilder: (context, index) {
                  var product = controller.products[index];
                  return GestureDetector(
                    onTap: () =>
                        Get.toNamed("/product_details", arguments: product),
                    child: Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        children: [
                          Expanded(
                            child: Image.network(
                                "https://foryouhypermart.com/images/${product.image}",
                                fit: BoxFit.cover,
                                width: double.infinity,
                                errorBuilder: (context, error, stackTrace) {
                              return const Text(
                                'Image not available',
                              );
                            }),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.name,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text("Price: Rs.${product.price}",
                                    style: TextStyle(color: Colors.green)),
                              ],
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
      ),
    );
  }
}

class LocationSelector extends StatelessWidget {
  final HomeController controller = Get.find(); // GetX Controller

  final List<String> locations = [
    "Chennai",
    "Coimbatore",
    "Madurai",
    "Bangalore",
    "Hyderabad",
    "Mumbai"
  ];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showLocationPicker(context), // Show Bottom Sheet
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(Icons.location_on, color: Colors.red),
            SizedBox(width: 5),
            Obx(() => Text(
                  controller.selectedLocation.value,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                )),
            Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }

  void _showLocationPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(16),
          height: 300,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Select Location",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: locations.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: Icon(Icons.location_city, color: Colors.blue),
                      title: Text(locations[index]),
                      onTap: () {
                        controller
                            .updateLocation(locations[index]); // Update state
                        Get.back(); // Close Bottom Sheet
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
