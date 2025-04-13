import 'package:equatable/equatable.dart';
import 'package:mobile_sim_shop/features/store/data/models/product_model.dart';

enum SearchStatus {initial, loading, success, failure}
class SearchState extends Equatable {

  final List<ProductModel> products;
  final String? errorMessage;
  final SearchStatus status;
  final List<String> searchHistory; // Lịch sử tìm kiếm
  final List<String> suggestions;
  const SearchState({
    this.products = const [],
    this.errorMessage,
    this.searchHistory = const [],
    this.suggestions = const [],
    this.status = SearchStatus.initial
});
  SearchState copyWith ({
    String? errorMessage,
    List<ProductModel>? products,
    SearchStatus? status,
    final List<String>? searchHistory,
    final List<String>? suggestions
}) {
    return SearchState(
      errorMessage: errorMessage ?? this.errorMessage,
      products: products ?? this.products,
      status: status ?? this.status,
        searchHistory: searchHistory ?? this.searchHistory,
      suggestions: suggestions ?? this.suggestions
    );
  }

  @override
  List<Object?> get props => [errorMessage, status, products, searchHistory, suggestions];

}