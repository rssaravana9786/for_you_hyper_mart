import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'cart_controller.dart';

class CartPage extends StatelessWidget {
  final CartController cartController = Get.put(CartController());
String token = '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';
  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (!didPop) {
            Get.back();
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text("Cart"),
            centerTitle: true,
          ),
          body: GetBuilder<CartController>(
            builder: (controller) {
              return controller.cartItems.isEmpty
                  ? const Center(
                      child: Text(
                        "Your cart is empty!",
                        style: TextStyle(fontSize: 18),
                      ),
                    )
                  : Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            itemCount: controller.cartItems.length,
                            itemBuilder: (context, index) {
                              final item = controller.cartItems[index];
                              return Card(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                child: ListTile(
                                  leading: Image.network(item.imageUrl,
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.cover, errorBuilder:
                                          (context, error, stackTrace) {
                                    return const Text(
                                      'Image not available',
                                    );
                                  }),
                                  title: Text(
                                    item.name,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  subtitle: Text(
                                    item.weight != "N/A"
                                        ? "${item.weight} - ₹${item.totalPrice.toStringAsFixed(2)}"
                                        : "Qty: ${item.quantity} - ₹${item.totalPrice.toStringAsFixed(2)}",
                                    style: TextStyle(color: Colors.green),
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.remove_circle_outline,
                                            color: Colors.red),
                                        onPressed: () {
                                          cartController.updateQuantity(
                                              item, item.quantity - 1);
                                        },
                                      ),
                                      Text(
                                        "${item.quantity}",
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.add_circle_outline,
                                            color: Colors.green),
                                        onPressed: () {
                                          cartController.updateQuantity(
                                              item, item.quantity + 1);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 5,
                                  offset: Offset(0, -2))
                            ],
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Total Amount:",
                                      style: TextStyle(fontSize: 18)),
                                  Text(
                                    "₹${controller.totalAmount.toStringAsFixed(2)}",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: () {
                                  // Navigate to Checkout Page (to be implemented)
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 50),
                                  backgroundColor: Colors.orange,
                                ),
                                child: Text(
                                  "Proceed to Checkout",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
            },
          ),
        ));
  }
}
