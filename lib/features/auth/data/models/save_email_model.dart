class SaveEmailModel {
  bool? remember;
  String? email;
  SaveEmailModel({
    this.remember,
    this.email
  });

  factory SaveEmailModel.fromJson(Map<String, dynamic> json) {
    return SaveEmailModel(
      email: json["email"] ?? '',
      remember: json["remember"] ?? false,
    );
  }
}