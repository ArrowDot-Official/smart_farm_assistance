import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:school/database/db_valve.dart';
import 'package:school/models/valve.dart';
import 'package:school/ui/add_number_dialog.dart';
import 'package:school/view_model/language_view_model.dart';
import 'package:toast/toast.dart';

class CreateValve extends StatefulWidget {

  final LanguageModel model;
  const CreateValve({Key key, this.model}) : super(key: key);

  @override
  _CreateValveState createState() => _CreateValveState();
}

class _CreateValveState extends State<CreateValve> {

  DBValve _dbValve = new DBValve();

  Future<List<Valve>> _getValve() async {
    List<Valve> m = await _dbValve.getAllValve();
    return m;
  }

  GlobalKey<FormState> _key = new GlobalKey();

  TextEditingController _nameController = new TextEditingController();
  TextEditingController _numberController = new TextEditingController();
  TextEditingController _tagController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[

          _getOrRegisterNumber(context),
          SizedBox(height: 20,),

          FutureBuilder(
            future: widget.model.translate("add_valve"),
            builder: (context, snapshot) {
              String addMotor = "";
              if (snapshot.hasData) {
                addMotor = snapshot.data;
              }
              return Text(addMotor, style: TextStyle(color: Colors.green[700]),);
            },
          ),
          SizedBox(height: 20,),

          Container(
              height: 260,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.green[700], width: 2),
              ),
              child: Form(
                key: _key,
                child: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: <Widget>[
                        FutureBuilder(
                          future: widget.model.translate("valve_name"),
                          builder: (context, snapshot) {
                            String hint = "Valve name";
                            if (snapshot.hasData) {
                              hint = snapshot.data;
                            }
                            return TextFormField(
                              controller: _nameController,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "This field can't be empty";
                                } else {
                                  return null;
                                }
                              },
                              decoration: InputDecoration(
                                hintText: hint,
                                hoverColor: Colors.green[700]
                              ),
                            );
                          },
                        ),
                        SizedBox(height: 10,),

                        TextFormField(
                          controller: _numberController,
                          keyboardType: TextInputType.phone,
                          inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Phone number can't be empty";
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                            hintText: "i.e +85511223344",
                            hoverColor: Colors.green[700],
                          ),
                        ),

                        SizedBox(height: 25,),
                        Center(
                          child: FlatButton(
                            onPressed: () async {
                              //TODO: Create Motor
                              FormState formState = _key.currentState;
                              if (formState.validate()) {
                                formState.save();
                                print(_numberController.text);

                                List<Valve> tags = await _dbValve.getAllValve();
                                print("TAGS =======> " + tags.toString());
                                int tag;
                                if (tags.length == 0) {
                                  tag = 1;
                                } else {
                                  tag = tags.last.id + 1;
                                }

                                print("TAG NUMBER =======> " + tag.toString());
                                int result = await _dbValve.addValve(new Valve(
                                    _nameController.text, _numberController.text,
                                    "off", "", "$tag"));
                                _nameController.clear();
                                _numberController.clear();
                                _tagController.clear();
                                Toast.show((result > 0 || result != null)
                                    ? "Valve Created"
                                    : "Error occured", context, duration: 5,
                                    gravity: Toast.BOTTOM);
                                setState(() {});
                              }
                            },
                            child: Container(
                                height: 30,
                                width: 100,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.green[700]
                                ),
                                child: FutureBuilder(
                                  future: widget.model.translate("done"),
                                  builder: (context, snapshot) {
                                    String done = "Done";
                                    if (snapshot.hasData) {
                                      done = snapshot.data;
                                    }
                                    return Center(child: Text(done, style: TextStyle(color: Colors.white),));
                                  },
                                )
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
          ),
          SizedBox(height: 20,),

          FutureBuilder(
            future: widget.model.translate("number_of_valve"),
            builder: (context, snapshot) {
              String motorNumber = "";
              if (snapshot.hasData) {
                motorNumber = snapshot.data;
              }
              return Text(motorNumber, style: TextStyle(color: Colors.green[700]),);
            },
          ),
          SizedBox(height: 20),

          FutureBuilder(
            future: _getValve(),
            builder: (context, snapshot) {
              List<Valve> list = List();
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
    );
  }

  Future<String> _getNumber(BuildContext context) async {
    return showDialog<String>(
        context: context,
        barrierDismissible: false,
        builder: (context) => AddNumberDialog()
    );
  }

  _getOrRegisterNumber(BuildContext context) {
    return InkWell(
      onTap: () async {
        _numberController.text = await _getNumber(context);
        setState(() {});
      },
      child: Container(
        height: 50,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.green[700], width: 2),
            borderRadius: BorderRadius.circular(50)
        ),
        child: Center(
          child: FutureBuilder(
            future: widget.model.translate("add_number"),
            builder: (context, snapshot) {
              String addNumber = "Add number";
              if (snapshot.hasData) {
                addNumber = snapshot.data;
              }
              return Text(addNumber,);
            },
          ),
        ),
      ),
    );
  }

  _listValveWidget(Valve valve) {
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
                    child: Text(valve.name,),
                  ),
                ),
              ),
              IconButton(
                icon: Image.asset("images/icon-06.png"),
                onPressed: () async {
                  await _dbValve.removeValve(valve.id);
                  _nameController.clear();
                  Toast.show("Valve deleted", context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                  setState(() {

                  });
                },
              )
            ],
          )
      ),
    );
  }
}