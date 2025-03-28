import 'package:flutter/material.dart';
import 'package:for_you_hyper_mart/app/modules/NavBar/bottom_nav_bar.dart';
import 'package:for_you_hyper_mart/app/modules/home/connectivity_controller.dart';
import 'package:for_you_hyper_mart/app/widgets/basic_widgets.dart';
import 'package:shimmer/shimmer.dart';
import 'package:get/get.dart';
import 'home_controller.dart';
import '../cart/cart_controller.dart';

class HomeView extends StatelessWidget {
  BasicWidget basicWidget = BasicWidget();
  final HomeController controller = Get.put(HomeController());
  final CartController cartController = Get.put(CartController());
  Color themeColor = const Color(0xff4caf50);
  String url = "https://foryouhypermart.com";
  var selectedCategory = 1.obs;
  var locations = ["Select Location", "Chennai", "Coimbatore", "Madurai"];
  var selectedLocation = "Select Location".obs;
  final InternetController internetController = Get.find();
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

  final List<String> posters = [
    "https://foryouhypermart.com/images/basmathi-rice.webp",
    "https://foryouhypermart.com/images/cook.webp",
    "https://foryouhypermart.com/images/edible.webp"
  ];

  HomeView({super.key});

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
          child: const TextField(
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
          Obx(() {
            final CartController cartController = Get.find();
            return Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.shopping_cart, color: Colors.white),
                  onPressed: () => Get.toNamed("/cart"),
                ),
                if (cartController.cartItems.isNotEmpty)
                  Positioned(
                    right: 6,
                    top: 6,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 18,
                        minHeight: 18,
                      ),
                      child: Text(
                        cartController.cartItems.length.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            );
          }),
          IconButton(
            icon: const Icon(Icons.account_circle, color: Colors.white),
            onPressed: () => Get.toNamed("/user"),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(),
      body: Obx(() {
      return internetController.isConnected.value
          ? SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: LocationSelector(),
            ),
            // Dynamic Posters
            SizedBox(
              height: 150,
              child: PageView.builder(
                itemCount: posters.length,
                controller: PageController(viewportFraction: 0.9),
                onPageChanged: (index) {
                },
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        posters[index],
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
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
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: selectedCategory.value == index + 1
                            ? Colors.green
                            : Colors.grey,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                            width: 75,
                            height: 75,
                            child: Image.network(image[index],
                                fit: BoxFit.fitHeight),
                          ),
                          Text(cat[index],
                              style: const TextStyle(color: Colors.white))
                        ],
                      ),
                    )),
                  );
                }),
              ),
            ),
            SizedBox(
              height: 80.0,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    basicWidget.getFilterButton("Free shipping", () {}),
                    basicWidget.getFilterButton("Top deals", () {}),
                    basicWidget.getFilterButton("Availability", () {}),
                    basicWidget.getFilterButton("Rewards", () {}),
                  ],
                ),
              ),
            ),
            // GridView.builder with NeverScrollableScrollPhysics
            Obx(() {
              if (controller.isLoading.value) {
                return GridView.builder(
                  physics: const NeverScrollableScrollPhysics(), // Disable GridView scrolling
                  shrinkWrap: true, // Allow GridView to take only required space
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
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
                                      height: 10, width: 80, color: Colors.white),
                                  const SizedBox(height: 5),
                                  Container(
                                      height: 10, width: 50, color: Colors.white),
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
                return const Center(child: Text("No products found"));
              }
              return GridView.builder(
                physics: const NeverScrollableScrollPhysics(), // Disable GridView scrolling
                shrinkWrap: true, // Allow GridView to take only required space
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                ),
                itemCount: controller.products.length,
                itemBuilder: (context, index) {
                  var product = controller.products[index];
                  return Stack(
                    children: [
                      GestureDetector(
                          onTap: () => Get.toNamed("/product_details",
                              arguments: product),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                    color: Colors.grey, width: 0.5)),
                            child: Column(
                              children: [
                                Expanded(
                                  child: Image.network(
                                      "https://foryouhypermart.com/images/${product.image}",
                                      fit: BoxFit.cover,
                                      width: double.infinity),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product.name,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        "This is a high-quality ${product.name}. Get it now at the best price from our store!",
                                        maxLines: 1,
                                      ),
                                      const SizedBox(height: 5), Text(
                                        "Price: Rs.${product.price}",
                                        style: const TextStyle(
                                            color: Colors.green),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )),
                      Obx(() {
                        return Positioned(
                            top: 1,
                            right: 1,
                            child: IconButton(
                              icon: const Icon(Icons.favorite_border),
                              color: controller.isFavourite.value
                                  ? Colors.red
                                  : Colors.grey,
                              onPressed: () {
                                controller.isFavourite.value =
                                !controller.isFavourite.value;
                              },
                            ));
                      }),
                      Positioned(
                        top: 5.0,left: 5.0,
                        child:
                      Row(
                        children: [
                          Text(
                            (product.price * 2).toString(),
                            style: TextStyle(
                              color: Colors.red,
                              fontStyle: FontStyle.italic,
                              decorationColor: Colors.red,
                              decorationThickness: 3.0,
                              decoration: TextDecoration.combine([
                                TextDecoration.lineThrough,
                              ]),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.green,
                                borderRadius:
                                BorderRadius.circular(5.0)),
                            padding: const EdgeInsets.all(2),margin: const EdgeInsets.only(left: 5.0),
                            child: const Text("50%Off",style: TextStyle(color: Colors.white),),
                          ),
                        ],
                      ),)
                    ],
                  );
                },
              );
            }),
          ],
        ),
      )
          : basicWidget.noInternetWidget(context);
    }),
    );
  }
}

class LocationSelector extends StatelessWidget {
  final HomeController controller = Get.find();

  final List<String> locations = [
    "Chennai",
    "Coimbatore",
    "Madurai",
    "Bangalore",
    "Hyderabad",
    "Mumbai"
  ];

   LocationSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showLocationPicker(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            const Icon(Icons.location_on, color: Colors.red),
            const SizedBox(width: 5),
            Obx(() => Text(
              controller.selectedLocation.value,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            )),
            const Icon(Icons.arrow_drop_down),
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
          padding: const EdgeInsets.all(16),
          height: 300,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Select Location",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: locations.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: const Icon(Icons.location_city, color: Colors.blue),
                      title: Text(locations[index]),
                      onTap: () {
                        controller.updateLocation(locations[index]);
                        Get.back();
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