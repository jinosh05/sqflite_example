import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static const _dbName = 'my_sql_database.db';
  static const _dbVersion = 1;

  static const _tableName = 'my_table';
  static const columnId = '_id';
  static const columnName = 'name';

  DatabaseHelper._privateConstructor();

  /// Instance of DatabaseHelper
  static final instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  get database async {
    if (_database == null) {
      _database = await initialiseDatabase();
      return _database;
    } else {
      return _database;
    }
  }

  Future<Database> initialiseDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, _dbName);
    debugPrint(path);
    return await openDatabase(path, version: _dbVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    db.execute('''
CREATE TABLE $_tableName (
$columnId INTEGER PRIMARY KEY,
$columnName TEXT NOT NULL )
''');
  }

  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(_tableName, row);
  }

  Future<List<Map<String, dynamic>>> queryAll() async {
    Database db = await instance.database;
    return await db.query(_tableName);
  }

  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(_tableName, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> update(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = int.parse(row[columnId]);
    return await db
        .update(_tableName, row, where: '$columnId = ?', whereArgs: [id]);
  }
}
