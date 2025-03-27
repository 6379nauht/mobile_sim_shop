import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_sim_shop/core/usecase/no_params.dart';
import 'package:mobile_sim_shop/features/store/domain/usecases/get_all_categories_usecase.dart';
import 'package:mobile_sim_shop/features/store/presentation/blocs/category/category_event.dart';
import 'package:mobile_sim_shop/features/store/presentation/blocs/category/category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final GetAllCategoriesUsecase _getAllCategoriesUsecase;
  CategoryBloc(this._getAllCategoriesUsecase) : super(const CategoryState()) {
    on<LoadCategories>(_onLoadCategories);
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
}
