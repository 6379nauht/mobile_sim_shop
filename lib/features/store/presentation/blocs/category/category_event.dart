import 'package:equatable/equatable.dart';

abstract class CategoryEvent extends Equatable {
  const CategoryEvent();

  @override
  List<Object?> get props => [];
}

class LoadCategories extends CategoryEvent{}
class FetchSubcategories extends CategoryEvent {
  final String parentId;
  const FetchSubcategories({required this.parentId});
  @override
  List<Object?> get props => [parentId];
}

class ResetCategoryState extends CategoryEvent {}