import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school/ui/motor_controller.dart';
import 'package:school/ui/valve_controller.dart';
import 'package:school/view_model/language_view_model.dart';
import 'package:school/view_model/sms_view_model.dart';
import 'dart:io';

class FarmControllerPage extends StatefulWidget {
  @override
  _FarmControllerPageState createState() => _FarmControllerPageState();
}

class _FarmControllerPageState extends State<FarmControllerPage> {
  @override
  Widget build(BuildContext context) {
    var model = Provider.of<LanguageModel>(context);
    var smsModel = Provider.of<SmsViewModel>(context);
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
                DeviceControllerWidget(context: context, model: model, smsModel: smsModel)

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
        future: model.translate("farm_controller"),
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

class DeviceControllerWidget extends StatefulWidget {

  final BuildContext context;
  final LanguageModel model;
  final SmsViewModel smsModel;

  const DeviceControllerWidget({Key key, this.context, this.model, this.smsModel}) : super(key: key);


  @override
  _DeviceControllerWidgetState createState() => _DeviceControllerWidgetState();
}

class _DeviceControllerWidgetState extends State<DeviceControllerWidget> {

  //TODO: Set condition switch between Valve and Motor

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height,
        margin: EdgeInsets.only(left: 50, right: 50),
        child: Platform.isAndroid ? Column(
          children: <Widget>[

            MotorController(model: widget.model, smsModel: widget.smsModel),
            SizedBox(height: 50),
            ValveController(model: widget.model, smsModel: widget.smsModel)

          ],
        ) : Container(),
      ),
    );
  }
}






