import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school/ui/create_motor.dart';
import 'package:school/ui/create_valve.dart';
import 'package:school/view_model/language_view_model.dart';

class SettingDevicePage extends StatefulWidget {
  @override
  _SettingDevicePageState createState() => _SettingDevicePageState();
}


class _SettingDevicePageState extends State<SettingDevicePage> {

  @override
  Widget build(BuildContext context) {
    var model = Provider.of<LanguageModel>(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[

                SizedBox(height: 100,),
                _titleWidget(context, model),
                SizedBox(height: 50,),
                CreateDeviceWidget(context: context, model: model)

              ],
            ),
          ),
        ),
      ),
    );
  }

  _titleWidget(BuildContext context, LanguageModel model) {
    String title = "";
    return FutureBuilder(
        future: model.translate("setting_device"),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            title = snapshot.data;
          }
          return Center(
              child: Container(
                width: MediaQuery.of(context).size.width - 100,
                height: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.green[700]
                ),
                child: Center(
                  child: Container(
                    child: Text(title, style: TextStyle(color: Colors.white, fontSize: 20),),
                  ),
                ),
              )
          );
        }
    );
  }

}

class CreateDeviceWidget extends StatefulWidget {

  final BuildContext context;
  final LanguageModel model;

  const CreateDeviceWidget({Key key, this.context, this.model}) : super(key: key);

  @override
  _CreateDeviceWidgetState createState() => _CreateDeviceWidgetState();
}

class _CreateDeviceWidgetState extends State<CreateDeviceWidget> {

  String number = "";

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height,
        margin: EdgeInsets.only(left: 50, right: 50),
        child: ListView(
          children: <Widget>[
            CreateMotor(model: widget.model),
//            Divider(color: Colors.green[700]),
////            _getOrRegisterNumber(context),
//            SizedBox(height: 30),
//            CreateValve(model: widget.model)
          ],
        ),
      ),
    );
  }



}



