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
import 'package:mobile_sim_shop/features/store/domain/usecases/fetch_product_by_id_usecase.dart';
import 'package:mobile_sim_shop/features/store/domain/usecases/fetch_product_with_details_usecase.dart';
import 'package:mobile_sim_shop/features/store/domain/usecases/fetch_variation_by_product_id_usecase.dart';
import 'package:mobile_sim_shop/features/store/domain/usecases/filter_products_usecase.dart';
import 'package:mobile_sim_shop/features/store/presentation/blocs/product/product_event.dart';
import 'package:mobile_sim_shop/features/store/presentation/blocs/product/product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final FetchAllProductsUsecase _fetchAllProductsUsecase;
  final FetchProductByIdUsecase _fetchProductByIdUsecase;
  final FetchAllBrandsUsecase _fetchAllBrandsUsecase;
  final FetchBrandByIdUsecase _fetchBrandByIdUsecase;
  final FetchProductWithDetailsUsecase _fetchProductWithDetailsUsecase;
  final FetchVariationByProductIdUsecase _fetchVariationByProductIdUsecase;
  final FilterProductsUsecase _filterProductsUsecase;
  ProductBloc(
      this._fetchAllProductsUsecase,
      this._fetchProductByIdUsecase,
      this._fetchAllBrandsUsecase,
      this._fetchBrandByIdUsecase,
      this._fetchProductWithDetailsUsecase,
      this._fetchVariationByProductIdUsecase,
      this._filterProductsUsecase)
      : super(const ProductState()) {
    on<FetchAllProducts>(_onFetchAllProducts);
    on<FetchProductById>(_onFetchProductById);
    on<FetchAllBrands>(_onFetchAllBrands);
    on<FetchBrandById>(_onFetchBrandById);
    on<FetchVariationsByProductId>(_onFetchVariationsByProductId);
    on<FetchProductWithDetails>(_onFetchProductWithDetails);
    on<FilterProducts>(_onFilterProducts);

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
      await for (final either
          in _fetchBrandByIdUsecase.call(params: event.brandId)) {
        either.fold(
          (failure) => emit(state.copyWith(
              status: ProductStatus.failure, errorMessage: failure.message)),
          (brand) =>
              emit(state.copyWith(status: ProductStatus.success, brand: brand)),
        );
      }
    } catch (e) {
      emit(state.copyWith(
          status: ProductStatus.failure,
          errorMessage: 'Lỗi: fetch brand by id'));
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

  Future<void> _onFetchProductWithDetails(
      FetchProductWithDetails event, Emitter<ProductState> emit) async {
    emit(state.copyWith(status: ProductStatus.loading));
    try {
      await for (final either
          in _fetchProductWithDetailsUsecase.call(params: event.productId)) {
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
          errorMessage: 'Lỗi: fetch product details'));
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
}
