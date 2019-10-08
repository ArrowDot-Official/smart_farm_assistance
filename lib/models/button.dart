import 'package:flutter/material.dart';

class Button {
  int _id;
  String _title;
  IconData _iconData;

  Button(this._id, this._title, this._iconData);

  Map toJSONEncodable() => {
    'id' : _id,
    'title' : _title,
    'iconData' : _iconData
  };

  fromJSON(Map<String, dynamic> map) => Button(
    _id = map['id'],
    _title = map['title'],
    _iconData = map['iconData'],
  );

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  String get title => _title;

  set title(String value) {
    _title = value;
  }

  IconData get iconData => _iconData;

  set iconData(IconData value) {
    _iconData = value;
  }

}