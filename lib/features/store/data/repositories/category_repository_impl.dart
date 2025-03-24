import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:mobile_sim_shop/core/dependency_injection/locator.dart';
import 'package:mobile_sim_shop/core/errors/failures.dart';
import 'package:mobile_sim_shop/features/store/data/models/category_model.dart';
import 'package:mobile_sim_shop/features/store/data/sources/category_firebase_service.dart';
import 'package:mobile_sim_shop/features/store/domain/repositories/category_repository.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryFirebaseService _firebaseService = getIt<CategoryFirebaseService>();
  @override
  Future<Either<Failure, List<CategoryModel>>> getAllCategories() async {
   return await _firebaseService.getAllCategories();
  }

}