import 'package:flutter/material.dart';
import 'package:school/view_model/sms_view_model.dart';
import 'package:sms/sms.dart';
import 'service_locator.dart';
import 'landing.dart';
import 'package:provider/provider.dart';
import 'package:school/view_model/language_view_model.dart';

void main() async {
  //TODO: Get weather API
  //TODO: Setup connection to server to control device
  //TODO: Control CRUD to device through server
  //TODO: Get Feedback to confirm status from device on mobile
  //TODO: Control state management

  //TODO: Condition ON/OFF with sim
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: LandingPage(),
      ),
      providers: <SingleChildCloneableWidget> [
        ChangeNotifierProvider<LanguageModel>(
          builder: (_) => LanguageModel(),
        ),
        ChangeNotifierProvider<SmsViewModel>(
          builder: (_) => SmsViewModel(),
        ),
        StreamProvider<SmsMessage>.value(
          value: SmsReceiver().onSmsReceived.asBroadcastStream(),
        )
      ],
    );
  }
}



