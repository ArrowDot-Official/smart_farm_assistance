import 'dart:io';

import 'package:path/path.dart';
import 'package:school/models/phone_number.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';


class DBPhoneNumber {

  static const phoneTable = 'phone';
  static const id = 'id';
  static const number = 'number';
  static const tag = 'tag';

  String message = "";

  static final DBPhoneNumber _instance = DBPhoneNumber._();
  static Database _database;
  DBPhoneNumber._();
  factory DBPhoneNumber() {
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
    final todoSql = '''CREATE TABLE $phoneTable
    (
      $id INTEGER PRIMARY KEY,
      $number TEXT,
      $tag TEXT NOT NULL DEFAULT '' 
    )''';

    await db.execute(todoSql);
  }

  void _onUpgrade(Database db, int oldVersion, int newVersion) {
    // Run migration according database versions
  }

  Future<Database> init() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String dbPath = join(directory.path, 'phone.db');
    var database = openDatabase(dbPath, version: 1, onCreate: _onCreate, onUpgrade: _onUpgrade);
    return database;
  }

  // ------------- CRUD ----------------- //

  Future<List<PhoneNumber>> getAllPhoneNumber() async {
    try {
      message = "";
      var client = await db;
      List<PhoneNumber> list = List();

      final List<Map<String, dynamic>> map = await client.query(phoneTable);

      for (final n in map) {
        list.add(PhoneNumber.fromDB(n));
      }

      message = "Phone number exists";
      return list;
    } catch (e) {
      message = e.toString();
      print(message);
      return null;
    }
  }

  Future<PhoneNumber> getPhoneNumber(String number) async {
    List<PhoneNumber> phones = await getAllPhoneNumber();
    List<PhoneNumber> phone = List();
    for (final n in phones) {
      if (n.number == number) {
        phone.add(n);
      }
    }
    return phone.first;
  }

  Future<bool> shouldGetMessage(String number) async {
    List<PhoneNumber> list = await getAllPhoneNumber();
    if (list.contains(getPhoneNumber(number))) {
      return true;
    } else {
      return false;
    }
  }

  Future<int> addPhoneNumber(PhoneNumber phone) async {
    try {
      message = "";
      var client = await db;
      int result = await client.insert(phoneTable, phone.toMapForDB(),
          conflictAlgorithm: ConflictAlgorithm.replace);
      if (result > 0) {
        message = "Phone number is created";
      } else {
        message = "Phone number is not created";
      }
      return result;
    } catch (e) {
      message = "Problem happen when creating new phone number";
      print(e.toString());
      return null;
    }
  }

  Future<void> removePhoneNumber(int id) async {
    try {
      message = "";
      var client = await db;
      message = "Item removed";
      return client.delete(phoneTable, where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      message = e.toString();
      print(message);
      return null;
    }
  }

  Future<int> updatePhoneNumber(PhoneNumber phone) async {
    try {
      message = "";
      var client = await db;
      return client.update(phoneTable, phone.toMapForDB(), where: 'id = ?', whereArgs: [phone.id], conflictAlgorithm: ConflictAlgorithm.replace);
    } catch (e) {
      message = e.toString();
      print(message);
      return null;
    }
  }

}