import 'package:flutter/material.dart';
import 'package:sms/sms.dart';

class SmsViewModel extends ChangeNotifier {

  Future<List<SmsMessage>> getMessagesFromAddress(String address) async {
    List<SmsMessage> messages = [];
    SmsQuery smsQuery = new SmsQuery();
    messages = await smsQuery.querySms(address: address);
    notifyListeners();
    return messages;
  }

}