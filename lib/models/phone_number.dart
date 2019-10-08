import 'package:school/database/db_phone_number.dart';

class PhoneNumber {

  int id;
  String number;
  String tag = "";

  PhoneNumber(this.number, this.tag);

  PhoneNumber.fromDB(Map<String, dynamic> map) {
    this.id = map[DBPhoneNumber.id];
    this.number = map[DBPhoneNumber.number];
    this.tag = map[DBPhoneNumber.tag];
  }

  Map<String, dynamic> toMapForDB() {
    var map = Map<String, dynamic>();
    map['id'] = id;
    map['number'] = number;
    map['tag'] = tag;
    return map;
  }


}