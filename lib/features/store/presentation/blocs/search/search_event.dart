import 'package:equatable/equatable.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object?> get props => [];
}

class SearchProductsEvent extends SearchEvent {
  final String query;
  final String? sort;
  final List<String>? categories;
  final double? minPrice;
  final double? maxPrice;

  const SearchProductsEvent({
    required this.query,
    this.sort,
    this.categories,
    this.minPrice,
    this.maxPrice,
  });

  @override
  List<Object?> get props => [query, sort, categories, minPrice, maxPrice];
}

class ClearResultSearch extends SearchEvent{}

class FetchSuggestionsEvent extends SearchEvent {
  final String query;

  const FetchSuggestionsEvent(this.query);

  @override
  List<Object?> get props => [query];
}