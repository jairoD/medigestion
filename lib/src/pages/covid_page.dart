import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Covid extends StatefulWidget {
  static final String routeName = 'covid';
  Covid({Key key}) : super(key: key);

  @override
  _CovidState createState() => _CovidState();
}

class _CovidState extends State<Covid> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Color(0xffF2F5F9),
      appBar: AppBar(
        backgroundColor: Color(0xffF2F5F9),
        elevation: 0.0,
        brightness: Brightness.light,
        iconTheme:
            IconThemeData(color: Color.fromRGBO(52, 54, 101, 1.0), size: 30),
      ),
      body: new ListView(
        children: <Widget>[
          new Text(
            'Covid-19 Colombia',
            style: new TextStyle(
                color: Color.fromRGBO(52, 54, 101, 1.0),
                fontSize: 28,
                fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          new Padding(padding: EdgeInsets.only(bottom: 30)),
          new Row(
            children: <Widget>[
              new Padding(
                padding: EdgeInsets.all(4),
                child: new Container(
                  width: (MediaQuery.of(context).size.width / 2) - 10,
                  height: 100,
                  decoration: new BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(30),
                    color: Color.fromRGBO(52, 54, 101, 1.0),
                  ),
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      new Text('Infectados: ',
                          style: new TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold)),
                      new FutureBuilder(
                          future: getAll(),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.data == null) {
                              return new CircularProgressIndicator(
                                valueColor: new AlwaysStoppedAnimation<Color>(
                                    Colors.white),
                              );
                            } else if (snapshot.hasError) {
                              return Text(
                                "ERROR: " + snapshot.error.toString(),
                              );
                            } else {
                              return new Text(snapshot.data,
                                  style: new TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold));
                            }
                          })
                    ],
                  ),
                ),
              ),
              new Padding(
                padding: EdgeInsets.all(4),
                child: new Container(
                  width: (MediaQuery.of(context).size.width / 2) - 10,
                  height: 100,
                  decoration: new BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(30),
                    color: Color.fromRGBO(52, 54, 101, 1.0),
                  ),
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      new Text('Recuperados: ',
                          style: new TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold)),
                      new FutureBuilder(
                          future: getR(),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.data == null) {
                              return new CircularProgressIndicator(
                                valueColor: new AlwaysStoppedAnimation<Color>(
                                    Colors.white),
                              );
                            } else if (snapshot.hasError) {
                              return Text(
                                "ERROR: " + snapshot.error.toString(),
                              );
                            } else {
                              return new Text(snapshot.data,
                                  style: new TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold));
                            }
                          })
                    ],
                  ),
                ),
              ),
            ],
          ),
          new Row(
            children: <Widget>[
              new Padding(
                padding: EdgeInsets.all(4),
                child: new Container(
                  width: (MediaQuery.of(context).size.width / 2) - 10,
                  height: 100,
                  decoration: new BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(30),
                    color: Color.fromRGBO(52, 54, 101, 1.0),
                  ),
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      new Text('Muertes: ',
                          style: new TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold)),
                      new FutureBuilder(
                          future: getM(),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.data == null) {
                              return new CircularProgressIndicator(
                                valueColor: new AlwaysStoppedAnimation<Color>(
                                    Colors.white),
                              );
                            } else if (snapshot.hasError) {
                              return Text(
                                "ERROR: " + snapshot.error.toString(),
                              );
                            } else {
                              return new Text(snapshot.data,
                                  style: new TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold));
                            }
                          })
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Future<String> getAll() async {
    String url = 'https://www.datos.gov.co/resource/gt2j-8ykr.json?\$' +
        'select' +
        '=count(id_de_caso)';
    var params = {'format': 'json', 'language': 'es-es'};
    Map<String, String> headers = {
      "X-App-Token": '5iOVFz2oJKIvMGqHBYiN9mCzd',
    };
    http.Response response = await http.get(url, headers: headers);
    List<dynamic> data = jsonDecode(response.body);
    print(data[0]['count_id_de_caso']);
    return data[0]['count_id_de_caso'].toString();
  }

  Future<String> getR() async {
    String url = 'https://www.datos.gov.co/resource/gt2j-8ykr.json?\$' +
        'select' +
        '=count(id_de_caso)&atenci_n=Recuperado';
    var params = {'format': 'json', 'language': 'es-es'};
    Map<String, String> headers = {
      "X-App-Token": '5iOVFz2oJKIvMGqHBYiN9mCzd',
    };
    http.Response response = await http.get(url, headers: headers);
    List<dynamic> data = jsonDecode(response.body);
    print(data[0]['count_id_de_caso']);
    return data[0]['count_id_de_caso'].toString();
  }
  Future<String> getM() async {
    String url = 'https://www.datos.gov.co/resource/gt2j-8ykr.json?\$' +
        'select' +
        '=count(id_de_caso)&atenci_n=Fallecido';
    var params = {'format': 'json', 'language': 'es-es'};
    Map<String, String> headers = {
      "X-App-Token": '5iOVFz2oJKIvMGqHBYiN9mCzd',
    };
    http.Response response = await http.get(url, headers: headers);
    List<dynamic> data = jsonDecode(response.body);
    print(data[0]['count_id_de_caso']);
    return data[0]['count_id_de_caso'].toString();
  }
}
