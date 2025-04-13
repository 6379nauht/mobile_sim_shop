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
  @override
  List<Object?> get props => [productId];
}

class FetchAllBrands extends ProductEvent {}

class FetchBrandById extends ProductEvent {
  final String brandId;
  const FetchBrandById({required this.brandId});
  @override
  List<Object?> get props => [brandId];
}

class FetchVariationsByProductId extends ProductEvent {
  final String productId;
  const FetchVariationsByProductId({required this.productId});
  @override
  List<Object?> get props => [productId];
}

class FilterProducts extends ProductEvent {
  final String filterOption;

  const FilterProducts({required this.filterOption});
  @override
  List<Object?> get props => [filterOption];
}

class FetchProductByCategoryId extends ProductEvent {
  final String categoryId;
  const FetchProductByCategoryId({required this.categoryId});
  @override
  List<Object?> get props => [categoryId];
}

class ResetProductState extends ProductEvent {}
class ResetSelectedVariations extends ProductEvent {}
class SelectVariation extends ProductEvent {
  final String attributeName;
  final String? value; // null nếu bỏ chọn
  const SelectVariation({required this.attributeName, this.value});
  @override
  List<Object?> get props => [attributeName, value];
}