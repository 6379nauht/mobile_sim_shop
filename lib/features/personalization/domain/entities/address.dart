class Address {
  final String id;
  final String name;
  final String phoneNumber;
  final String hamlet; // Ấp/Khu phố
  final String commune; // Xã/Phường
  final String district; // Huyện/Quận
  final String province; // Tỉnh/Thành phố
  final String country; // Đất nước
  final double? latitude;
  final double? longitude;
  final String fullAddress;
  final DateTime? dateTime;
  final bool selectedAddress;

  Address({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.hamlet,
    required this.commune,
    required this.district,
    required this.province,
    required this.country,
    this.latitude,
    this.longitude,
    required this.fullAddress,
    this.dateTime,
    this.selectedAddress = true,
  });
}