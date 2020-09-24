import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:klimatic/api.dart' as api;
import 'package:klimatic/changecity.dart';
class weather extends StatefulWidget{
  weather({Key key}): super(key:key);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ui();
  }
}
class ui extends State<weather> {

  void show() async {
    Map data = await getData();
  }

  Future change() async {
    Map result = await Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) {
          return new changecity();
        }

    ));
    setState(() {
      api.city = result["city"];
    });
  }
  Image b;
  @override
  void initState() {
    // TODO: implement initState
    /*

          Image.asset("images/background.jpg", width: 500,
            height: 1300,
            fit: BoxFit.fill,),
     */
    super.initState();

    b=Image.asset("images/background.jpg",width: 600,height: 1000,fit: BoxFit.fill,);
  }
  @override
  void didChangeDependencies() {

    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    precacheImage(b.image, context);
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    String abc = api.city.replaceAll("+", " ");
    return Scaffold(

      appBar: AppBar(
        title: Text("Weather App"),
        backgroundColor: Colors.grey,
        actions: <Widget>[
          FlatButton(onPressed: () {
            change();
          }, child: new Icon(Icons.menu,),)
        ],
      ),
      body: Stack(
        children: <Widget>[
          b,
          Container(
            alignment: Alignment.topRight,
            margin: EdgeInsets.all(10.0),
            child: Text(abc, style: TextStyle(color: Colors.white,
                fontSize: 30,
                fontStyle: FontStyle.italic),),
          )
          ,
          Container(
            alignment: Alignment.center,
            child: updatedata(),
          )

        ],
      ),
    );
  }

  Future<Map> getData() async {
    String url = "http://api.openweathermap.org/data/2.5/weather?q=${api
        .city}&appid=${api.api}&units=metric";
    http.Response data = await http.get(url);
      return json.decode(data.body);
  }

  style() =>
      TextStyle(color: Colors.red, fontSize: 30, fontWeight: FontWeight.bold);

  Widget updatedata() {
    return RefreshIndicator(
      child: FutureBuilder(future: getData(),
          builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
            if (snapshot.hasData == true) {
              var data = snapshot.data;
              if(data["cod"]=="404"){
                return Text("No such  city/country",style: style(),);
              }
              return Container(
                  padding: EdgeInsets.all(10.0),
                  alignment: Alignment.bottomLeft,
                  child: ListView(
                    padding: EdgeInsets.fromLTRB(0, 100, 0, 0),
                    children: <Widget>[
                      ListTile(

                        title: Text("Temp : ${data["main"]["temp"].toString()}",
                          style: style(),
                        ),

                      ),
                      ListTile(
                        title: Text(
                          "Weather : ${data["weather"][0]["main"].toString()}",
                          style: style(),),
                      ),
                      Center(
                          child: Image.asset(
                            data["weather"][0]["main"].toString() ==
                                "drizzle" ||
                                data["weather"][0]["main"] == "Rain"
                                ? "images/drizzle.png"
                                : data["weather"][0]["main"] == "Haze" ||
                                data["weather"][0]["main"] == "Mist"
                                ? "images/haze.png"
                                : data["weather"][0]["main"] == "Clouds"
                                ? "images/clouds.png"
                                : "", height: 200,
                            width: 300,
                            color: Colors.blue,)
                      )
                    ],
                  )

              );
            }
            else {
              return Container(
                margin: EdgeInsets.all(30.0),
                child: Text("Loading....", style: TextStyle(color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: 40),),
              );
            }
          }),
      onRefresh:getData,
    );
  }

}