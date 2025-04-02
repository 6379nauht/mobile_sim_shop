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
  final List<ProductModel> categoryProducts; // Sản phẩm theo danh mục
  final List<BrandModel> relatedBrands; // Thương hiệu liên quan
  final List<String> thumbnailImages;
  const ProductState(
      {this.products = const [],
      this.brands = const [],
      this.productVariation = const [],
      this.filterProducts = const [],
      this.categoryProducts = const [],
      this.relatedBrands = const [],
      this.thumbnailImages = const [],
      this.status = ProductStatus.initial,
      this.product,
      this.brand,
      this.errorMessage});

  ProductState copyWith(
      {List<ProductModel>? products,
      List<BrandModel>? brands,
      List<ProductModel>? filterProducts,
      List<ProductVariationModel>? productVariation,
      List<ProductModel>? categoryProducts,
      List<BrandModel>? relatedBrands,
      List<String>? thumbnailImages,
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
        categoryProducts: categoryProducts ?? this.categoryProducts,
        relatedBrands: relatedBrands ?? this.relatedBrands,
        thumbnailImages: thumbnailImages ?? this.thumbnailImages,
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
        errorMessage,
        categoryProducts,
        relatedBrands,
        thumbnailImages
      ];
}
