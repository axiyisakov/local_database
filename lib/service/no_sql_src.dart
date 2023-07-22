import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import '../model/fruit_model.dart';

class HiveDbSrc {
  Box? _hiveBox;

  static final _instance = HiveDbSrc._internal();
  factory HiveDbSrc() => _instance;

  HiveDbSrc._internal() {
    try {
      setup();
    } catch (e) {
      log(e.toString());
    }
  }
  void setup() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      Hive.init(dir.path);
      Hive.registerAdapter(FruitModelAdapter());
      _hiveBox = await Hive.openBox('fruitdb');
      debugPrint("HIVE INITED AND OPENED BOX");
    } catch (e) {
      log(e.toString());
    }
  }

//? write Data to db
  Future<bool> saveDataToHiveBoxAsJson(
      {required List<FruitModel?> fruits, required String key}) async {
    bool? isSaved = false;
    try {
      await _hiveBox!.put(key, fruits);
      isSaved = true;
      return isSaved;
    } catch (e) {
      log(e.toString());
    }
    return isSaved!;
  }

//? get fruits
  Future<List<FruitModel?>> getFruits({required String key}) async {
    try {
      List<FruitModel?> data = await _hiveBox!.get(
        key,
      );
      return data;
    } catch (e, s) {
      log(e.toString());
      log(s.toString());
    }
    return List.empty();
  }

//? update fruits
  Future<bool> updateFruitToData(
      {required String key, required FruitModel fruit}) async {
    try {
      final isDeleted = await deleteDataUsingId(id: fruit.id, key: key);
      assert(isDeleted == true, 'O\'chirildi');
      final isAdded = await addFruitToData(key: key, fruit: fruit);
      debugPrint('DATA ADDED');
      return isAdded;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

//?add fruit
  Future<bool> addFruitToData(
      {required String key, required FruitModel fruit}) async {
    try {
      var data = await getFruits(key: 'fruits');
      data.add(fruit);
      await _hiveBox!.delete(key);
      assert(_hiveBox!.get(key) == null, "null ga teng");
      debugPrint('DATA ADDED');
      return await saveDataToHiveBoxAsJson(fruits: data, key: key);
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

//? delete fruit
  Future<bool> deleteDataUsingId(
      {required String? id, required String key}) async {
    try {
      var data = await getFruits(key: key);
      data.removeWhere((element) => element!.id == id);
      await _hiveBox!.delete(key);
      assert(_hiveBox!.get(key) == null, "null ga teng");
      debugPrint('DATA DELETED');
      return await saveDataToHiveBoxAsJson(fruits: data, key: key);
    } catch (e) {
      log(e.toString());
    }
    return false;
  }

  //? box
  Box? get box => _hiveBox;

  //? for close hive box
  Future<void> get close async => _hiveBox!.close();
}
