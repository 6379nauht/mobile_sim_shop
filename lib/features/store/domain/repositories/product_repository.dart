import 'package:dartz/dartz.dart';
import 'package:mobile_sim_shop/core/errors/failures.dart';
import 'package:mobile_sim_shop/features/store/data/models/brand_model.dart';
import 'package:mobile_sim_shop/features/store/data/models/category_model.dart';
import 'package:mobile_sim_shop/features/store/data/models/product_model.dart';
import 'package:mobile_sim_shop/features/store/data/models/product_variation_model.dart';

abstract class ProductRepository {
  Stream<Either<Failure, List<ProductModel>>> fetchAllProducts();
  Stream<Either<Failure, ProductModel?>> fetchProductById(String productId);

  Stream<Either<Failure, List<BrandModel>>> fetchAllBrands();
  Stream<Either<Failure, BrandModel?>> fetchBrandById(String brandId);

  Stream<Either<Failure, List<ProductVariationModel>>> fetchVariationByProductId(String productId);
  Stream<Either<Failure, List<ProductModel>>> filterProducts(String filterOption);
  Stream<Either<Failure, List<ProductModel>>> fetchProductsByCategoryId(String categoryId);
}