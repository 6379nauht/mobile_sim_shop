
class User {
  final String id;
  String firstName;
  String lastName;
  final String username;
  String password;
  final String email;
  String phoneNumber;
  String profilePicture;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.password,
    required this.email,
    required this.phoneNumber,
    required this.profilePicture
  });
}