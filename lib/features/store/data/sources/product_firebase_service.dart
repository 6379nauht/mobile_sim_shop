import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_sim_shop/features/store/data/models/fetch_variation_params.dart';
import 'package:mobile_sim_shop/features/store/data/models/get_variation_id_attributes_params.dart';
import 'package:rxdart/rxdart.dart';
import 'package:typesense/typesense.dart';
import '../../../../core/dependency_injection/locator.dart';
import '../../../../core/errors/failures.dart';
import '../models/brand_model.dart';
import '../models/product_model.dart';
import '../models/product_variation_model.dart';
import '../models/search_product_params.dart';

abstract class ProductFirebaseService {
  Stream<Either<Failure, List<ProductModel>>> fetchAllProducts();
  Stream<Either<Failure, ProductModel?>> fetchProductById(String productId);

  Stream<Either<Failure, List<BrandModel>>> fetchAllBrands();
  Future<Either<Failure, BrandModel?>> fetchBrandById(String brandId);
  Stream<Either<Failure, List<ProductVariationModel>>>
      fetchVariationByProductId(String productId);
  Stream<Either<Failure, List<ProductModel>>> filterProducts(
      String filterOption);
  Stream<Either<Failure, List<ProductModel>>> fetchProductsByCategoryId(
      String categoryId);

  Future<Either<Failure, String?>> getVariationIdFromAttributes(
      GetVariationIdAttributesParams params);
  Future<Either<Failure, ProductVariationModel>> fetchVariation(
      FetchVariationParams params);
  Future<Either<Failure, List<ProductModel>>> searchProducts(
      SearchProductParams? params);
  Future<Either<Failure, List<String>>> fetchSuggestions(String query);
}

class ProductFirebaseServiceImpl implements ProductFirebaseService {
  final Client typesenseClient;
  final String geminiApiKey = dotenv.env['Gemini_API_KEY'] ?? '';

  ProductFirebaseServiceImpl(this.typesenseClient);

  @override
  Stream<Either<Failure, List<BrandModel>>> fetchAllBrands() {
    final Stream<Either<Failure, List<BrandModel>>> stream =
        getIt<FirebaseFirestore>()
            .collection('brands')
            .snapshots()
            .map((snapshot) {
      try {
        final brands =
            snapshot.docs.map((doc) => BrandModel.fromSnapshot(doc)).toList();
        return Right<Failure, List<BrandModel>>(brands);
      } catch (e) {
        return Left<Failure, List<BrandModel>>(
            ServerFailure('Error streaming products: $e'));
      }
    }).handleError((e) {
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
        final products =
            snapshot.docs.map((doc) => ProductModel.fromSnapshot(doc)).toList();
        return Right<Failure, List<ProductModel>>(products);
      } catch (e) {
        return Left<Failure, List<ProductModel>>(
            ServerFailure('Error streaming products: $e'));
      }
    }).handleError((e) {
      return Left<Failure, List<ProductModel>>(
          ServerFailure('Stream error: $e'));
    });
    return stream;
  }

  @override
  Future<Either<Failure, BrandModel?>> fetchBrandById(String brandId) async {
    try {
      final docSnapshot = await getIt<FirebaseFirestore>()
          .collection('brands')
          .doc(brandId)
          .get();

      if (docSnapshot.exists) {
        final brand = BrandModel.fromSnapshot(docSnapshot);
        return Right(brand);
      } else {
        return const Right(null); // Không có brand
      }
    } catch (e) {
      return Left(ServerFailure('Error fetching brand: $e'));
    }
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
        return Left<Failure, ProductModel?>(
            ServerFailure('Error streaming product: $e'));
      }
    }).handleError((e) {
      return Left<Failure, ProductModel?>(ServerFailure('Stream error: $e'));
    });
    return stream;
  }

  @override
  Stream<Either<Failure, List<ProductVariationModel>>>
      fetchVariationByProductId(String productId) {
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
        return Left<Failure, List<ProductVariationModel>>(
            ServerFailure('Error streaming variations: $e'));
      }
    }).handleError((e) {
      return Left<Failure, List<ProductVariationModel>>(
          ServerFailure('Stream error: $e'));
    });
    return stream;
  }

  @override
  Stream<Either<Failure, List<ProductModel>>> filterProducts(
      String filterOption) async* {
    try {
      final parts = filterOption.split('|');
      final categoryId =
          parts.isNotEmpty && parts[0].isNotEmpty ? parts[0] : 'All';
      final brandId =
          parts.length > 1 && parts[1].isNotEmpty ? parts[1] : 'All';
      final sortOption =
          parts.length > 2 && parts[2].isNotEmpty ? parts[2] : 'Name';

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
              )
                  .snapshots()
                  .map((snapshot) => _mapSnapshotToProducts(snapshot, 'All')),
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
  Stream<Either<Failure, List<ProductModel>>> fetchProductsByCategoryId(
      String categoryId) async* {
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
      yield Left<Failure, List<ProductModel>>(ServerFailure(
          'Error fetching products for category $categoryId: $e'));
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
      return Left<Failure, List<ProductModel>>(ServerFailure(
          'Error processing products for category $categoryId: $e'));
    }
  }

  @override
  Future<Either<Failure, String?>> getVariationIdFromAttributes(
      GetVariationIdAttributesParams params) async {
    try {
      print("Product ID: ${params.productId}");
      print("Selected Variations: ${params.selectedVariations}");

      // Truy vấn collection productVariations với điều kiện productId
      final variationsSnapshot = await getIt<FirebaseFirestore>()
          .collection('productVariations')
          .where('productId', isEqualTo: params.productId)
          .get();

      print("Số biến thể tìm thấy: ${variationsSnapshot.docs.length}");
      if (variationsSnapshot.docs.isEmpty) {
        print("Không có biến thể nào khớp với productId");
        return const Right(null);
      }

      // Duyệt qua các variation để tìm attributeValues khớp
      for (var doc in variationsSnapshot.docs) {
        final variation = ProductVariationModel.fromSnapshot(doc);
        print(
            "Variation ID: ${variation.id}, Attributes: ${variation.attributeValues}");

        // Kiểm tra xem attributeValues của variation có khớp với selectedVariations không
        if (variation.attributeValues.length ==
                params.selectedVariations.length &&
            variation.attributeValues.entries.every(
              (entry) =>
                  params.selectedVariations.containsKey(entry.key) &&
                  params.selectedVariations[entry.key] == entry.value,
            )) {
          print("Tìm thấy biến thể khớp: ${variation.id}");
          return Right(variation.id);
        }
      }

      print("Không tìm thấy biến thể khớp với selectedVariations");
      return const Right(null);
    } catch (e) {
      print("Lỗi: $e");
      return Left(ServerFailure('Lỗi truy vấn: $e'));
    }
  }

  @override
  Future<Either<Failure, ProductVariationModel>> fetchVariation(
      FetchVariationParams params) async {
    try {
      // Xác thực tham số trước khi truy vấn
      if (params.variationId.isEmpty || params.productId.isEmpty) {
        return Left(ServerFailure('Variation ID hoặc Product ID không hợp lệ'));
      }

      // Sử dụng truy vấn với limit(1) vì chúng ta chỉ mong đợi một tài liệu khớp
      final querySnapshot = await getIt<FirebaseFirestore>()
          .collection('productVariations')
          .where('id', isEqualTo: params.variationId)
          .limit(1)
          .get();

      // Kiểm tra xem tài liệu có tồn tại không
      if (querySnapshot.docs.isEmpty) {
        return Left(ServerFailure('Biến thể không tồn tại'));
      }

      // Lấy tài liệu đầu tiên (và duy nhất)
      final variation =
          ProductVariationModel.fromSnapshot(querySnapshot.docs.first);

      // Xác minh quyền sở hữu sản phẩm
      if (variation.productId != params.productId) {
        return Left(ServerFailure('Biến thể không thuộc sản phẩm này'));
      }

      return Right(variation);
    } on FirebaseException catch (e) {
      return Left(ServerFailure('Lỗi Firebase: ${e.message}'));
    } on FormatException catch (e) {
      return Left(ServerFailure('Lỗi định dạng dữ liệu: $e'));
    } catch (e) {
      return Left(ServerFailure('Lỗi không xác định khi lấy biến thể: $e'));
    }
  }

  @override
  Future<Either<Failure, List<ProductModel>>> searchProducts(
      SearchProductParams? params) async {
    try {
      final searchParams = params ?? SearchProductParams(query: '*');
      final typesenseParams = {
        'q': searchParams.query,
        'query_by': 'title,description',
        'per_page': '50',
      };

      // Xử lý sort
      if (searchParams.sort != null) {
        switch (searchParams.sort) {
          case 'name':
            typesenseParams['sort_by'] = 'title:asc';
            break;
          case 'popular':
            typesenseParams['sort_by'] = 'stock:desc';
            break;
          case 'newest':
            typesenseParams['sort_by'] = 'date:desc';
            break;
          case 'lowest_price':
            typesenseParams['sort_by'] = 'price:asc';
            break;
          case 'highest_price':
            typesenseParams['sort_by'] = 'price:desc';
            break;
          case 'suitable':
            typesenseParams['sort_by'] = 'isFeatured:desc';
            break;
        }
      }

      final filters = <String>[];

      // Xử lý categories
      List<String> allCategoryIds = [];
      if (searchParams.categories != null && searchParams.categories!.isNotEmpty) {
        allCategoryIds.addAll(searchParams.categories!);
        // Nếu có categoryId = '1', lấy thêm các danh mục con
        if (searchParams.categories!.contains('1')) {
          final subcategoryIds = await _fetchSubcategoryIdsSafely('1');
          allCategoryIds.addAll(subcategoryIds);
        }
      }

      if (allCategoryIds.isNotEmpty) {
        filters.add('categoryId:[${allCategoryIds.join(',')}]');
      }

      // Xử lý giá
      if (searchParams.minPrice != null) {
        filters.add('price:>=${searchParams.minPrice}');
      }
      if (searchParams.maxPrice != null) {
        filters.add('price:<=${searchParams.maxPrice}');
      }

      if (filters.isNotEmpty) {
        typesenseParams['filter_by'] = filters.join(' && ');
      }

      print('Typesense Params: $typesenseParams');
      final response = await typesenseClient
          .collection('products')
          .documents
          .search(typesenseParams);
      final hits = response['hits'] as List<dynamic>? ?? [];
      return Right(hits
          .map((hit) =>
          ProductModel.fromJson(hit['document'] as Map<String, dynamic>))
          .toList());
    } catch (e) {
      return Left(ServerFailure('Error searching products: $e'));
    }
  }

  @override
  Future<Either<Failure, List<String>>> fetchSuggestions(String query) async {
    try {
      final uri = Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$geminiApiKey',
      );


      final body = jsonEncode({
        "contents": [
          {
            "parts": [
              {
                "text": 'Cung cấp 5 gợi ý tìm kiếm liên quan đến "$query" trong cửa hàng điện thoại di động.'
              }
            ]
          }
        ]
      });

      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final text = data["candidates"][0]["content"]["parts"][0]["text"];
        final matches = RegExp(r'\d+\.\s+(.*?)((?=\d+\.\s)|$)', dotAll: true)
            .allMatches(text);

        final suggestions = matches.map((m) => m.group(1)!.trim()).toList();
        print('📌 Suggestions: $suggestions');

        return Right(suggestions);
      } else {
        return Left(ServerFailure('Gemini API Error: ${response.statusCode}'));
      }
    } catch (e) {
      return Left(ServerFailure('Error calling Gemini API: $e'));
    }
  }
}
