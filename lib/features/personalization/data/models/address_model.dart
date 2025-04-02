import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/address.dart';

class AddressModel extends Address {
  AddressModel({
    required super.id,
    required super.name,
    required super.phoneNumber,
    required super.hamlet,
    required super.commune,
    required super.district,
    required super.province,
    required super.country,
    super.latitude,
    super.longitude,
    required super.fullAddress,
    super.dateTime,
    super.selectedAddress = false,
  });

  // Tạo một AddressModel rỗng
  static AddressModel empty() => AddressModel(
    id: '',
    name: '',
    phoneNumber: '',
    hamlet: '',
    commune: '',
    district: '',
    province: '',
    country: '',
    fullAddress: '',
  );

  // Chuyển đổi sang JSON để lưu vào Firestore
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phoneNumber': phoneNumber,
      'hamlet': hamlet,
      'commune': commune,
      'district': district,
      'province': province,
      'country': country,
      'latitude': latitude,
      'longitude': longitude,
      'fullAddress': fullAddress,
      'dateTime': dateTime?.toIso8601String(),
      'selectedAddress': selectedAddress,
    };
  }

  // Tạo từ Map (JSON)
  factory AddressModel.fromJson(Map<String, dynamic> document) {
    final data = document;
    if (data.isEmpty) return AddressModel.empty();
    return AddressModel(
      id: data['id'] ?? '',
      name: data['name'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      hamlet: data['hamlet'] ?? '',
      commune: data['commune'] ?? '',
      district: data['district'] ?? '',
      province: data['province'] ?? '',
      country: data['country'] ?? '',
      latitude: data['latitude'] as double?,
      longitude: data['longitude'] as double?,
      fullAddress: data['fullAddress'] ?? '',
      dateTime: data['dateTime'] != null ? DateTime.parse(data['dateTime']) : null,
      selectedAddress: data['selectedAddress'] ?? true,
    );
  }

  // Tạo từ Firestore DocumentSnapshot
  factory AddressModel.fromSnapshot(DocumentSnapshot<Object?> snapshot) {
    if (!snapshot.exists) return AddressModel.empty();
    final data = snapshot.data() as Map<String, dynamic>?;
    if (data == null || data.isEmpty) return AddressModel.empty();
    return AddressModel(
      id: snapshot.id,
      name: data['name'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      hamlet: data['hamlet'] ?? '',
      commune: data['commune'] ?? '',
      district: data['district'] ?? '',
      province: data['province'] ?? '',
      country: data['country'] ?? '',
      latitude: data['latitude'] as double?,
      longitude: data['longitude'] as double?,
      fullAddress: data['fullAddress'] ?? '',
      dateTime: data['dateTime'] != null ? DateTime.parse(data['dateTime']) : null,
      selectedAddress: data['selectedAddress'] ?? true,
    );
  }

  AddressModel copyWith({
    String? id,
    String? name,
    String? phoneNumber,
    String? hamlet,
    String? commune,
    String? district,
    String? province,
    String? country,
    double? latitude,
    double? longitude,
    String? fullAddress,
    DateTime? dateTime,
    bool? selectedAddress
  }) {
    return AddressModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      hamlet: hamlet ?? this.hamlet,
      commune: commune ?? this.commune,
      district: district ?? this.district,
      province: province ?? this.province,
      country: country ?? this.country,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      fullAddress: fullAddress ?? this.fullAddress,
      dateTime: dateTime ?? this.dateTime,
      selectedAddress: selectedAddress ?? this.selectedAddress
    );
  }
}