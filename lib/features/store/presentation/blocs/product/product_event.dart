import 'package:equatable/equatable.dart';

import '../../../data/models/product_model.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object?> get props => [];
}

class FetchAllProducts extends ProductEvent {}

class FetchProductById extends ProductEvent {
  final String productId;
  const FetchProductById({required this.productId});
}

class FetchAllBrands extends ProductEvent {}

class FetchBrandById extends ProductEvent {
  final String brandId;
  const FetchBrandById({required this.brandId});
}

class FetchVariationsByProductId extends ProductEvent {
  final String productId;
  const FetchVariationsByProductId({required this.productId});
}

class FetchProductWithDetails extends ProductEvent {
  final String productId;
  const FetchProductWithDetails({required this.productId});
}

class FilterProducts extends ProductEvent {
  final String filterOption;

  const FilterProducts({required this.filterOption});
}