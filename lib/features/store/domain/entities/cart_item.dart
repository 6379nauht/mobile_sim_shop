class CartItem {
  String productId;
  String title;
  double price;
  String image;
  int quantity;
  String variationId;
  String? brandName;
  int stock;
  Map<String, dynamic>? selectedVariation;
  CartItem(
      {required this.productId,
        required this.quantity,
        this.variationId = '',
        required this.image,
        this.price = 0.0,
        this.brandName,
        required this.stock,
        this.title = '',
        this.selectedVariation});
}
