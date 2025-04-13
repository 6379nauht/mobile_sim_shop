class SearchProductParams {
  final String query; // Từ khóa tìm kiếm (bắt buộc)
  final String? sort; // Tiêu chí sắp xếp (tùy chọn)
  final List<String>? categories; // Danh sách danh mục (tùy chọn)
  final double? minPrice; // Giá tối thiểu (tùy chọn)
  final double? maxPrice; // Giá tối đa (tùy chọn)

  SearchProductParams({
    required this.query,
    this.sort,
    this.categories,
    this.minPrice,
    this.maxPrice,
  });
}
