import 'dart:io';

import 'package:path/path.dart';
import 'package:school/models/device.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DBDevice {

  static const deviceTable = 'device';
  static const id = 'id';
  static const name = 'name';
  static const number = "number";
  static const status = "status";
  static const type = "type";
  static const duration = "duration";
  static const tag = 'tag';
  static const motor_tag = "motor_tag";

  String message = "";

  static final DBDevice _instance = DBDevice._();
  static Database _database;
  DBDevice._();
  factory DBDevice() {
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
    final todoSql = '''CREATE TABLE IF NOT EXISTS $deviceTable
    (
      $id INTEGER PRIMARY KEY,
      $name TEXT,
      $number TEXT,
      $status TEXT,
      $type TEXT,
      $duration TEXT,
      $tag TEXT NOT NULL DEFAULT '' 
    )''';
    await db.execute(todoSql);
  }

  void _onUpgrade(Database db, int oldVersion, int newVersion) {
    // Run migration according database versions
    // Drop older table if existed
    db.execute("DROP TABLE IF EXISTS " + deviceTable);

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

  Future<List<Device>> getAllDevice({String where, List<dynamic> whereArgs}) async {
    try {
      message = "";
      var client = await db;
      List<Device> list = List();

      final List<Map<String, dynamic>> map = await client.query(deviceTable,where: where, whereArgs: whereArgs);

      for (final n in map) {
        list.add(Device.fromDB(n));
      }

      message = "Device exists";
      return list;
    } catch (e) {
      message = e.toString();
      print(message);
      return null;
    }
  }

  Future<Device> getDevice(String name) async {
    List<Device> motors = await getAllDevice();
    List<Device> motor = List();
    for (final n in motors) {
      if (n.name == name) {
        motor.add(n);
      }
    }
    return motor.first;
  }

  Future<int> addDevice(Device device) async {
    try {
      message = "";
      var client = await db;
      int result = await client.insert(deviceTable, device.toMapForDB(),
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

  Future<void> removeDevice(int id) async {
    try {
      message = "";
      var client = await db;
      message = "Item removed";
      return client.delete(deviceTable, where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      message = e.toString();
      print(message);
      return null;
    }
  }

  Future<int> updateDevice(Device device) async {
    try {
      message = "";
      var client = await db;
      return client.update(deviceTable, device.toMapForDB(), where: 'id = ?', whereArgs: [device.id], conflictAlgorithm: ConflictAlgorithm.replace);
    } catch (e) {
      message = e.toString();
      print(message);
      return null;
    }
  }

}