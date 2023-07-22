import 'package:hive/hive.dart';
part 'fruit_model.g.dart';

@HiveType(typeId: 0)
class FruitModel extends HiveObject {
  @HiveField(0)
  String? name;
  @HiveField(1)
  String? type;
  @HiveField(2)
  String? desc;
  @HiveField(3)
  String? id;
  FruitModel(
      {required this.name,
      required this.type,
      required this.desc,
      required this.id});
  FruitModel.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        type = json['type'],
        id = json['id'],
        desc = json['desc'];
  Map<String, dynamic> toJson() {
    Map<String, dynamic> mapFruit = Map.from(
        <String, dynamic>{'name': name, 'type': type, 'desc': desc, 'id': id});
    return mapFruit;
  }
}
