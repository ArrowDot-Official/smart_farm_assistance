
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:school/database/db_device.dart';
import 'package:school/database/db_motor.dart';
import 'package:school/database/db_valve.dart';
import 'package:school/models/device.dart';
import 'package:school/models/motor.dart';
import 'package:school/models/phone_number.dart';
import 'package:school/models/valve.dart';
import 'package:school/view_model/language_view_model.dart';
import 'package:toast/toast.dart';
import 'dart:math' as math;

import 'add_number_dialog.dart';

class CreateMotor extends StatefulWidget {

  final LanguageModel model;
  const CreateMotor({Key key, this.model}) : super(key: key);

  @override
  _CreateMotorState createState() => _CreateMotorState();
}

class _CreateMotorState extends State<CreateMotor> {

  DBMotor _dbMotor = new DBMotor();
  DBValve _dbValve = new DBValve();
  DBDevice _dbDevice = new DBDevice();

  String _tag = '';

  Future _getMotors() async {
    List<Device> d = await _dbDevice.getAllDevice();
    return d;
  }

  TextEditingController _numberController = new TextEditingController();
  TextEditingController _nameController = new TextEditingController();

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
            future: widget.model.translate("add_device"),
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
              height: 250,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.green[700], width: 2),
              ),
              child: Form(
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: <Widget>[
                      FutureBuilder(
                        future: widget.model.translate("device_name"),
                        builder: (context, snapshot) {
                          String hint = "Motor name";
                          if (snapshot.hasData) {
                            hint = snapshot.data;
                          }
                          return TextFormField(
                            controller: _nameController,
                            decoration: InputDecoration(
                                hintText: hint,
                                hoverColor: Colors.green[700]
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 25,),

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
                            List<Device> tags = await _dbDevice.getAllDevice();
                            print("TAGS =======> " + tags.toString());
                            int tag;
                            if (tags != null) {
                              if (tags.length == 0) {
                                tag = 1;
                              } else {
                                tag = tags.last.id + 1;
                              }
                            }

                            print("TAG NUMBER =======> " + tag.toString());
                            if (_tag == "") {
                              Toast.show("Please select one type", context, duration: 5, gravity: Toast.BOTTOM);
                              return;
                            }
                            int result = await _dbDevice.addDevice(new Device(_nameController.text, _numberController.text, "off", _tag, "", "$tag"));
                            _tag = "";
//                            if (_tag == "motor") {
//                              result = await _dbMotor.addMotor(new Motor(
//                                  _nameController.text, _numberController.text,
//                                  "off", "", "$tag"));
//                            } else if (_tag == "valve") {
//                              result = await _dbValve.addValve(new Valve(_nameController.text, _numberController.text,
//                                  "off", "", "$tag"));
//                            }
                            
                            _numberController.clear();
                            _nameController.clear();
                            Toast.show((result > 0 || result != null) ? "Device Created" : "Error occured", context, duration: 5, gravity: Toast.BOTTOM);
                            setState(() {

                            });
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
              )
          ),
          SizedBox(height: 20,),

          FutureBuilder(
            future: widget.model.translate("number_of_motor"),
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
            future: _getMotors(),
            builder: (context, snapshot) {
              List list = List();
              if (snapshot.hasData) {
                list = snapshot.data;
              }
              return Container(
                height: 200,
                child: ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, index) => _listMotorWidget(list[index]),
                ),
              );
            },
          )

        ],
      ),
    );
  }

  _getOrRegisterNumber(BuildContext context) {
    return InkWell(
      onTap: () async {
        PhoneNumber number = await _getNumber(context);
        _numberController.text = number.number;
        _tag = number.tag;
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

  Future<PhoneNumber> _getNumber(BuildContext context) async {
    return showDialog<PhoneNumber>(
        context: context,
        barrierDismissible: false,
        builder: (context) => AddNumberDialog()
    );
  }

  _listMotorWidget(Device device) {
    return Container(
      height: 100,
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
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.green[700], width: 2),
                  ),
                  child: Center(
                    child: ListTile(
                      title: Text(device.name),
                      subtitle: Text(device.type),
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: Image.asset("images/icon-06.png"),
                onPressed: () async {
                  await _dbDevice.removeDevice(device.id);
                  _numberController.clear();
                  Toast.show("Device deleted", context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
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


