abstract class UseCase<Type, Params> {
  Future<Type> call({Params params});
}

abstract class UsecaseStream<Type, Params> {
  Stream<Type> call({Params params});
}