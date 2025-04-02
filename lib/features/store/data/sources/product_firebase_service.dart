import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:rxdart/rxdart.dart';
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
  Stream<Either<Failure, List<ProductModel>>> filterProducts(String filterOption);
  Stream<Either<Failure, List<ProductModel>>> fetchProductsByCategoryId(String categoryId);
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
  Stream<Either<Failure, List<ProductModel>>> filterProducts(String filterOption) async* {
    try {
      final parts = filterOption.split('|');
      final categoryId = parts.isNotEmpty && parts[0].isNotEmpty ? parts[0] : 'All';
      final brandId = parts.length > 1 && parts[1].isNotEmpty ? parts[1] : 'All';
      final sortOption = parts.length > 2 && parts[2].isNotEmpty ? parts[2] : 'Name';

      List<String> allCategoryIds = [];
      if (categoryId != 'All') {
        // Lấy danh sách danh mục con
        final subcategoryIds = await _fetchSubcategoryIdsSafely(categoryId);
        allCategoryIds = [categoryId, ...subcategoryIds];
        print('All Category IDs for filter: $allCategoryIds');
      }

      // Tạo các Stream cho từng categoryId (nếu có) hoặc truy vấn chung
      final productStreams = categoryId == 'All'
          ? [
        _buildQuery(
          getIt<FirebaseFirestore>().collection('products'),
          brandId,
          sortOption,
        ).snapshots().map((snapshot) => _mapSnapshotToProducts(snapshot, 'All')),
      ]
          : allCategoryIds.map((id) {
        Query query = getIt<FirebaseFirestore>()
            .collection('products')
            .where('categoryId', isEqualTo: id);
        return _buildQuery(query, brandId, sortOption)
            .snapshots()
            .map((snapshot) => _mapSnapshotToProducts(snapshot, id));
      }).toList();

      // Gộp các Stream bằng Rx.combineLatestList
      await for (final List<Either<Failure, List<ProductModel>>> combinedResults
      in Rx.combineLatestList(productStreams)) {
        final collectedProducts = <ProductModel>[];
        for (final eitherProducts in combinedResults) {
          eitherProducts.fold(
                (failure) => print('Filter stream failure: $failure'),
                (products) {
              print('Products in this stream: ${products.length}');
              collectedProducts.addAll(products);
            },
          );
        }

        print('Total filtered products: ${collectedProducts.length}');
        if (collectedProducts.isNotEmpty) {
          yield Right<Failure, List<ProductModel>>(collectedProducts);
        } else {
          yield Left<Failure, List<ProductModel>>(
              ServerFailure('No products found for filter $filterOption'));
        }
      }
    } catch (e) {
      print('Error in filterProducts: $e');
      yield Left<Failure, List<ProductModel>>(
          ServerFailure('Error filtering products: $e'));
    }
  }

  Query _buildQuery(Query query, String brandId, String sortOption) {
    if (brandId != 'All') {
      query = query.where('brandId', isEqualTo: brandId);
    }

    // Áp dụng orderBy dựa trên sortOption
    switch (sortOption) {
      case 'Name':
        query = query.orderBy('title', descending: false);
        break;
      case 'Higher Price':
        query = query.orderBy('price', descending: true);
        break;
      case 'Lower Price':
        query = query.orderBy('price', descending: false);
        break;
      case 'Sale':
      // Không dùng where('salePrice', isGreaterThan: 0) để khớp chỉ mục hiện tại
        query = query.orderBy('salePrice', descending: false);
        break;
      case 'Newest':
        query = query.orderBy('date', descending: true);
        break;
      default:
        query = query.orderBy('title', descending: false);
    }
    return query;
  }






  @override
  Stream<Either<Failure, List<ProductModel>>> fetchProductsByCategoryId(String categoryId) async* {
    try {
      print('Fetching products for categoryId: $categoryId');

      final subcategoryIds = await _fetchSubcategoryIdsSafely(categoryId);
      print('Subcategory IDs: $subcategoryIds');

      final allCategoryIds = [categoryId, ...subcategoryIds];
      print('All Category IDs: $allCategoryIds');

      final productStreams = allCategoryIds.map((id) {
        print('Querying products for ID: $id');
        return getIt<FirebaseFirestore>()
            .collection('products')
            .where('categoryId', isEqualTo: id)
            .snapshots()
            .map((snapshot) {
          print('Snapshot docs count for $id: ${snapshot.docs.length}');
          return _mapSnapshotToProducts(snapshot, id);
        });
      }).toList();

      // Sử dụng Rx.combineLatest để gộp tất cả Stream
      await for (final List<Either<Failure, List<ProductModel>>> combinedResults
      in Rx.combineLatestList(productStreams)) {
        final collectedProducts = <ProductModel>[];
        for (final eitherProducts in combinedResults) {
          eitherProducts.fold(
                (failure) => print('Stream failure: $failure'),
                (products) {
              print('Products in this stream: ${products.length}');
              collectedProducts.addAll(products);
            },
          );
        }

        print('Total collected products: ${collectedProducts.length}');
        if (collectedProducts.isNotEmpty) {
          yield Right<Failure, List<ProductModel>>(collectedProducts);
        } else {
          yield Left<Failure, List<ProductModel>>(
              ServerFailure('No products found for category $categoryId'));
        }
      }
    } catch (e) {
      print('Error in fetchProductsByCategoryId: $e');
      yield Left<Failure, List<ProductModel>>(
          ServerFailure('Error fetching products for category $categoryId: $e'));
    }
  }

  Future<List<String>> _fetchSubcategoryIdsSafely(String categoryId) async {
    try {
      final snapshot = await getIt<FirebaseFirestore>()
          .collection('categories')
          .where('parentId', isEqualTo: categoryId)
          .get();

      print('Subcategory snapshot docs: ${snapshot.docs.length}');
      final subcategoryIds = snapshot.docs.map((doc) {
        print('Subcategory doc ID: ${doc.id}, Data: ${doc.data()}');
        return doc.id;
      }).toList();

      return subcategoryIds;
    } on FirebaseException catch (e) {
      print('Firebase error fetching subcategories: ${e.code} - ${e.message}');
      return [];
    } catch (e) {
      print('Unexpected error fetching subcategories: $e');
      return [];
    }
  }

  Either<Failure, List<ProductModel>> _mapSnapshotToProducts(
      QuerySnapshot snapshot, String categoryId) {
    try {
      final products = snapshot.docs.map((doc) {
        print('Product doc ID: ${doc.id}, Data: ${doc.data()}');
        return ProductModel.fromSnapshot(doc);
      }).toList();

      print('Mapped products count: ${products.length}');
      return Right<Failure, List<ProductModel>>(products);
    } catch (e) {
      print('Error mapping products for categoryId $categoryId: $e');
      return Left<Failure, List<ProductModel>>(
          ServerFailure('Error processing products for category $categoryId: $e'));
    }
  }
}