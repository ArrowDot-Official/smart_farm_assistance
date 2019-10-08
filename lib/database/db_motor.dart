import 'dart:io';

import 'package:path/path.dart';
import 'package:school/models/motor.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';


class DBMotor {

  static const motorTable = 'motor';
  static const id = 'id';
  static const name = 'name';
  static const number = "number";
  static const status = "status";
  static const duration = "duration";
  static const tag = 'tag';

  String message = "";

  static final DBMotor _instance = DBMotor._();
  static Database _database;
  DBMotor._();
  factory DBMotor() {
    return _instance;
  }
  Future<Database> get db async {
    if (_database != null) {
      return _database;
    }
    _database = await init();

    return _database;
  }

  Future<void> _onCreate(Database db, int version) async {
    final todoSql = '''CREATE TABLE IF NOT EXISTS $motorTable
    (
      $id INTEGER PRIMARY KEY,
      $name TEXT,
      $number TEXT,
      $status TEXT,
      $duration TEXT,
      $tag TEXT NOT NULL DEFAULT '' 
    )''';

    await db.execute(todoSql);
  }

  void _onUpgrade(Database db, int oldVersion, int newVersion) {
    // Run migration according database versions
  }

  Future<Database> init() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String dbPath = join(directory.path, 'motor.db');
    var database = openDatabase(dbPath, version: 1, onCreate: _onCreate, onUpgrade: _onUpgrade);
    return database;
  }

  // ------------- CRUD ----------------- //

  Future<List<Motor>> getAllMotor() async {
    try {
      message = "";
      var client = await db;
      List<Motor> list = List();

      final List<Map<String, dynamic>> map = await client.query(motorTable);

      for (final n in map) {
        list.add(Motor.fromDB(n));
      }

      message = "Phone number exists";
      return list;
    } catch (e) {
      message = e.toString();
      print(message);
      return null;
    }
  }

  Future<Motor> getMotor(String name) async {
    List<Motor> motors = await getAllMotor();
    List<Motor> motor = List();
    for (final n in motors) {
      if (n.name == name) {
        motor.add(n);
      }
    }
    return motor.first;
  }

  Future<int> addMotor(Motor motor) async {
    try {
      message = "";
      var client = await db;
      int result = await client.insert(motorTable, motor.toMapForDB(),
          conflictAlgorithm: ConflictAlgorithm.replace);
      if (result > 0) {
        message = "Motor is created";
      } else {
        message = "Motor is not created";
      }
      return result;
    } catch (e) {
      message = "Problem happen when creating new motor";
      print(e.toString() + " Problem happen when creating new motor");
      return null;
    }
  }

  Future<void> removeMotor(int id) async {
    try {
      message = "";
      var client = await db;
      message = "Item removed";
      return client.delete(motorTable, where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      message = e.toString();
      print(message);
      return null;
    }
  }

  Future<int> updateMotor(Motor phone) async {
    try {
      message = "";
      var client = await db;
      return client.update(motorTable, phone.toMapForDB(), where: 'id = ?', whereArgs: [phone.id], conflictAlgorithm: ConflictAlgorithm.replace);
    } catch (e) {
      message = e.toString();
      print(message);
      return null;
    }
  }

}