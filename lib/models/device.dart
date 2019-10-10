import 'package:school/database/db_device.dart';

class Device {

  int id;
  String name;
  String number;
  String status;
  String type;
  String duration = "";
  String tag = "";

  Device(this.name, this.number, this.status, this.type, this.duration, this.tag);

  Device.fromDB(Map<String, dynamic> map) {
    this.id = map[DBDevice.id];
    this.name = map[DBDevice.name];
    this.number = map[DBDevice.number];
    this.status = map[DBDevice.status];
    this.type = map[DBDevice.type];
    this.duration = map[DBDevice.duration];
    this.tag = map[DBDevice.tag];
  }

  Map<String, dynamic> toMapForDB() {
    var map = Map<String, dynamic>();
    map['id'] = id;
    map['name'] = name;
    map['number'] = number;
    map['status'] = status;
    map['type'] = type;
    map['duration'] = duration;
    map['tag'] = tag;
    return map;
  }

}
