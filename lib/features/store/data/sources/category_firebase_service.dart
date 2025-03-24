import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/dependency_injection/locator.dart';
import '../../../../core/errors/failures.dart';
import '../models/category_model.dart';

abstract class CategoryFirebaseService {
  Future<Either<Failure, List<CategoryModel>>>getAllCategories();
}

class CategoryFirebaseServiceImpl implements CategoryFirebaseService {
  @override
  Future<Either<Failure, List<CategoryModel>>> getAllCategories() async{
    try {
      // Truy vấn collection 'categories' từ Firestore
      final querySnapshot = await getIt<FirebaseFirestore>().collection('categories').get();

      // Chuyển đổi danh sách documents thành danh sách CategoryModel
      final categories = querySnapshot.docs
          .map((doc) => CategoryModel.fromSnapshot(doc))
          .toList();

      // Trả về kết quả thành công với Right
      return Right(categories);
    } on FirebaseException catch (e) {
      // Xử lý lỗi từ Firestore
      return Left(ServerFailure('Lỗi Firestore: ${e.message}'));
    } on Exception catch (e) {
      // Xử lý lỗi chung
      return Left(ServerFailure('Đã xảy ra lỗi: $e'));
    }
  }

}