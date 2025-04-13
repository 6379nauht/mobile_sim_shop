import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mobile_sim_shop/features/store/data/models/search_product_params.dart';
import 'package:mobile_sim_shop/features/store/domain/entities/product.dart';
import 'package:mobile_sim_shop/features/store/domain/usecases/fetch_suggestions_usecase.dart';
import 'package:mobile_sim_shop/features/store/domain/usecases/search_product_usecase.dart';
import 'package:mobile_sim_shop/features/store/presentation/blocs/search/search_event.dart';
import 'package:mobile_sim_shop/features/store/presentation/blocs/search/search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchProductUsecase _searchProductUsecase;
  final FetchSuggestionsUsecase _fetchSuggestionsUsecase;
  SearchBloc(this._searchProductUsecase, this._fetchSuggestionsUsecase) : super(const SearchState()) {
    on<SearchProductsEvent>(_onSearchProductEvent);
    on<ClearResultSearch>(_onClearResultSearch);
    on<FetchSuggestionsEvent>(_onFetchSuggestionsEvent);
  }

  Future<void> _onSearchProductEvent(
      SearchProductsEvent event, Emitter<SearchState> emit) async {
    emit(state.copyWith(status: SearchStatus.loading));
    // Kiểm tra tính hợp lệ của giá
    if (event.minPrice != null && event.minPrice! <= 0) {
      emit(state.copyWith(
        status: SearchStatus.failure,
        errorMessage: 'Giá tối thiểu phải lớn hơn 0',
      ));
      return;
    }

    if (event.maxPrice != null && event.maxPrice! <= 0) {
      emit(state.copyWith(
        status: SearchStatus.failure,
        errorMessage: 'Giá tối đa phải lớn hơn 0',
      ));
      return;
    }

    if (event.minPrice != null &&
        event.maxPrice != null &&
        event.minPrice! >= event.maxPrice!) {
      emit(state.copyWith(
        status: SearchStatus.failure,
        errorMessage: 'Giá tối thiểu phải nhỏ hơn giá tối đa',
      ));
      return;
    }
    try {
      final result = await _searchProductUsecase.call(
          params: SearchProductParams(
              query: event.query,
              sort: event.sort,
              categories: event.categories,
              minPrice: event.minPrice,
              maxPrice: event.maxPrice));
      result.fold(
          (failure) => emit(state.copyWith(
              status: SearchStatus.failure, errorMessage: failure)),
          (products) => emit(state.copyWith(
              status: SearchStatus.success, products: products)));
    } catch (e) {
      emit(state.copyWith(status: SearchStatus.failure, errorMessage: 'Lỗi giá trị'));
    }
  }

  FutureOr<void> _onClearResultSearch(ClearResultSearch event, Emitter<SearchState> emit) {
  emit(state.copyWith(status: SearchStatus.initial, products: []));
  }

  Future<void> _onFetchSuggestionsEvent(FetchSuggestionsEvent event, Emitter<SearchState> emit) async {
    emit(state.copyWith(status: SearchStatus.loading));
    try {
      final result = await _fetchSuggestionsUsecase.call(params: event.query);
      result.fold(
            (failure) => emit(state.copyWith(status: SearchStatus.failure, errorMessage: failure)),
            (suggestions) => emit(state.copyWith(status: SearchStatus.success, suggestions: suggestions)),
      );
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Lỗi lấy gợi ý: $e'));
    }
  }
}
