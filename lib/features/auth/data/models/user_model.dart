import 'package:mobile_sim_shop/core/utils/formatter/formatter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile_sim_shop/features/personalization/data/models/address_model.dart';
import '../../domain/entities/user.dart';

class UserModel extends User {
  UserModel({
    required super.id,
    required super.firstName,
    required super.lastName,
    required super.username,
    required super.email,
    required super.phoneNumber,
    required super.profilePicture,
    required super.password,
    super.emailVerified = false,
    super.gender,
    super.birthDate,
    super.deleteHash,
  });

  // Helper func to get the full name
  String get fullName => '$firstName $lastName';

  // Helper func to format phone number
  String get formattedPhoneNo => AppFormatter.formatPhoneNumber(phoneNumber);

  // Static func to split full name into first and last name
  static List<String> nameParts(String fullName) => fullName.split(" ");

  // Static func to generate a username from full name
  static String generateUsername(String fullName) {
    List<String> parts = fullName.split(" ");
    String firstName = parts[0].toLowerCase();
    String lastName = parts.length > 1 ? parts[1].toLowerCase() : "";
    String camelCaseUsername = "$firstName$lastName";
    return "cwt_$camelCaseUsername"; // add "cwt_" prefix
  }

  // Static func to create an empty user model
  static UserModel empty() => UserModel(
    id: '',
    firstName: '',
    lastName: '',
    username: '',
    password: '',
    email: '',
    phoneNumber: '',
    profilePicture: '',
  );

  // Convert model to JSON structure for storing data in Firebase
  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'username': username,
      'email': email,
      'phoneNumber': phoneNumber,
      'profilePicture': profilePicture,
      'emailVerified': emailVerified,
      'gender': gender,
      'birthDate': birthDate,
      'deleteHash': deleteHash,
    };
  }

  // Factory method to create a UserModel from a Firebase document snapshot
  factory UserModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data();
    if (data == null) {
      throw Exception("Document snapshot is null or does not exist");
    }
    return UserModel(
      id: document.id,
      firstName: data['firstName'] ?? '',
      lastName: data['lastName'] ?? '',
      username: data['username'] ?? '',
      email: data['email'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      profilePicture: data['profilePicture'] ?? '',
      password: '',
      emailVerified: data['emailVerified'] ?? false,
      gender: data['gender'],
      birthDate: data['birthDate'],
      deleteHash: data['deleteHash'],
      // Lấy deleteHash từ Firesto
    );
  }

  // Phương thức copyWith
  UserModel copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? username,
    String? email,
    String? phoneNumber,
    String? profilePicture,
    String? password,
    bool? emailVerified,
    bool? phoneVerificationPending,
    String? gender,
    String? birthDate,
    String? deleteHash,
  }) {
    return UserModel(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      username: username ?? this.username,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profilePicture: profilePicture ?? this.profilePicture,
      password: password ?? this.password,
      emailVerified: emailVerified ?? this.emailVerified,
      gender: gender ?? this.gender,
      birthDate: birthDate ?? this.birthDate,
      deleteHash: deleteHash ?? this.deleteHash,
    );
  }
}