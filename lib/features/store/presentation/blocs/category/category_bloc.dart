import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_sim_shop/core/usecase/no_params.dart';
import 'package:mobile_sim_shop/features/store/domain/usecases/fetch_subcategories_usecase.dart';
import 'package:mobile_sim_shop/features/store/domain/usecases/get_all_categories_usecase.dart';
import 'package:mobile_sim_shop/features/store/presentation/blocs/category/category_event.dart';
import 'package:mobile_sim_shop/features/store/presentation/blocs/category/category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final GetAllCategoriesUsecase _getAllCategoriesUsecase;
  final FetchSubCategoriesUsecase _fetchSubCategoriesUsecase;
  CategoryBloc(this._getAllCategoriesUsecase, this._fetchSubCategoriesUsecase)
      : super(const CategoryState()) {
    on<LoadCategories>(_onLoadCategories);
    on<FetchSubcategories>(_onFetchCategories);
    on<ResetCategoryState>(_onResetCategoryState);
  }

  Future<void> _onLoadCategories(
      LoadCategories event, Emitter<CategoryState> emit) async {
    emit(state.copyWith(status: CategoryStatus.loading));

    // Gọi service để lấy danh sách categories
    final result = await _getAllCategoriesUsecase.call(params: NoParams());

    // Xử lý kết quả với fold từ dartz
    result.fold(
        (failure) => emit(state.copyWith(
              status: CategoryStatus.failure,
              errorMessage: failure.message,
            )), (categories) {
      // Lọc categories với điều kiện isFeatured = true và parentId = null
      final filteredCategories = categories
          .where((category) => category.isFeatured && category.parentId == null)
          .toList();

      emit(state.copyWith(
        status: CategoryStatus.success,
        categories: filteredCategories,
      ));
    });
  }

  Future<void> _onFetchCategories(
      FetchSubcategories event, Emitter<CategoryState> emit) async {
    emit(state.copyWith(status: CategoryStatus.loading));
    await for (final result
        in _fetchSubCategoriesUsecase.call(params: event.parentId)) {
      try {
        result.fold(
            (failure) => emit(state.copyWith(
                status: CategoryStatus.failure, errorMessage: failure.message)),
            (subCategories) => emit(state.copyWith(
                status: CategoryStatus.success, subCategories: subCategories)));
      } catch (e) {
        emit(state.copyWith(
            status: CategoryStatus.failure,
            errorMessage: 'Lỗi server: ${e.toString()}'));
      }
    }
  }

  FutureOr<void> _onResetCategoryState(
      ResetCategoryState event, Emitter<CategoryState> emit) {
    emit(state.copyWith(status: CategoryStatus.initial));
  }
}
