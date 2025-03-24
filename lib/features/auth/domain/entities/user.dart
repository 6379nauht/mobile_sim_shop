class User {
  final String id;
  String firstName;
  String lastName;
  String username;
  String password;
  final String email;
  String phoneNumber;
  String profilePicture;
  final bool emailVerified;
  String? gender;
  String? birthDate;
  final String? deleteHash; // Thêm deleteHash
  User( {
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.password,
    required this.email,
    required this.phoneNumber,
    required this.profilePicture,
    required this.emailVerified,
    this.gender,
    this.birthDate,
    this.deleteHash,
  });
}
