import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school/database/db_device.dart';
import 'package:school/database/db_valve.dart';
import 'package:school/models/device.dart';
import 'package:school/models/motor.dart';
import 'package:school/models/valve.dart';
import 'package:school/view_model/language_view_model.dart';
import 'package:school/view_model/sms_view_model.dart';
import 'package:sms/contact.dart';
import 'package:sms/sms.dart';
import 'package:toast/toast.dart';

class ValveController extends StatefulWidget {

  final LanguageModel model;
  final SmsViewModel smsModel;
  const ValveController({Key key, this.model, this.smsModel}) : super(key: key);

  @override
  _ValveControllerState createState() => _ValveControllerState();
}


class _ValveControllerState extends State<ValveController> {

  DBDevice _dbDevice = new DBDevice();

  Future<List<Device>> _getValve() async {
    List<Device> m = await _dbDevice.getAllDevice(where: "type='valve'");
    return m;
  }

  Future<SmsMessage> _sendMessage(String message, String receivers) async {
    try {
      print(message);
      SmsSender sender = new SmsSender();
      SmsMessage msg = new SmsMessage(receivers, message);
      var result = await sender.sendSms(msg);
      return result;
    } catch (e) {
      print(e.toString());
      Toast.show(e.toString(), context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return null;
    }
  }

  Future<List<SmsMessage>> getMessages(String address) async {
    List<SmsMessage> messages = await SmsQuery().querySms(address: address, kinds: [SmsQueryKind.Sent, SmsQueryKind.Inbox]);
    if (messages == null) {
      return [];
    }
    return messages;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[

            FutureBuilder(
              future: widget.model.translate("valve"),
              builder: (context, snapshot) {
                String motor = "";
                if (snapshot.hasData) {
                  motor = snapshot.data;
                }
                return Text(motor, style: TextStyle(color: Colors.green[700], fontSize: 20));
              },
            ),
            Divider(color: Colors.green[700],),
            FutureBuilder(
              future: _getValve(),
              builder: (context, snapshot) {
                List<Device> list = List();
                if (snapshot.hasData) {
                  list = snapshot.data;
                }
                return Container(
                  height: 200,
                  child: ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (context, index) => _listValveWidget(list[index]),
                  ),
                );
              },
            )

          ],
        ),
      ),
    );
  }

  _listValveWidget(Device valve) {
    SmsReceiver receiver = new SmsReceiver();
    SmsSender sender = new SmsSender();

    String onImg = "images/icon-18.png";
    String offImg = "images/icon-20.png";
    String loadImg = "images/icon-10.png";
    String errorImg = "images/icon-04.png";
    return Container(
        height: 100,
        child: StreamBuilder<SmsMessage>(
          stream: receiver.onSmsReceived,
          builder: (context, data) {
            String received = "";
            SmsMessageState state;

            if (data.hasData) {
              received = data.data.body;
              print(data.data.state.toString());
            } else {
              received = "off";
            }

            return FutureBuilder<List<SmsMessage>>(
                future: SmsQuery().querySms(address: valve.number, kinds: [SmsQueryKind.Sent, SmsQueryKind.Inbox]),
                builder: (context, snapshot) {


                  if (snapshot.hasData) {
                    if (snapshot.data.isNotEmpty) {
                      received = snapshot.data.first.body;
                      print(state.toString());
                    } else {
                      received = "off";
                    }
                  } else {
                    received = "off";
                  }

                  print("RECEIVED ------------------ " + received);


                  if (received.contains("on")|| received.contains("off")) {
                    if (received == "v${valve.tag}-on") {
                      valve.status = "on";
                    } else if (received == "v${valve.tag}-off") {
                      valve.status = "off";
                    }
                    print("TEST1 ");
                  } else if (received == "") {
                    valve.status = "off";
                    print("TEST3 ");
                  } else {
                    valve.status = "on";
                    valve.duration = received;
                    print("ELSE ===============> " + received);
                    print("TEST4 ");
                  }
                  _dbDevice.updateDevice(valve);

                  return Container(
                      padding: EdgeInsets.all(5),
                      height: 200,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[

                          Container(
                            height: 50,
                            child: Flex(
                              direction: Axis.horizontal,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.stretch,

                              children: <Widget>[

                                Image.asset("images/icon-05.png"),

                                Expanded(
                                  child: Container(
                                    child: Center(
                                      child: Text(valve.name,),
                                    ),
                                  ),
                                ),

                                FlatButton(
                                  onPressed: () async {
                                    String on = "[v"+valve.tag + "-on]";
                                    String off = "[v"+valve.tag + "-off]";

                                    _sendMessage(valve.status == "off" ? on : off , valve.number);
                                    setState(() {});
                                  },
                                  child: valve.status == "on" ? Image.asset(onImg) : Image.asset(offImg),
//                            child: StreamBuilder<SmsMessage>(
//                              stream: sender.onSmsDelivered,
//                              builder: (context, data) {
//                                if (data.hasData) {
//                                  if (data.data.state == SmsMessageState.Sending || data.data.state == SmsMessageState.Sent || data.data.state == SmsMessageState.Delivered) {
//                                    return Image.asset(loadImg);
//                                  } else if (data.data.state == SmsMessageState.Fail) {
//                                    return Image.asset(errorImg);
//                                  }
//                                }
//                                return valve.status == "on" ? Image.asset(onImg) : Image.asset(offImg);
//                              },
//                            ),
                                ),

                                IconButton(
                                  icon: Icon(Icons.more_vert),
                                  onPressed: () async {
                                    await commandDialog(context, valve);
                                  },
                                )

                              ],
                            ),
                          ),
                          received.contains("o") == false ? Text(received.toString() + " minute(s) remaning") : Container(height: 0)

                        ],
                      )
                  );
                }
            );
          },
        )
    );
  }

  GlobalKey<FormFieldState> _keyInDialog = GlobalKey();
  TextEditingController _durationTextController = TextEditingController();

  _customDurationInDialog(BuildContext context) {
    return Container(
      height: 60,
      child: Form(
        key: _keyInDialog,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              controller: _durationTextController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "Number of duration",
              ),
            )
          ],
        ),
      ),
    );
  }

  Future commandDialog(BuildContext context, Device valve) async {
    await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text("More action"),
          content: _customDurationInDialog(context),
          actions: <Widget>[
            _terminateButtonDialog(context,valve),
            _sendButtonDialog(context, valve),
          ],
        )
    );
  }

  _terminateButtonDialog(BuildContext context, Device valve) {
    return FlatButton(
      onPressed: () async {
        await _sendMessage("[v"+valve.tag + "-off]", valve.number);
      },
      child: Container(
        height: 40,
        width: 100,
        decoration: BoxDecoration(
          color: Colors.red[700],
          borderRadius: BorderRadius.circular(40),
        ),
        child: Center(
          child: Text("TERMINATE", style: TextStyle(color: Colors.white),),
        ),
      ),
    );
  }

  _sendButtonDialog(BuildContext context, Device valve) {
    return FlatButton(
      onPressed: () async {
        String msg = "[v${valve.tag}-"+_durationTextController.text+"]";
        await _sendMessage(msg, valve.number);
        _durationTextController.clear();
      },
      child: Container(
        height: 40,
        width: 100,
        decoration: BoxDecoration(
          color: Colors.green[700],
          borderRadius: BorderRadius.circular(40),
        ),
        child: Center(
          child: Text("SEND", style: TextStyle(color: Colors.white),),
        ),
      ),
    );
  }
}