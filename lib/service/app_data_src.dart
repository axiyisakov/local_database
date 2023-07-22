import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_g2/model/techno_model.dart';

class AppDataSrc {
  static Future<List<Notebook?>?> getDataFromLocal() async {
    try {
      List<dynamic> data =
          jsonDecode(await rootBundle.loadString('assets/data/data.json'));
      return data.map((e) => Notebook.fromJson(e)).toList();
    } catch (e) {
      log(e.toString());
    }
    return List.empty();
  }

  static Future<List<Notebook?>?> getDataFromLocalSecond(
      BuildContext context) async {
    try {
      List<dynamic> data = jsonDecode(await DefaultAssetBundle.of(context)
          .loadString('assets/data/data.json'));
      return data.map((e) => Notebook.fromJson(e)).toList();
    } catch (e) {
      log(e.toString());
    }
    return List.empty();
  }
}
