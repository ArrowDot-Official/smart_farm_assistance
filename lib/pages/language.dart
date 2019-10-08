import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school/models/languauge_model.dart';
import 'package:school/view_model/language_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguagePage extends StatefulWidget {
  @override
  _LanguagePageState createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {

  List<Language> languages = new List();
  String lang = "";

  @override
  void setState(fn) {
    // TODO: implement setState
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    var model = Provider.of<LanguageModel>(context);
    languages.add(new Language(model.lang == "kh" ? true : false, "ភាសាខ្មែរ", "kh"));
    languages.add(new Language(model.lang == "en" ? true : false, "English", "en"));

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
                _chooseLanguage(context, model),
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
      future: model.translate("language"),
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

  _chooseLanguage(BuildContext context, LanguageModel model) {
    return Container(
      height: 500,
      margin: EdgeInsets.only(left: 50, right: 50),
      child: ListView.separated(
        separatorBuilder: (context, index) => Divider(color: Colors.green[700]),
        itemCount: 2,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () async {
              SharedPreferences pref = await SharedPreferences.getInstance();
              setState(() {
                languages.forEach((l) => l.isSelected = false);
                languages[index].isSelected = true;
                lang = languages[index].value;
                model.changeLanguage(lang);
                pref.setString("language", lang);
              });
            },
            child: RadioItem(item: languages[index])
          );
        },
      ),
    );
  }
}

class RadioItem extends StatelessWidget {

  final Language item;
  const RadioItem({Key key, this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: ListTile(
        title: Text(item.text),
        trailing: item.isSelected ? Image.asset("images/icon-22.png") : Image.asset("images/icon-23.png"),
      ),
    );
  }
}




