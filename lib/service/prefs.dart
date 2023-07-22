import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Prefs {
  //?save data to local
  static Future<bool?> saveDataToLocal(
      {required String? key, required String? data}) async {
    try {
      SharedPreferences? prefs = await SharedPreferences.getInstance();
      return prefs.setString(key!, data!);
    } catch (e) {
      debugPrint(e.toString());
    }
    return false;
  }

//? load data
  static Future<String?> loadDataFromLocal({required String? key}) async {
    try {
      SharedPreferences? prefs = await SharedPreferences.getInstance();
      return prefs.getString(key!);
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

//? update data
  static Future<bool?> updateDataOnLocal(
      {required String? key, required String? newData}) async {
    try {
      String? data = await loadDataFromLocal(key: key);
      if (data != null) {
        bool? isDeleted = await deleteDataFromLocal(key: key);
        if (isDeleted!) {
          return saveDataToLocal(key: key, data: newData);
        }
      }
      return saveDataToLocal(key: key, data: newData);
    } catch (e) {
      debugPrint(e.toString());
    }
    return false;
  }

//? remove data
  static Future<bool?> deleteDataFromLocal({required String? key}) async {
    try {
      SharedPreferences? prefs = await SharedPreferences.getInstance();
      return prefs.remove(key!);
    } catch (e) {
      debugPrint(e.toString());
    }
    return false;
  }
}
