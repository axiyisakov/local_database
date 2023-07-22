import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter_g2/model/user_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SqlService {
  Database? _database;
  static final _instance = SqlService._init();

  factory SqlService() => _instance;

  SqlService._init() {
    try {
      // if (_database == null) {
      init;
      // }
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrint(s.toString());
    }
  }

  void get init async {
    try {
      var dirPath = await getDatabasesPath();
      String? dbPath = join(dirPath, 'usersql.db');
      _database = await openDatabase(dbPath,
          version: 1, onCreate: _onCreateDatabase, onOpen: _onOpenDatabase);
      debugPrint('SQL DB INITED');
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrint(s.toString());
    }
  }

  Future<void> _onCreateDatabase(Database db, int version) async {
    try {
      await db.execute(
          '''CREATE TABLE users (id TEXT PRIMARY KEY, name TEXT NOT NULL, age INTEGER NOT NULL, email TEXT NOT NULL)''');
      debugPrint('Users TABLE CREATED');
    } catch (e, s) {
      log(e.toString());
      debugPrint(s.toString());
    }
  }

  Future<void> _onOpenDatabase(Database db) async {
    try {
      // await _database!.delete('users');
      // debugPrint('DB DELETED');
      debugPrint('DATABASE OPENED');
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> insertDataToTable({required UserModel user}) async {
    try {
      assert(_database != null);
      await _database!.insert('users', user.toJson());
      debugPrint('USER ADDED');
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrint(s.toString());
    }
  }

  Future<void> updateUserDataToTable({required UserModel user}) async {
    try {
      assert(_database != null);
      await _database!.update('users', user.toJson(),
          where: 'id = ?', whereArgs: [user.id]);
      debugPrint('USER UPDATED');
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrint(s.toString());
    }
  }

  Future<List<UserModel?>?> getUser() async {
    try {
      assert(_database != null);
      List<Map<String, Object?>> userList = await _database!.query('users');
      List<UserModel?>? lt =
          userList.map((mapUser) => UserModel.fromJson(mapUser)).toList();
      return lt;
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrint(s.toString());
      rethrow;
    }
  }

  Future<void> deleteUser({required String? id}) async {
    try {
      int? idNew =
          await _database!.delete('users', where: 'id = ?', whereArgs: [id]);

      debugPrint('$id DELETED  $idNew');
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrint(s.toString());
    }
  }

  Future<void> closeDb() async {
    try {
      debugPrint('DB CLOSED');
      return _database!.close();
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrint(s.toString());
    }
  }
}
