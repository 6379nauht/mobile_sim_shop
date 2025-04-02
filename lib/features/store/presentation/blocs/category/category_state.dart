import 'package:equatable/equatable.dart';
import 'package:mobile_sim_shop/features/store/data/models/category_model.dart';

enum CategoryStatus {initial, loading, success, failure}
class CategoryState extends Equatable {
  final CategoryStatus status;
  final String? errorMessage;
  final List<CategoryModel> categories;
  final List<CategoryModel> subCategories;
  const CategoryState({
    this.status = CategoryStatus.initial,
    this.errorMessage,
    this.categories = const [],
    this.subCategories = const []
});

  CategoryState copyWith ({
    CategoryStatus? status,
    List<CategoryModel>? categories,
    List<CategoryModel>? subCategories,
    String? errorMessage
}) {
    return CategoryState(
      status: status ?? this.status,
      categories: categories ?? this.categories,
      errorMessage: errorMessage ?? this.errorMessage,
      subCategories: subCategories ?? this.subCategories
    );
  }

  @override
  List<Object?> get props => [status, errorMessage, categories, subCategories];
  }