import 'package:dartz/dartz.dart';
import 'package:mobile_sim_shop/core/errors/failures.dart';
import 'package:mobile_sim_shop/features/store/data/models/brand_model.dart';
import 'package:mobile_sim_shop/features/store/data/models/product_model.dart';
import 'package:mobile_sim_shop/features/store/data/models/product_variation_model.dart';
import 'package:mobile_sim_shop/features/store/data/models/search_product_params.dart';

import '../../data/models/fetch_variation_params.dart';
import '../../data/models/get_variation_id_attributes_params.dart';
import '../entities/payment_method.dart';

abstract class ProductRepository {
  Stream<Either<Failure, List<ProductModel>>> fetchAllProducts();
  Stream<Either<Failure, ProductModel?>> fetchProductById(String productId);

  Stream<Either<Failure, List<BrandModel>>> fetchAllBrands();
  Future<Either<Failure, BrandModel?>> fetchBrandById(String brandId);

  Stream<Either<Failure, List<ProductVariationModel>>> fetchVariationByProductId(String productId);
  Stream<Either<Failure, List<ProductModel>>> filterProducts(String filterOption);
  Stream<Either<Failure, List<ProductModel>>> fetchProductsByCategoryId(String categoryId);

  Future<Either<Failure, String?>> getVariationIdFromAttributes(
      GetVariationIdAttributesParams params);
  Future<Either<Failure, ProductVariationModel>> fetchVariation(
      FetchVariationParams params);

  Future<Either<Failure, List<ProductModel>>> searchProducts(SearchProductParams? params);
  Future<Either<Failure, List<String>>> fetchSuggestions(String query);
}