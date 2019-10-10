import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:school/database/db_phone_number.dart';
import 'package:school/models/phone_number.dart';
import 'package:school/view_model/language_view_model.dart';
import 'package:toast/toast.dart';

class AddNumberDialog extends StatefulWidget {

  @override
  _AddNumberDialogState createState() => _AddNumberDialogState();
}

class _AddNumberDialogState extends State<AddNumberDialog> {
  final key = GlobalKey<FormState>();
  TextEditingController _numberController = new TextEditingController();
  TextEditingController _tagController = new TextEditingController();

  DBPhoneNumber _dbPhoneNumber = new DBPhoneNumber();

  Future<int> _addPhoneNumber(String number, String tag) async {
    try {
      PhoneNumber phone = new PhoneNumber(number, tag);
      int result = await _dbPhoneNumber.addPhoneNumber(phone);
      return result;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<List<PhoneNumber>> _getPhoneNumber() async {
    List<PhoneNumber> num = await _dbPhoneNumber.getAllPhoneNumber();
    return num;
  }

  @override
  Widget build(BuildContext context) {
    var model = Provider.of<LanguageModel>(context);
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

                  _titleWidget(context, model),
                  SizedBox(height: 30,),
                  
                  _addTitleWidget(context),
                  SizedBox(height: 30,),
                  
                  _addTagWidget(context),
                  SizedBox(height: 30,),
                  
                  FlatButton(
                    onPressed: () async {
                      if (key.currentState.validate()) {
                        key.currentState.save();
                        await _addPhoneNumber("+855"+_numberController.text, _tagController.text);
                        Toast.show(_dbPhoneNumber.message, context,
                            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
//                      Navigator.pop(context, true);
                        _numberController.clear();
                        _tagController.clear();
                        setState(() {});
                      }
                    },
                    child: Center(
                      child: Container(
                        child: FutureBuilder(
                          future: model.translate("done"),
                          builder: (context, snap) {
                            String done = "DONE";
                            if (snap.hasData) {
                              done = snap.data;
                            }
                            return Text(done);
                          },
                        )
                      ),
                    ),
                  ),
                  SizedBox(height: 30,),
                  
                  _listNumber(context),
                  SizedBox(height: 30,),
                  
                  FlatButton(onPressed: () {Navigator.of(context).pop();}, child: Text("DONE"))

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _titleWidget(BuildContext context, LanguageModel model) {
    String title = "";
    return FutureBuilder(
        future: model.translate("add_number"),
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

  _addTitleWidget(BuildContext context) {
    return TextFormField(
      controller: _numberController,
      keyboardType: TextInputType.phone,
      inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
      onSaved: (String value) {
        _numberController.text = value;
      },
      validator: (value) {
        if (value.isEmpty) {
          return "Phone number can't be empty";
        } else {
          return null;
        }
      },
      decoration: InputDecoration(
        hintText: "Phone number",
        prefixText: "(+855) ",
      ),
    );
  }

  _addTagWidget(BuildContext context) {
    return TextFormField(
      controller: _tagController,
      onSaved: (String value) {
        _tagController.text = value;
      },
      decoration: InputDecoration(
        hintText: "Tag",
      ),
    );
  }

  _listNumber(BuildContext context) {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.green[700], width: 1),
        borderRadius: BorderRadius.circular(20)
      ),
      child: FutureBuilder<List<PhoneNumber>>(
          future: _getPhoneNumber(),
          builder: (context, snapshot){
            if (snapshot.hasData) {
              final items = snapshot.data;
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    PhoneNumber item = items[index];
                    return InkWell(
                      onTap: () {
                        Navigator.of(context).pop(item);
                      },
                      child: Container(
                        child: Column(
                          children: <Widget>[
                            ListTile(
                              title: Text(item.number),
                              subtitle: Text(item.tag),
                              trailing: IconButton(icon: Image.asset("images/icon-06.png"), onPressed: () {
                                _dbPhoneNumber.removePhoneNumber(item.id);
                                setState(() {});
                              }),
                            ),
                            Divider(color: Colors.green,)
                          ],
                        ),
                      ),
                    );
                  }
              );
            } else {
              return Container();
            }
          }
      ),
    );
  }

}

