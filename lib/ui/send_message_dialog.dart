import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:toast/toast.dart';
import 'package:sms/sms.dart';

class CommandDialog extends StatefulWidget {
  @override
  _CommandDialogState createState() => _CommandDialogState();
}

class _CommandDialogState extends State<CommandDialog> {
  final key = GlobalKey<FormState>();
  TextEditingController _numberController = TextEditingController();
  TextEditingController _messageController = TextEditingController();

  var value = "message";
  var valueFunc = "";

  List<Map<String, IconData>> listMap = [
    {"message" : Icons.message},
    {"power_setting_new": Icons.power_settings_new},
    {"setting_power" : Icons.settings_power},
    {"power" : Icons.power},
    {"storage": Icons.storage},
    {"print" : Icons.print},
    {"add" : Icons.add},
    {"mic" : Icons.mic},
    {"mic_off" : Icons.mic_off},
    {"mic_none" : Icons.mic_none},
    {"functions" : Icons.functions},
    {"alarm" : Icons.alarm},
  ];
  List<DropdownMenuItem<String>> listIcons;
  List<DropdownMenuItem<String>> listFunctions;

  MdiIcons icons = new MdiIcons();

  _loadFunctions() async {
    listFunctions = [];

  }

  _loadIcon() {
    listIcons = [];

    for(int i=0; i<listMap.length; i++) {
      var getKey = listMap[i].keys.toList().first;
      var getValue = listMap[i].values.toList().first;
      listIcons.add(new DropdownMenuItem<String>(
        value: getKey,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(getKey),
            Icon(getValue)
          ],
        ),
      ));
    }
    setState(() {});
  }
  
  _sendMessage(String message, String receivers) async {
    try {
      print(message);
      SmsSender sender = new SmsSender();
      SmsMessage msg = new SmsMessage(receivers, message);
      await sender.sendSms(msg);
    } catch (e) {
      print(e.toString());
    }

  }

  @override
  Widget build(BuildContext context) {
    _loadFunctions();
    _loadIcon();
    return Dialog(
      elevation: 1.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      backgroundColor: Colors.white,
      child: Center(
        child: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(20),
            child: Form(
              key: key,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[

                  _phoneNumberWidget(context),
                  SizedBox(height: 30,),

                  _addMessageWidget(context),
                  SizedBox(height: 30,),

                  FlatButton(
                    onPressed: () async {
                      await _sendMessage(_messageController.text, _numberController.text);
                      Toast.show("Message sent", context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                      Navigator.pop(context);
                    },
                    child: Center(
                      child: Container(
                        child: Text("SEND"),
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _phoneNumberWidget(BuildContext context) {
    return TextFormField(
      controller: _numberController,
      keyboardType: TextInputType.phone,
      onSaved: (String value) {
          _numberController.text = value;
      },
      decoration: InputDecoration(
        hintText: "Enter phone number",
      ),
    );
  }

  _addMessageWidget(BuildContext context) {
    return TextFormField(
      controller: _messageController,
      onSaved: (String value) {
        _messageController.text = value;
      },
      decoration: InputDecoration(
        hintText: "Message to send",
      ),
    );
  }

  _chooseIcon(BuildContext context) {

    return DropdownButton<String>(
      value: value,
      onChanged: (String newValue) {
        setState(() {
          value = newValue;
        });
      },

      items: listIcons
    );
  }

  _chooseFunction(BuildContext context) {
    return DropdownButton<String> (
      value: value,
      onChanged: (String newValue) {
        setState(() {
          value = newValue;
        });
      },

      items: listFunctions,
    );
  }
}

