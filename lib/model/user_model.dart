class UserModel {
  String? name;
  int? age;
  String? id;
  String? email;
  UserModel(
      {required this.name,
      required this.age,
      required this.email,
      required this.id});
  UserModel.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        age = json['age'],
        email = json['email'],
        id = json['id'];
  Map<String, dynamic> toJson() {
    Map<String, dynamic> mapUser = Map.from(
        <String, dynamic>{'name': name, 'age': age, 'email': email, 'id': id});
    return mapUser;
  }
}
