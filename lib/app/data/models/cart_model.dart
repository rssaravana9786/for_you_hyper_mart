class CartItem {
  final String name;
  final String imageUrl;
  final String weight; // Can be "1kg" or "N/A" for non-weighted items
  final double pricePerUnit;
  int quantity;

  CartItem({
    required this.name,
    required this.imageUrl,
    required this.weight,
    required this.pricePerUnit,
    required this.quantity,
  });

  double get totalPrice => quantity * pricePerUnit;
}
