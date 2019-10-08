import 'package:flutter/material.dart';
import 'package:school/database/db_phone_number.dart';
import 'package:school/models/phone_number.dart';

import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:toast/toast.dart';

class ViewPhoneNumber extends StatefulWidget {
  @override
  _ViewPhoneNumberState createState() => _ViewPhoneNumberState();
}

class _ViewPhoneNumberState extends State<ViewPhoneNumber> {

  DBPhoneNumber _dbPhoneNumber = new DBPhoneNumber();

  Future<List<PhoneNumber>> _getPhoneNumber() async {
    List<PhoneNumber> num = await _dbPhoneNumber.getAllPhoneNumber();
    return num;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getPhoneNumber();
  }

  @override
  Widget build(BuildContext context) {
    _getPhoneNumber();
    return Dialog(
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      backgroundColor: Colors.white,
      child: FutureBuilder<List<PhoneNumber>>(
        future: _getPhoneNumber(),
        builder: (context, snapshot){
          if (snapshot.hasData) {
            final items = snapshot.data;
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return Slidable(
                  actionPane: SlidableBehindActionPane(),
                  actionExtentRatio: 0.25,
                  child: Container(
                    color: Colors.white,
                    child: ListTile(
                      title: Text(item.number),
                      subtitle: Text(item.tag),
                    ),
                  ),
                  secondaryActions: <Widget>[
                    IconSlideAction(
                      caption: 'Edit',
                      color: Colors.blue,
                      icon: Icons.edit,
                      onTap: () {

                      },
                    ),

                    IconSlideAction(
                      caption: 'Delete',
                      color: Colors.red,
                      icon: Icons.delete,
                      onTap: () {
                        setState(() {
                          items.removeAt(index);
                          _dbPhoneNumber.removePhoneNumber(item.id);
                        });
                        // Then show a snackbar.
                        Toast.show("${item.number} removed", context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                      },
                    ),
                  ],
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
