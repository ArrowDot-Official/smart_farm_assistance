import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school/database/db_phone_number.dart';
import 'package:school/models/phone_number.dart';
import 'package:school/view_model/language_view_model.dart';
import 'package:toast/toast.dart';

class UserSettingPage extends StatefulWidget {
  @override
  _UserSettingPageState createState() => _UserSettingPageState();
}

class _UserSettingPageState extends State<UserSettingPage> {
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
                UserController(context: context, model: model),

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
        future: model.translate("user_setting"),
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

class UserController extends StatefulWidget {
  final BuildContext context;
  final LanguageModel model;

  const UserController({Key key, this.context, this.model}) : super(key: key);
  @override
  _UserControllerState createState() => _UserControllerState();
}

class _UserControllerState extends State<UserController> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height,
        margin: EdgeInsets.only(left: 50, right: 50),
        child: ListView(
          children: <Widget>[

            ListOfUser(model: widget.model),
            Divider(color: Colors.green[700]),
            SizedBox(height: 50,),
            Center(
              child: FlatButton(
                onPressed: () {

                },
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(color: Colors.green[700], width: 1)
                  ),
                  child: FutureBuilder(
                    future: widget.model.translate("send"),
                    builder: (context, snapshot) {
                      String done = "SEND";
                      if (snapshot.hasData) {
                        done = snapshot.data;
                      }
                      return Center(
                        child: Text(done),
                      );
                    },
                  ),
                ),
              ),
            )
//            CreateUserWidget(model: widget.model)

          ],
        ),
      ),
    );
  }
}

class ListOfUser extends StatefulWidget {

  final LanguageModel model;
  const ListOfUser({Key key, this.model}) : super(key: key);

  @override
  _ListOfUserState createState() => _ListOfUserState();
}

class _ListOfUserState extends State<ListOfUser> {

  DBPhoneNumber _dbPhoneNumber = new DBPhoneNumber();
  TextEditingController _controller = new TextEditingController();

  Future<List<PhoneNumber>> _getPhoneNumber() async {
    List<PhoneNumber> list = await _dbPhoneNumber.getAllPhoneNumber();
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[

          FutureBuilder(
            future: widget.model.translate("user_number"),
            builder: (context, snapshot) {
              String unumber = "User Number";
              if (snapshot.hasData) {
                unumber = snapshot.data;
              }
              return Text(unumber, style: TextStyle(color: Colors.green[700], fontSize: 20));
            },
          ),
          SizedBox(height: 10),
          FutureBuilder<List<PhoneNumber>>(
            future: _getPhoneNumber(),
            builder: (context, snapshot) {
              List<PhoneNumber> phoneList = new List();
              if (snapshot.hasData) {
                phoneList = snapshot.data;
              }
              return Container(
                height: 200,
                child: ListView.builder(
                  itemCount: phoneList.length,
                  itemBuilder: (context, index) => _listPhoneNumber(phoneList[index]),
                ),
              );
            },
          ),
          Divider(color: Colors.green[700]),
          _createUserWidget(widget.model)

        ],
      ),
    );
  }

  _listPhoneNumber(PhoneNumber phoneNumber) {
    return Container(
      height: 70,
      child: Padding(
          padding: EdgeInsets.all(5),
          child: Flex(
            direction: Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(70),
                    border: Border.all(color: Colors.green[700], width: 2),
                  ),
                  child: Center(
                    child: Text(phoneNumber.number),
                  ),
                ),
              ),
              IconButton(
                icon: Image.asset("images/icon-06.png"),
                onPressed: () async {
                  await _dbPhoneNumber.removePhoneNumber(phoneNumber.id);
                  Toast.show("Phone number deleted", context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                  setState(() {});
                },
              )
            ],
          )
      ),
    );
  }
  
  _createUserWidget(LanguageModel model) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[

          FutureBuilder(
            future: widget.model.translate("add_number"),
            builder: (context, snapshot) {
              String anumber = "Add Number";
              if (snapshot.hasData) {
                anumber = snapshot.data;
              }
              return Text(anumber, style: TextStyle(color: Colors.green[700], fontSize: 20));
            },
          ),
          SizedBox(height: 10),

          Container(
            height: 70,
            child: Flex(
              direction: Axis.horizontal,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  child: Container(
                    child: Form(
                      child: Center(
                        child: FutureBuilder(
                          future: widget.model.translate("enter_number"),
                          builder: (context, snapshot) {
                            String hint = "";
                            if (snapshot.hasData) {
                              hint = snapshot.data;
                            }
                            return TextFormField(
                              controller: _controller,
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                hintText: hint,
                              ),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Can't be empty";
                                } else {
                                  return null;
                                }
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Image.asset("images/icon-07.png"),
                  onPressed: () async {
                    List<PhoneNumber> tags = await _dbPhoneNumber.getAllPhoneNumber();
                    int tag = tags.length + 1;
                    print(tag.toString());
                    int result = await _dbPhoneNumber.addPhoneNumber(new PhoneNumber(_controller.text, "$tag"));
                    _controller.clear();
                    setState(() {

                    });
                    Toast.show((result > 0 || result != null) ? "Phone number created" : "Error occured", context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                  },
                )
              ],
            ),
          )

        ],
      ),
    );
  }

}

class CreateUserWidget extends StatefulWidget {

  final LanguageModel model;
  const CreateUserWidget({Key key, this.model}) : super(key: key);

  @override
  _CreateUserWidgetState createState() => _CreateUserWidgetState();
}

class _CreateUserWidgetState extends State<CreateUserWidget> {

  TextEditingController _controller = new TextEditingController();

  DBPhoneNumber _dbPhoneNumber = new DBPhoneNumber();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[

          FutureBuilder(
            future: widget.model.translate("add_number"),
            builder: (context, snapshot) {
              String anumber = "Add Number";
              if (snapshot.hasData) {
                anumber = snapshot.data;
              }
              return Text(anumber, style: TextStyle(color: Colors.green[700], fontSize: 20));
            },
          ),
          SizedBox(height: 10),

          Container(
            height: 70,
            child: Padding(
                padding: EdgeInsets.all(5),
                child: Flex(
                  direction: Axis.horizontal,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(70),
                          border: Border.all(color: Colors.green[700], width: 1),
                        ),
                        child: Form(
                          child: Center(
                            child: FutureBuilder(
                              future: widget.model.translate("enter_number"),
                              builder: (context, snapshot) {
                                String hint = "";
                                if (snapshot.hasData) {
                                  hint = snapshot.data;
                                }
                                return TextFormField(
                                  controller: _controller,
                                  keyboardType: TextInputType.phone,
                                  decoration: InputDecoration(
                                    hintText: hint
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Image.asset("images/icon-07.png"),
                      onPressed: () async {
                        int result = await _dbPhoneNumber.addPhoneNumber(new PhoneNumber(_controller.text, ""));
                        _controller.clear();
                        setState(() {
                          
                        });
                        Toast.show((result > 0 || result != null) ? "Phone number created" : "Error occured", context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                      },
                    )
                  ],
                )
            ),
          )

        ],
      ),
    );
  }
}



