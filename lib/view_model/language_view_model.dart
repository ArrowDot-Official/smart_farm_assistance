import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageModel extends ChangeNotifier {

  String lang = "en";
  String _getTranslate = "";

  Future<Map<String, dynamic>> loadLanguage() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.containsKey("language")) {
      lang = pref.getString("language");
    }
    Map<String, dynamic> map = new Map();
    String jsonContent = await rootBundle.loadString("assets/locale/localization_$lang.json");
    map = json.decode(jsonContent);
    return map;
  }

  Future<String> translate(String key) async {
    Map<String, dynamic> map = await loadLanguage();
    map.forEach((k,v) {
      if (key == k) {
        print(v.toString());
        _getTranslate = v.toString();
      }
    });
    return _getTranslate;
  }

  Future<void> changeLanguage(String language) async {
    lang = language;
    notifyListeners();
  }
}