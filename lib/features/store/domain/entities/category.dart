class Category {
  final String id;
  String name;
  String image;
  String? parentId;
  bool isFeatured;
  Category({
    required this.id,
    required this.name,
    required this.image,
    required this.isFeatured,
    this.parentId
});
}