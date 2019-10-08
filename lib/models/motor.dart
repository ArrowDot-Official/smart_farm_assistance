import 'package:school/database/db_motor.dart';

class Motor {

  int id;
  String name;
  String number;
  String status;
  String duration = "";
  String tag = "";

  Motor(this.name, this.number, this.status, this.duration, this.tag);

  Motor.fromDB(Map<String, dynamic> map) {
    this.id = map[DBMotor.id];
    this.name = map[DBMotor.name];
    this.number = map[DBMotor.number];
    this.status = map[DBMotor.status];
    this.duration = map[DBMotor.duration];
    this.tag = map[DBMotor.tag];
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
