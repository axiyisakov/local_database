class ProfileModel {
  String? email;
  String? password;
  ProfileModel({required this.email, required this.password});

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(email: json['email'], password: json['password']);
  }

  ProfileModel copyWith({String? email, String? password}) => ProfileModel(
      email: email ?? this.email, password: password ?? this.password);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> dataJson = {'email': email, 'password': password};
    return dataJson;
  }
}
