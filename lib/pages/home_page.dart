import 'package:flutter/material.dart';
import 'package:school/ui/add_number_dialog.dart';
import 'package:school/ui/send_message_dialog.dart';
import 'package:school/ui/view_phone_number.dart';
import 'package:unicorndial/unicorndial.dart';

import 'package:school/database/db_phone_number.dart';

import 'package:sms/sms.dart';


class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

//  List<UnicornButton> _getProfileMenu() {
//    List<UnicornButton> children = [];
//
//    children.add(_profileOptions(iconData: Icons.add, labelText: "Command", tag: "button", onPress: () {
//      showDialog(
//        context: context,
//        builder: (BuildContext context) => CommandDialog()
//      );
//    }));
//
//    children.add(_profileOptions(iconData: Icons.contact_phone, labelText: "View Phone", tag: "phone", onPress: () {
//      showDialog(
//          context: context,
//          builder: (BuildContext context) => ViewPhoneNumber()
//      );
//    }));
//
//    children.add(_profileOptions(iconData: Icons.info_outline, labelText: "Language", tag: "language", onPress: () {
//      Navigator.push(context, MaterialPageRoute(builder: (context) => AboutPage()));
//    }));
//
//
//    children.add(_profileOptions(iconData: Icons.phone, labelText: "Add number", tag: "number", onPress: () {
//      showDialog(
//          context: context,
//          builder: (BuildContext context) => AddNumberDialog()
//      );
//    }));
//
//    children.add(_profileOptions(iconData: Icons.phone_forwarded, labelText: "Add number to call out", tag: "number_forward", onPress: () {
//      showDialog(
//          context: context,
//          builder: (BuildContext context) => AddNumberDialog()
//      );
//    }));
//
//    return children;
//  }
//
//  Widget _profileOptions({IconData iconData, String labelText , String tag, Function onPress}) {
//    return UnicornButton(
//      labelText: labelText,
//      hasLabel: true,
//      labelBackgroundColor: Colors.white,
//      labelHasShadow: false,
//      currentButton: FloatingActionButton(
//        onPressed: onPress,
//        heroTag: tag,
//        mini: true,
//        backgroundColor: Colors.green[700],
//        child: Icon(iconData),
//      ),
//    );
//  }

  String msg = "";

  final key = GlobalKey<ScaffoldState>();

  DBPhoneNumber _dbPhoneNumber = DBPhoneNumber();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SmsReceiver receiver = new SmsReceiver();
    return Scaffold(
      key: key,
          body: StreamBuilder<SmsMessage>(
            stream: receiver.onSmsReceived,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final item = snapshot.data;
                return FutureBuilder<bool>(
                  future: _dbPhoneNumber.shouldGetMessage(snapshot.data.address),
                  builder: (context, snap) {
                    if (snap.hasData) {
                      return snap.data ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              item.address, //buttonStore.list.last.title,
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .display1,
                            ),

                            SizedBox(height: 30,),

                            Text(
                              item.body, //buttonStore.list.last.title,
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .display1,
                            ),


                          ],
                        ),
                      ) : Container();
                    } else {
                      return Container();
                    }
                  }
                );
              } else {
                return Center(
                  child: Container()
                );
              }
            }
          ),
//          floatingActionButton: UnicornDialer(
//            orientation: UnicornOrientation.VERTICAL,
//            childButtons: _getProfileMenu(),
//            parentButtonBackground: Colors.green[700],
//            parentButton: Icon(Icons.home),
//          ), // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}
