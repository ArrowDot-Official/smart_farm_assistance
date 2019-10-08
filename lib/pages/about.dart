import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school/view_model/language_view_model.dart';

class AboutPage extends StatelessWidget {

  final String aboutEng = "Smart farm assistance is the company that working and researching on IOT of agriculture. We are here to design the product for helping agriculture sector with the high quality and technology.";
  final String aboutKh = "ជំនួយការឆ្លាតវ័យរបស់កសិករ គឺជាក្រុមហ៊ុនដែលកំពុងធ្វើការនិងស្រាវជ្រាវ ទៅលើប្រព័ន្ធឆ្លាតវ័យនៅក្នុងកសិកម្ម ។ ពូកយើងមានតួនាទីផលិតនូវ ឧបករណ៍ផ្សេងៗដែលទាក់ទងនិងវិស័យកសិកម្មជាមួយនិងគុណភាព និងបច្ចេកវិទ្យាខ្ពស់ ។";

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<LanguageModel>(context);
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 100,),
          _titleWidget(context, provider),
          SizedBox(height: 50,),
          _infoWidget(context),
        ],
      ),
    );
  }
  
  _titleWidget(BuildContext context, LanguageModel provider) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width - 100,
        height: 50,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: Colors.green[700]
        ),
        child: Center(
          child: FutureBuilder(
            future: provider.translate("about"),
            builder: (context, snapshot) {
              String about = "About";
              if (snapshot.hasData) {
                about = snapshot.data;
              }
              return Container(
                child: Text(about, style: TextStyle(color: Colors.white, fontSize: 20),),
              );
            },
          ),
        ),
      ),
    );
  }
  
  _infoWidget(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 50, right: 50),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(aboutEng),
          SizedBox(height: 20,),
          Text(aboutKh)
        ],
      ),
    );
  }
  
}
