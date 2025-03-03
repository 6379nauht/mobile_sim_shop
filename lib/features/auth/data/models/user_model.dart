import 'package:mobile_sim_shop/core/utils/formatter/formatter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  });

  //Helper func to get the full name
  String get fullName => '$firstName $lastName';

  //Helper func to format phone number
  String get formattedPhoneNo => AppFormatter.formatPhoneNumber(phoneNumber);

  //Static func to split full name into first and last name
  static List<String> nameParts(fullName) => fullName.split(" ");

  //Static func to generate a username from full name
  static String generateUsername(fullName) {
    List<String> nameParts = fullName.split(" ");
    String firstName = nameParts[0].toLowerCase();
    String lastName = nameParts.length > 1 ? nameParts[1].toLowerCase() : "";

    String camelCaseUsername = "$firstName$lastName";
    String usernameWithPrefix = "cwt_$camelCaseUsername"; //add "cwt_" Prefix
    return usernameWithPrefix;
  }

  //Static func to create an empty user model.
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

  //Convert model to JSON structure for storing data in Firebase
  Map<String, dynamic> toJson() {
    return {
      'FirstName': firstName,
      'LastName': lastName,
      'UserName': username,
      'Email': email,
      'PhoneNumber': phoneNumber,
      'ProfilePicture': profilePicture,
    };
  }

  //Factory method to create a UserModel from a firebase document snapshot.
  factory UserModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data();

    if (data == null) {
      throw Exception("Document snapshot is null or does not exist");
    }

    return UserModel(
      id: document.id, // Firestore tự động sinh ID
      firstName: data['firstName'] ?? '',
      lastName: data['lastName'] ?? '',
      username: data['username'] ?? '',
      email: data['email'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      profilePicture: data['profilePicture'] ?? '',
      password: '',
    );
  }


}
