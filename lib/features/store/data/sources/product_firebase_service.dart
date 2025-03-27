import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:get_it/get_it.dart';

import '../../../../core/dependency_injection/locator.dart';
import '../../../../core/errors/failures.dart';
import '../models/brand_model.dart';
import '../models/product_model.dart';
import '../models/product_variation_model.dart';

abstract class ProductFirebaseService {
  Stream<Either<Failure, List<ProductModel>>> fetchAllProducts();
  Stream<Either<Failure, ProductModel?>> fetchProductById(String productId);

  Stream<Either<Failure, List<BrandModel>>> fetchAllBrands();
  Stream<Either<Failure, BrandModel?>> fetchBrandById(String brandId);

  Stream<Either<Failure, List<ProductVariationModel>>> fetchVariationByProductId(String productId);
  Stream<Either<Failure, ProductModel?>> fetchProductWithDetails(String productId);
  Stream<Either<Failure, List<ProductModel>>> filterProducts(String filterOption);
}

class ProductFirebaseServiceImpl implements ProductFirebaseService{
  @override
  Stream<Either<Failure, List<BrandModel>>> fetchAllBrands() {
    final Stream<Either<Failure, List<BrandModel>>> stream =
    getIt<FirebaseFirestore>()
        .collection('brands')
        .snapshots()
        .map((snapshot) {
      try {
        final brands = snapshot.docs
            .map((doc) => BrandModel.fromSnapshot(doc))
            .toList();
        return Right<Failure, List<BrandModel>>(brands);
      } catch (e) {
        return Left<Failure, List<BrandModel>>(ServerFailure( 'Error streaming products: $e'));
      }
    })
        .handleError((e) {
      return Left<Failure, List<BrandModel>>(ServerFailure('Stream error: $e'));
    });
    return stream;
  }

  @override
  Stream<Either<Failure, List<ProductModel>>> fetchAllProducts() {
    final Stream<Either<Failure, List<ProductModel>>> stream =
    getIt<FirebaseFirestore>()
        .collection('products')
        .snapshots()
        .map((snapshot) {
      try {
        final products = snapshot.docs
            .map((doc) => ProductModel.fromSnapshot(doc))
            .toList();
        return Right<Failure, List<ProductModel>>(products);
      } catch (e) {
        return Left<Failure, List<ProductModel>>(ServerFailure( 'Error streaming products: $e'));
      }
    })
        .handleError((e) {
      return Left<Failure, List<ProductModel>>(ServerFailure('Stream error: $e'));
    });
    return stream;
  }

  @override
  Stream<Either<Failure, BrandModel?>> fetchBrandById(String brandId) {
    final Stream<Either<Failure, BrandModel?>> stream =
    getIt<FirebaseFirestore>()
        .collection('brands')
        .doc(brandId)
        .snapshots()
        .map((docSnapshot) {
      try {
        if (docSnapshot.exists) {
          final brand = BrandModel.fromSnapshot(docSnapshot);
          return Right<Failure, BrandModel?>(brand);
        } else {
          return const Right<Failure, BrandModel?>(null);
        }
      } catch (e) {
        return Left<Failure, BrandModel?>(ServerFailure('Error streaming brand: $e'));
      }
    })
        .handleError((e) {
      return Left<Failure, BrandModel?>(ServerFailure('Stream error: $e'));
    });
    return stream;
  }

  @override
  Stream<Either<Failure, ProductModel?>> fetchProductById(String productId) {
    final Stream<Either<Failure, ProductModel?>> stream =
    getIt<FirebaseFirestore>()
        .collection('products')
        .doc(productId)
        .snapshots()
        .map((docSnapshot) {
      try {
        if (docSnapshot.exists) {
          final product = ProductModel.fromSnapshot(docSnapshot);
          return Right<Failure, ProductModel?>(product);
        } else {
          return const Right<Failure, ProductModel?>(null);
        }
      } catch (e) {
        return Left<Failure, ProductModel?>(ServerFailure('Error streaming product: $e'));
      }
    })
        .handleError((e) {
      return Left<Failure, ProductModel?>(ServerFailure('Stream error: $e'));
    });
    return stream;
  }

  @override
  Stream<Either<Failure, List<ProductVariationModel>>> fetchVariationByProductId(String productId) {
    final Stream<Either<Failure, List<ProductVariationModel>>> stream =
    getIt<FirebaseFirestore>()
        .collection('productVariations')
        .where('productId', isEqualTo: productId)
        .snapshots()
        .map((snapshot) {
      try {
        final variations = snapshot.docs
            .map((doc) => ProductVariationModel.fromSnapshot(doc))
            .toList();
        return Right<Failure, List<ProductVariationModel>>(variations);
      } catch (e) {
        return Left<Failure, List<ProductVariationModel>>(ServerFailure('Error streaming variations: $e'));
      }
    })
        .handleError((e) {
      return Left<Failure, List<ProductVariationModel>>(ServerFailure('Stream error: $e'));
    });
    return stream;
  }

  @override
  Stream<Either<Failure, ProductModel?>> fetchProductWithDetails(String productId) {
    final firestore = getIt<FirebaseFirestore>();
    // Stream cho product
    return firestore
        .collection('products')
        .doc(productId)
        .snapshots()
        .asyncMap((productSnapshot) async {
      try {
        if (!productSnapshot.exists) {
          return const Right<Failure, ProductModel?>(null);
        }
        ProductModel product = ProductModel.fromSnapshot(productSnapshot);

        // Lấy brand nếu có brandId
        if (product.brand?.id != null) {
          final brandEither = await fetchBrandById(product.brand!.id).first;
          brandEither.fold(
                (failure) => throw Exception(failure.message),
                (brand) {
              if (brand != null) {
                product = ProductModel(
                  id: product.id,
                  title: product.title,
                  stock: product.stock,
                  price: product.price,
                  thumbnail: product.thumbnail,
                  productType: product.productType,
                  sku: product.sku,
                  brandId: brand.id,
                  date: product.date,
                  salePrice: product.salePrice,
                  isFeatured: product.isFeatured,
                  categoryId: product.categoryId,
                  description: product.description,
                  images: product.images,
                  productAttributes: product.productAttributes,
                );
              }
            },
          );
        }

        // Lấy variations (chỉ để log)
        final variationsEither = await fetchVariationByProductId(productId).first;
        variationsEither.fold(
              (failure) => throw Exception(failure.message),
              (variations) {
            print('Variations for $productId: ${variations.length} found');
          },
        );

        return Right<Failure, ProductModel?>(product);
      } catch (e) {
        return Left<Failure, ProductModel?>(ServerFailure('Error streaming product details: $e'));
      }
    })
        .handleError((e) {
      return Left<Failure, ProductModel?>(ServerFailure('Stream error: $e'));
    });
  }

  @override
  Stream<Either<Failure, List<ProductModel>>> filterProducts(String filterOption) {
    Query query = getIt<FirebaseFirestore>().collection('products');
    final parts = filterOption.split('|');

    // Đảm bảo parts đủ dài và xử lý giá trị mặc định
    final categoryId = parts.isNotEmpty && parts[0].isNotEmpty ? parts[0] : 'All';
    final brandId = parts.length > 1 && parts[1].isNotEmpty ? parts[1] : 'All';
    final sortOption = parts.length > 2 && parts[2].isNotEmpty ? parts[2] : 'Name';

    if (categoryId != 'All') {
      query = query.where('categoryId', isEqualTo: categoryId);
    }
    if (brandId != 'All') {
      query = query.where('brandId', isEqualTo: brandId);
    }
    switch (sortOption) {
      case 'Name':
        query = query.orderBy('title');
        break;
      case 'Higher Price':
        query = query.orderBy('price', descending: true);
        break;
      case 'Lower Price':
        query = query.orderBy('price');
        break;
      case 'Sale':
        query = query.where('salePrice', isGreaterThan: 0).orderBy('salePrice');
        break;
      case 'Newest':
        query = query.orderBy('date', descending: true);
        break;
      default:
        query = query.orderBy('title');
    }
    return query.snapshots().map(
          (snapshot) {
        try {
          final products = snapshot.docs
              .map((doc) => ProductModel.fromSnapshot(doc))
              .toList();
          print('Firestore products: ${products.length}'); // Debug
          return Right(products);
        } catch (e) {
          return Left(ServerFailure('Failed to filter products: $e'));
        }
      },
    );
  }
}