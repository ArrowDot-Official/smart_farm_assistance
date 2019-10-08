import 'package:school/database/db_valve.dart';

class Valve {

  int id;
  String name;
  String number;
  String status;
  String duration = "";
  String tag = "";

  Valve(this.name, this.number, this.status, this.duration, this.tag);

  Valve.fromDB(Map<String, dynamic> map) {
    this.id = map[DBValve.id];
    this.name = map[DBValve.name];
    this.number = map[DBValve.number];
    this.status = map[DBValve.status];
    this.duration = map[DBValve.duration];
    this.tag = map[DBValve.tag];
  }

  Map<String, dynamic> toMapForDB() {
    var map = Map<String, dynamic>();
    map['id'] = id;
    map['name'] = name;
    map['number'] = number;
    map['status'] = status;
    map['duration'] = duration;
    map['tag'] = tag;
    return map;
  }

}
