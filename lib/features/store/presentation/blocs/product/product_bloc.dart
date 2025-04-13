import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_sim_shop/core/errors/failures.dart';
import 'package:mobile_sim_shop/core/usecase/no_params.dart';
import 'package:mobile_sim_shop/features/store/data/models/product_model.dart';
import 'package:mobile_sim_shop/features/store/domain/usecases/fetch_all_brands_usecase.dart';
import 'package:mobile_sim_shop/features/store/domain/usecases/fetch_all_products_usecase.dart';
import 'package:mobile_sim_shop/features/store/domain/usecases/fetch_brand_by_id_usecase.dart';
import 'package:mobile_sim_shop/features/store/domain/usecases/fetch_product_by_category_usecase.dart';
import 'package:mobile_sim_shop/features/store/domain/usecases/fetch_product_by_id_usecase.dart';
import 'package:mobile_sim_shop/features/store/domain/usecases/fetch_variation_by_product_id_usecase.dart';
import 'package:mobile_sim_shop/features/store/domain/usecases/filter_products_usecase.dart';
import 'package:mobile_sim_shop/features/store/presentation/blocs/product/product_event.dart';
import 'package:mobile_sim_shop/features/store/presentation/blocs/product/product_state.dart';

import '../../../../../core/utils/constants/image_strings.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final FetchAllProductsUsecase _fetchAllProductsUsecase;
  final FetchProductByIdUsecase _fetchProductByIdUsecase;
  final FetchAllBrandsUsecase _fetchAllBrandsUsecase;
  final FetchBrandByIdUsecase _fetchBrandByIdUsecase;
  final FetchVariationByProductIdUsecase _fetchVariationByProductIdUsecase;
  final FilterProductsUsecase _filterProductsUsecase;
  final FetchProductByCategoryIdUsecase _fetchProductByCategoryIdUsecase;
  ProductBloc(
      this._fetchAllProductsUsecase,
      this._fetchProductByIdUsecase,
      this._fetchAllBrandsUsecase,
      this._fetchBrandByIdUsecase,
      this._fetchVariationByProductIdUsecase,
      this._filterProductsUsecase,
      this._fetchProductByCategoryIdUsecase)
      : super(const ProductState()) {
    on<FetchAllProducts>(_onFetchAllProducts);
    on<FetchProductById>(_onFetchProductById);
    on<FetchAllBrands>(_onFetchAllBrands);
    on<FetchBrandById>(_onFetchBrandById);
    on<FetchVariationsByProductId>(_onFetchVariationsByProductId);
    on<FilterProducts>(_onFilterProducts);
    on<FetchProductByCategoryId>(_onFetchProductByCategoryId);
    on<ResetProductState>(_onResetProductState);
    on<SelectVariation>(_onSelectVariation);
    on<ResetSelectedVariations>(_onResetSelectedVariations);

  }
// Các phương thức hiện có giữ nguyên, chỉ thêm phương thức mới
  Future<void> _onSelectVariation(SelectVariation event, Emitter<ProductState> emit) async {
    final newSelectedVariations = Map<String, String>.from(state.selectedVariations);
    if (event.value == null) {
      newSelectedVariations.remove(event.attributeName); // Bỏ chọn
    } else {
      newSelectedVariations[event.attributeName] = event.value!; // Cập nhật lựa chọn
    }
    emit(state.copyWith(selectedVariations: newSelectedVariations));
  }

  Future<void> _onFetchAllProducts(
      FetchAllProducts event, Emitter<ProductState> emit) async {
    emit(state.copyWith(status: ProductStatus.loading));
    try {
      await for (final either
          in _fetchAllProductsUsecase.call(params: NoParams())) {
        either.fold(
          (failure) => emit(state.copyWith(
              status: ProductStatus.failure, errorMessage: failure.message)),
          (products) => emit(state.copyWith(
              status: ProductStatus.success, products: products)),
        );
      }
    } catch (e) {
      emit(state.copyWith(
          status: ProductStatus.failure,
          errorMessage: 'Lỗi: fetch all products'));
    }
  }

  Future<void> _onFetchProductById(
      FetchProductById event, Emitter<ProductState> emit) async {
    emit(state.copyWith(status: ProductStatus.loading));
    try {
      await for (final either
          in _fetchProductByIdUsecase.call(params: event.productId)) {
        either.fold(
          (failure) => emit(state.copyWith(
              status: ProductStatus.failure, errorMessage: failure.message)),
          (product) => emit(
              state.copyWith(status: ProductStatus.success, product: product)),
        );
      }
    } catch (e) {
      emit(state.copyWith(
          status: ProductStatus.failure,
          errorMessage: 'Lỗi: fetch product by id'));
    }
  }

  Future<void> _onFetchAllBrands(
      FetchAllBrands event, Emitter<ProductState> emit) async {
    emit(state.copyWith(status: ProductStatus.loading));
    try {
      await for (final either in _fetchAllBrandsUsecase.call()) {
        either.fold(
          (failure) => emit(state.copyWith(
              status: ProductStatus.failure, errorMessage: failure.message)),
          (brands) => emit(
              state.copyWith(status: ProductStatus.success, brands: brands)),
        );
      }
    } catch (e) {
      emit(state.copyWith(
          status: ProductStatus.failure,
          errorMessage: 'Lỗi: fetch all brands'));
    }
  }

  Future<void> _onFetchBrandById(
      FetchBrandById event, Emitter<ProductState> emit) async {
    emit(state.copyWith(status: ProductStatus.loading));
    try {
      final either = await _fetchBrandByIdUsecase.call(params: event.brandId);
      either.fold(
            (failure) => emit(state.copyWith(
          status: ProductStatus.failure,
          errorMessage: failure.message,
        )),
            (brand) => emit(state.copyWith(
          status: ProductStatus.success,
          brand: brand,
        )),
      );
    } catch (e) {
      emit(state.copyWith(
        status: ProductStatus.failure,
        errorMessage: 'Lỗi: fetch brand by id',
      ));
    }
  }


  Future<void> _onFetchVariationsByProductId(
      FetchVariationsByProductId event, Emitter<ProductState> emit) async {
    emit(state.copyWith(status: ProductStatus.loading));
    try {
      await for (final either
          in _fetchVariationByProductIdUsecase.call(params: event.productId)) {
        either.fold(
          (failure) => emit(state.copyWith(
              status: ProductStatus.failure, errorMessage: failure.message)),
          (productVariation) => emit(state.copyWith(
              status: ProductStatus.success,
              productVariation: productVariation)),
        );
      }
    } catch (e) {
      emit(state.copyWith(
          status: ProductStatus.failure,
          errorMessage: 'Lỗi: fetch product variation by id'));
    }
  }


  Future<void> _onFilterProducts(
      FilterProducts event, Emitter<ProductState> emit) async {
    emit(state.copyWith(status: ProductStatus.loading));
    try {
      await for (final result
          in _filterProductsUsecase.call(params: event.filterOption)) {
        result.fold(
          (failure) => emit(state.copyWith(
              status: ProductStatus.failure, errorMessage: failure.message)),
          (products) {
            final parts = event.filterOption.split('|');
            final categoryId = parts[0];
            final brandId = parts[1];

            // Cập nhật state dựa trên điều kiện lọc
            emit(state.copyWith(
              status: ProductStatus.success,
              filterProducts: products, // Luôn cập nhật filterProducts
              products: (categoryId == 'All' && brandId == 'All')
                  ? products // Nếu không lọc, cập nhật cả products
                  : state.products, // Giữ nguyên products nếu có lọc
            ));
          },
        );
      }
    } catch (e) {
      emit(state.copyWith(
          status: ProductStatus.failure, errorMessage: e.toString()));
    }
  }
  Future<void> _onFetchProductByCategoryId(
      FetchProductByCategoryId event, Emitter<ProductState> emit) async {
    emit(state.copyWith(status: ProductStatus.loading));
    try {
      await for (final result
      in _fetchProductByCategoryIdUsecase.call(params: event.categoryId)) {
        result.fold(
                (failure) {
              print('Fetch Product Failure: ${failure.message}');
              emit(state.copyWith(
                status: ProductStatus.failure,
                errorMessage: failure.message,
              ));
            },
                (categoryProducts) {
              print('Fetched Products Count: ${categoryProducts.length}');
              print('First Product: ${categoryProducts.isNotEmpty ? categoryProducts.first.toJson() : "No Products"}');

              // Các bước xử lý còn lại như trước
              final brandIds = categoryProducts
                  .map((product) => product.brand!.id)
                  .toSet()
                  .toList();

              print('Brand IDs: $brandIds');

              final relatedBrands = state.brands
                  .where((brand) => brandIds.contains(brand.id))
                  .toList();

              print('Related Brands: $relatedBrands');

              final thumbnailImages = categoryProducts
                  .take(3)
                  .map((product) => (product.thumbnail?.isNotEmpty ?? false)
                  ? product.thumbnail.toString()
                  : AppImages.iphone13prm)
                  .toList()
                  .cast<String>();

              print('Thumbnail Images: $thumbnailImages');

              emit(state.copyWith(
                status: ProductStatus.success,
                categoryProducts: categoryProducts,
                relatedBrands: relatedBrands,
                thumbnailImages: thumbnailImages,
              ));
            }
        );
      }
    } catch (e) {
      print('Error in Fetch Product: $e');
      emit(state.copyWith(
          status: ProductStatus.failure, errorMessage: e.toString()));
    }
  }

  FutureOr<void> _onResetProductState(ResetProductState event, Emitter<ProductState> emit) {
    emit(state.copyWith(status: ProductStatus.initial));
  }

  FutureOr<void> _onResetSelectedVariations(ResetSelectedVariations event, Emitter<ProductState> emit) {
  emit(state.copyWith(selectedVariations: {}));

  }
}
