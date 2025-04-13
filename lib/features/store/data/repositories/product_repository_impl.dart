import 'package:dartz/dartz.dart';

import 'package:mobile_sim_shop/core/errors/failures.dart';

import 'package:mobile_sim_shop/features/store/data/models/brand_model.dart';
import 'package:mobile_sim_shop/features/store/data/models/fetch_variation_params.dart';
import 'package:mobile_sim_shop/features/store/data/models/get_variation_id_attributes_params.dart';
import 'package:mobile_sim_shop/features/store/data/models/product_model.dart';

import 'package:mobile_sim_shop/features/store/data/models/product_variation_model.dart';
import 'package:mobile_sim_shop/features/store/data/models/search_product_params.dart';
import 'package:mobile_sim_shop/features/store/data/sources/product_firebase_service.dart';

import '../../../../core/dependency_injection/locator.dart';
import '../../domain/entities/payment_method.dart';
import '../../domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository{
  final ProductFirebaseService _firebaseService = getIt<ProductFirebaseService>();

  @override
  Stream<Either<Failure, List<BrandModel>>> fetchAllBrands() {
    return _firebaseService.fetchAllBrands();
  }

  @override
  Stream<Either<Failure, List<ProductModel>>> fetchAllProducts() {
    return _firebaseService.fetchAllProducts();
  }

  @override
  Future<Either<Failure, BrandModel?>> fetchBrandById(String brandId) async{
    return await _firebaseService.fetchBrandById(brandId);
  }

  @override
  Stream<Either<Failure, ProductModel?>> fetchProductById(String productId) {
    return _firebaseService.fetchProductById(productId);
  }

  @override
  Stream<Either<Failure, List<ProductVariationModel>>> fetchVariationByProductId(String productId) {
    return _firebaseService.fetchVariationByProductId(productId);
  }


  @override
  Stream<Either<Failure, List<ProductModel>>> filterProducts(String filterOption) {
    return _firebaseService.filterProducts(filterOption);
  }

  @override
  Stream<Either<Failure, List<ProductModel>>> fetchProductsByCategoryId(String categoryId) {
    return _firebaseService.fetchProductsByCategoryId(categoryId);
  }

  @override
  Future<Either<Failure, ProductVariationModel>> fetchVariation(FetchVariationParams params) async {
    return await _firebaseService.fetchVariation(params);
  }

  @override
  Future<Either<Failure, String?>> getVariationIdFromAttributes(GetVariationIdAttributesParams params)async {
    return await _firebaseService.getVariationIdFromAttributes(params);
  }

  @override
  Future<Either<Failure, List<ProductModel>>> searchProducts(SearchProductParams? params) async{
    return await _firebaseService.searchProducts(params);
  }

  @override
  Future<Either<Failure, List<String>>> fetchSuggestions(String query) async{
    return await _firebaseService.fetchSuggestions(query);
  }


}