class Brand {
  final String id;
  String name;
  String image;
  bool? isFeatured;
  int? productsCount;
  Brand ({
    required this.id,
    required this.name,
    required this.image,
    this.isFeatured,
    this.productsCount
});
}