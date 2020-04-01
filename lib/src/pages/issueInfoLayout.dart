import 'dart:convert';

import 'package:flutter/material.dart';
import '../models/issueInfo.dart';
import 'package:http/http.dart' as http;

class IssueInfoLayout extends StatelessWidget {
  final int id;
  static final String routeName = 'info';
  const IssueInfoLayout({Key key, this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text('Información'),
      ),
      body: new FutureBuilder(
          future: getInfo(id.toString()),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return new Container(
                height: 250,
                alignment: Alignment.center,
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(
                      valueColor: new AlwaysStoppedAnimation<Color>(
                          Theme.of(context).primaryColor),
                    ),
                  ],
                ),
              );
            } else {
              return new ListView(
                children: <Widget>[
                  new Padding(
                    padding:
                        new EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: new Text(
                      snapshot.data.name,
                      style: new TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 33,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  new Padding(
                    padding:
                        new EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: new Text(
                      snapshot.data.profName,
                      style: new TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  new Padding(
                    padding:
                        new EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: new Text(
                      snapshot.data.description,
                      style: new TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  new Padding(
                    padding:
                        new EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: new Text(
                      snapshot.data.medicalCondition,
                      style: new TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  new Padding(
                    padding:
                        new EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: new Text(
                      snapshot.data.treatment,
                      style: new TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  new Padding(
                    padding:
                        new EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: new Text(
                      'Sintomas relacionados :',
                      style: new TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  new Padding(
                      padding: new EdgeInsets.symmetric(
                          horizontal: 0, vertical: 10),
                      child: new Container(
                        alignment: Alignment.topCenter,
                        height: 40,
                        child: new ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data.possibleSymptoms
                              .toString()
                              .split(',')
                              .length,
                          itemBuilder: (context, index) {
                            return new Padding(
                                padding:
                                    new EdgeInsets.symmetric(horizontal: 5),
                                child: new Chip(
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  label: new Text(
                                      snapshot.data.possibleSymptoms
                                          .toString()
                                          .split(',')[index],
                                      style: TextStyle(color: Colors.white)),
                                ));
                          },
                        ),
                      )),
                ],
              );
            }
          }),
    );
  }

  Future<IssueInfo> getInfo(String id) async {
    String url =
        'https://priaid-symptom-checker-v1.p.rapidapi.com/issues/$id/info?language=es-es&format=json';
    Map<String, String> headers = {
      "x-rapidapi-host": 'priaid-symptom-checker-v1.p.rapidapi.com',
      "x-rapidapi-key": 'd3ee42e476msh1a9257b1255ff2fp10bac7jsnbda69fd8a290',
    };
    http.Response response = await http.get(url, headers: headers);
    //print(response.body);
    var responseJson = jsonDecode(response.body);
    print(responseJson);
    return new IssueInfo.fromJson(responseJson);
  }
}
