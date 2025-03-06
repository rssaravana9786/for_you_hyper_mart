import 'package:for_you_hyper_mart/app/data/models/cart_model.dart';
import 'package:get/get.dart';

class CartController extends GetxController {
  var quantity = 1.obs;
  var totalPrice = 0.0.obs;
  var selectedWeight = ''.obs; // Stores selected weight
  var currentPrice = 0.0.obs; // Stores price based on weight
  var cartItems = <CartItem>[].obs;

  void increaseQuantity() {
    quantity++;
    totalPrice.value = quantity.value * currentPrice.value;
  }

  void decreaseQuantity() {
    if (quantity > 1) {
      quantity--;
      totalPrice.value = quantity.value * currentPrice.value;
    }
  }

  void reset(String initialWeight, double price) {
    quantity.value = 1;
    selectedWeight.value = initialWeight;
    currentPrice.value = price;
    totalPrice.value = price;
  }

  void setWeight(String weight, Map<String, double> weightPriceMap) {
    if (weightPriceMap.containsKey(weight)) {
      currentPrice.value = weightPriceMap[weight]!;
      totalPrice.value = quantity.value * currentPrice.value;
    }
    selectedWeight.value = weight;
  }

  void addToCart(CartItem item) {
    int index = cartItems.indexWhere((element) =>
        element.name == item.name && element.weight == item.weight);
    if (index != -1) {
      cartItems[index].quantity += item.quantity;
    } else {
      cartItems.add(item);
    }
    update();
  }

  void removeFromCart(CartItem item) {
    cartItems.remove(item);
    update();
  }

  void updateQuantity(CartItem item, int quantity) {
    int index = cartItems.indexWhere((element) =>
        element.name == item.name && element.weight == item.weight);
    if (index != -1) {
      cartItems[index].quantity = quantity;
      if (cartItems[index].quantity == 0) {
        cartItems.removeAt(index);
      }
    }
    update();
  }

  double get totalAmount =>
      cartItems.fold(0, (sum, item) => sum + item.totalPrice);
}
