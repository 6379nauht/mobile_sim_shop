abstract class Failure {
  final String message;
  Failure(this.message);
}

class AuthFailure extends Failure {
  AuthFailure(super.message);
}

class ServerFailure extends Failure {
  ServerFailure(super.message);
}

class EmailVerificationRequiredFailure extends Failure {
  EmailVerificationRequiredFailure(super.message);

}
