import 'dart:io';

import 'package:path/path.dart';
import 'package:school/models/valve.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DBValve {

  static const valveTable = 'valve';
  static const id = 'id';
  static const name = 'name';
  static const number = "number";
  static const status = "status";
  static const duration = "duration";
  static const tag = 'tag';
  static const motor_tag = "motor_tag";

  String message = "";

  static final DBValve _instance = DBValve._();
  static Database _database;
  DBValve._();
  factory DBValve() {
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
    final todoSql = '''CREATE TABLE IF NOT EXISTS $valveTable
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
    // Drop older table if existed
    db.execute("DROP TABLE IF EXISTS " + valveTable);

    // Create tables again
    _onCreate(db, newVersion);
  }

  Future<Database> init() async {
    var database;
    try {
      Directory directory = await getApplicationDocumentsDirectory();
      String dbPath = join(directory.path, 'valve.db');
      database = openDatabase(
          dbPath, version: 2, onCreate: _onCreate, onUpgrade: _onUpgrade);
    } catch (e) {
      print("INIT " + e.toString());
    }
    return database;
  }

  // ------------- CRUD ----------------- //

  Future<List<Valve>> getAllValve() async {
    try {
      message = "";
      var client = await db;
      List<Valve> list = List();

      final List<Map<String, dynamic>> map = await client.query(valveTable);

      for (final n in map) {
        list.add(Valve.fromDB(n));
      }

      message = "Valve exists";
      return list;
    } catch (e) {
      message = e.toString();
      print(message);
      return null;
    }
  }

  Future<Valve> getValve(String name) async {
    List<Valve> motors = await getAllValve();
    List<Valve> motor = List();
    for (final n in motors) {
      if (n.name == name) {
        motor.add(n);
      }
    }
    return motor.first;
  }

  Future<int> addValve(Valve valve) async {
    try {
      message = "";
      var client = await db;
      int result = await client.insert(valveTable, valve.toMapForDB(),
          conflictAlgorithm: ConflictAlgorithm.replace);
      if (result > 0) {
        message = "Valve is created";
      } else {
        message = "Valve is not created";
      }
      return result;
    } catch (e) {
      message = "Problem happen when creating new motor";
      print(e.toString() + " Problem happen when creating new motor");
      return null;
    }
  }

  Future<void> removeValve(int id) async {
    try {
      message = "";
      var client = await db;
      message = "Item removed";
      return client.delete(valveTable, where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      message = e.toString();
      print(message);
      return null;
    }
  }

  Future<int> updateValve(Valve valve) async {
    try {
      message = "";
      var client = await db;
      return client.update(valveTable, valve.toMapForDB(), where: 'id = ?', whereArgs: [valve.id], conflictAlgorithm: ConflictAlgorithm.replace);
    } catch (e) {
      message = e.toString();
      print(message);
      return null;
    }
  }

}