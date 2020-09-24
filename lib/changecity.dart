import 'package:flutter/material.dart';
class changecity extends StatefulWidget {
  @override
  _changecityState createState() => _changecityState();
}

class _changecityState extends State<changecity> {
  var chngcity=new TextEditingController();
  String check(){
    return chngcity.text.replaceAll(" ", "+");
  }
  Image ba;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ba=Image.asset("images/back.jpg",width: 600,height: 1100,fit: BoxFit.fill,);
  }
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    precacheImage(ba.image, context);
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Weather App"),
        backgroundColor:Colors.red,
      ),
body: Stack(
  children: <Widget>[
    ba,
    Container(
      padding: EdgeInsets.fromLTRB(0,10,0,0),
      child: ListView(
        children: <Widget>[
          TextField(
            controller: chngcity,
            decoration: InputDecoration(
              hintText: "Enter Your City",
              icon: Icon(Icons.location_city)
            ),
            keyboardType: TextInputType.text,
          ),
          Text("")
          ,RaisedButton(onPressed: (){
            Navigator.pop(context,{"city":check()});
          },child: Text("Submit"),color: Colors.red,)
        ],
      ),
    )
  ],
),
    );
  }
}
