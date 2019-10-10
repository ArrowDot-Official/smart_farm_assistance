import 'package:flutter/material.dart';
import 'package:school/pages/user_setting.dart';
import 'package:school/pages/about.dart';
import 'package:school/pages/farm_controller.dart';
import 'package:school/pages/home_page.dart';
import 'package:school/pages/language.dart';
import 'package:provider/provider.dart';
import 'package:school/pages/setting_device.dart';
import 'package:school/view_model/language_view_model.dart';
import 'package:unicorndial/unicorndial.dart';
import 'package:permission_handler/permission_handler.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {

  List<Widget> pages = [MyHomePage(), SettingDevicePage(),  LanguagePage(), AboutPage(), FarmControllerPage(), UserSettingPage()];
  int index = 1;
  PermissionStatus _status;

  List<UnicornButton> _getProfileMenu(Map<String, dynamic> map) {
    List<UnicornButton> children = [];

//    children.add(_profileOptions(map: map, iconData: Icons.supervised_user_circle, tag: "user_setting", onPress: () async {
//      setState(() {
//        index = 5;
//      });
//    }));

    children.add(_profileOptions(map: map, iconData: Icons.devices_other, tag: "farm_controller", onPress: () async {
      setState(() {
        index = 4;
      });
    }));

//    children.add(_profileOptions(map: map, iconData: Icons.schedule,  tag: "schedule", onPress: () {
//
//    }));

    children.add(_profileOptions(map: map, iconData: Icons.info_outline,tag: "about", onPress: () {
      setState(() {
        index = 3;
      });
    }));


    children.add(_profileOptions(map: map, iconData: Icons.language, tag: "language", onPress: () {
      setState(() {
        index = 2;
      });
    }));

    children.add(_profileOptions(map: map, iconData: Icons.settings_applications, labelText: "Setting device", tag: "setting_device", onPress: () {
      setState(() {
        index = 1;
      });
    }));

//    children.add(_profileOptions(map: map, iconData: Icons.home, labelText: "Home",  tag: "home", onPress: () {
//      setState(() {
//        index = 0;
//      });
//    }));

    return children;
  }

  Widget _profileOptions({Map<String, dynamic> map, IconData iconData, String labelText, String tag, Function onPress}) {
    String name = "";
    name = map[tag];
    return UnicornButton(
      labelText: name ?? "",
      hasLabel: true,
      labelBackgroundColor: Colors.white,
      labelHasShadow: false,
      currentButton: FloatingActionButton(
        onPressed: onPress,
        heroTag: tag,
        mini: true,
        backgroundColor: Colors.green[700],
        child: Icon(iconData),
      ),
    );
  }

  _permissionHandler() {
    PermissionHandler().checkPermissionStatus(PermissionGroup.sms).then(_updateStatus);
  }

  _updateStatus(PermissionStatus status) {
    if (status != _status) {
      setState(() {
        _status = status;
      });
    }
  }

  _askPermission() {
    PermissionHandler().requestPermissions([PermissionGroup.sms]).then(_onStatusRequested);
  }

  _onStatusRequested(Map<PermissionGroup, PermissionStatus> statuses) {
    final status = statuses[PermissionGroup.sms];
    if (status != PermissionStatus.granted) {
      PermissionHandler().openAppSettings();
    } else {
      _updateStatus(status);
    }
  }

  @override
  Widget build(BuildContext context) {
    _permissionHandler();
    _askPermission();
    var provider = Provider.of<LanguageModel>(context);
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          backgroundColor: Colors.green[700]
      ),
      home: FutureBuilder<Map<String, dynamic>>(
        future: provider.loadLanguage(),
        builder: (context, snapshot) {
          Map<String, dynamic> map = Map();
          if (snapshot.hasData) {
            map = snapshot.data;
          }
          return Scaffold(
            body: pages[index],
            floatingActionButton: UnicornDialer(
              orientation: UnicornOrientation.VERTICAL,
              parentButtonBackground: Colors.green[700],
              parentButton: Icon(Icons.view_headline),
              childButtons: _getProfileMenu(map),
            ),
          );
        },
      ),
    );
  }
}

