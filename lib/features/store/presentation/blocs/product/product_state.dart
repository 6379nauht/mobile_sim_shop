import 'package:equatable/equatable.dart';
import 'package:mobile_sim_shop/features/store/data/models/brand_model.dart';
import 'package:mobile_sim_shop/features/store/data/models/product_model.dart';
import 'package:mobile_sim_shop/features/store/data/models/product_variation_model.dart';

enum ProductStatus { initial, loading, success, failure }

class ProductState extends Equatable {
  final List<ProductModel> products;
  final List<ProductModel> filterProducts;
  final List<BrandModel> brands;
  final ProductModel? product;
  final BrandModel? brand;
  final List<ProductVariationModel> productVariation;
  final ProductStatus status;
  final String? errorMessage;
  const ProductState(
      {this.products = const [],
      this.brands = const [],
      this.productVariation = const [],
      this.filterProducts = const [],
      this.status = ProductStatus.initial,
      this.product,
      this.brand,
      this.errorMessage});

  ProductState copyWith(
      {List<ProductModel>? products,
      List<BrandModel>? brands,
      List<ProductModel>? filterProducts,
      List<ProductVariationModel>? productVariation,
      ProductModel? product,
      BrandModel? brand,
      ProductStatus? status,
      String? errorMessage}) {
    return ProductState(
        products: products ?? this.products,
        filterProducts: filterProducts ?? this.filterProducts,
        brands: brands ?? this.brands,
        product: product ?? this.product,
        brand: brand ?? this.brand,
        productVariation: productVariation ?? this.productVariation,
        status: status ?? this.status,
        errorMessage: errorMessage ?? this.errorMessage);
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
        products,
        brands,
        product,
        brand,
        productVariation,
        status,
        filterProducts,
        errorMessage
      ];
}
