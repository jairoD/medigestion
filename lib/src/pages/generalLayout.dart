import 'dart:convert';

import 'package:circular_check_box/circular_check_box.dart';
import 'package:flutter/material.dart';
import 'package:medigestion/src/models/issue.dart';
import 'package:medigestion/src/models/sintoma.dart';
import 'package:http/http.dart' as http;
import 'package:medigestion/src/pages/diagnosticosLayout.dart';
import 'dart:math';

import 'package:medigestion/src/pages/issueInfoLayout.dart';

class GeneralLayout extends StatefulWidget {
  static final routeName = 'general';
  GeneralLayout({Key key}) : super(key: key);

  @override
  _GeneralLayoutState createState() => _GeneralLayoutState();
}

class _GeneralLayoutState extends State<GeneralLayout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF2F5F9),
      appBar: AppBar(
        backgroundColor: Color(0xffF2F5F9),
        elevation: 0.0,
        brightness: Brightness.light,
        iconTheme:
            IconThemeData(color: Color.fromRGBO(52, 54, 101, 1.0), size: 30),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.assignment),
              color: Color.fromRGBO(52, 54, 101, 1.0),
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: Datasearch(),
                );
              })
        ],
      ),
      body: new ListView(
        children: <Widget>[
          new Container(
            height: 200,
            alignment: Alignment.center,
            child: new Row(
              children: <Widget>[
                new Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: new Text(
                          'Diagnosticos',
                          style: new TextStyle(
                              fontSize: 34,
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(52, 54, 101, 1.0)),
                        ),
                      ),
                      new Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: new Text(
                          'Encuentra informacion acerca de diferentes enfermedades, realiza tu diagnostico segun los sintomas que presentes.',
                          style: new TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                ),
                new Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: new Image.asset(
                      'assets/img/diag.png',
                      width: 130,
                      height: 130,
                    )),
              ],
            ),
          ),
          new Padding(
            padding: EdgeInsets.only(left: 10, bottom: 10),
            child: new Text(
              'Explorar',
              style: new TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(52, 54, 101, 1.0)),
            ),
          ),
          new Container(
            height: 170,
            child: FutureBuilder(
              future: getIssues(),
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
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      "ERROR: " + snapshot.error.toString(),
                    ),
                  );
                } else if (snapshot.data.length == 0) {
                  return Center(
                    child: Text(
                      "Error al cargar",
                    ),
                  );
                } else {
                  return new ListView.builder(
                    padding: EdgeInsets.only(right: 15),
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return new Padding(
                        padding: EdgeInsets.only(left: 15, top: 15, bottom: 15),
                        child: Container(
                            height: 100,
                            width: 150,
                            padding: EdgeInsets.all(10),
                            child: new Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                new Text(
                                  snapshot.data[index].name,
                                  maxLines: 2,
                                  style: new TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromRGBO(52, 54, 101, 1.0)),
                                  textAlign: TextAlign.start,
                                ),
                                new Center(
                                  child: RaisedButton(
                                    shape: new RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(10.0),
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  IssueInfoLayout(
                                                    id: snapshot.data[index].id,
                                                  )));
                                    },
                                    color: Color.fromRGBO(52, 54, 101, 1.0),
                                    textColor: Colors.white,
                                    child: Text("Ver mas",
                                        style: TextStyle(fontSize: 14)),
                                  ),
                                )
                              ],
                            ),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white)),
                      );
                    },
                  );
                }
              },
            ),
          ),
          new Container(
            height: 200,
            margin: EdgeInsets.only(left: 15),
            alignment: Alignment.centerLeft,
            child: new Stack(
              overflow: Overflow.visible,
              children: <Widget>[
                new Container(
                  height: 130,
                  constraints: BoxConstraints(maxWidth: 270),
                  margin: EdgeInsets.only(left: 30),
                  width: MediaQuery.of(context).size.width * 0.75,
                  alignment: Alignment.centerRight,
                  child: new Container(
                    height: 110,
                    width: MediaQuery.of(context).size.width * 0.75,
                    alignment: Alignment.centerRight,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.white,
                    ),
                    child: new Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: new Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          new Text(
                            'Covid-19',
                            style: new TextStyle(
                                color: Color.fromRGBO(52, 54, 101, 1.0),
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          new RaisedButton(
                            shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(10.0),
                            ),
                            onPressed: () {},
                            color: Color.fromRGBO(52, 54, 101, 1.0),
                            textColor: Colors.white,
                            child: Text("Conocer mas",
                                style: TextStyle(fontSize: 14)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                new Container(
                  height: 130,
                  width: 130,
                  decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red,
                      image: DecorationImage(
                          image: AssetImage('assets/img/covid.jpg'),
                          fit: BoxFit.cover)),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<List<Issue>> getIssues() async {
    List<Issue> respuesta = [];
    String url =
        'https://priaid-symptom-checker-v1.p.rapidapi.com/issues?format=json&language=es-es';
    Map<String, String> headers = {
      "x-rapidapi-host": 'priaid-symptom-checker-v1.p.rapidapi.com',
      "x-rapidapi-key": 'd3ee42e476msh1a9257b1255ff2fp10bac7jsnbda69fd8a290',
    };
    http.Response response = await http.get(url, headers: headers);
    List<dynamic> responseJson = jsonDecode(response.body);
    responseJson.shuffle();
    for (var item in responseJson) {
      respuesta.add(new Issue.fromJson(item));
    }
    return respuesta;
  }
}

class Datasearch extends SearchDelegate<String> {
  static final routeName = 'general';
  List<Issue> issues = new List();
  List<Sintoma> sintoma;
  List<String> sintomaName;
  List<int> sintomaId;
  int generoI = 0;
  double _value = 0;
  int go = 0;
  @override
  ThemeData appBarTheme(BuildContext context) {
    assert(context != null);
    final ThemeData theme = Theme.of(context);
    assert(theme != null);
    return theme;
  }

  Datasearch() {}

  @override
  // TODO: implement searchFieldLabel
  String get searchFieldLabel => '¿Cuáles son tus síntomas?';
  List<String> data = new List();
  List<int> sintomasIds = new List();
  @override
  List<Widget> buildActions(BuildContext context) {
    if (query.isNotEmpty) {
      return [
        IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {
              showResults(context);
              query = "";
            }),
      ];
    } else
      return null;
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: AnimatedIcon(
            icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    return new StatefulBuilder(
      builder: (BuildContext context, setState) {
        return new ListView(
          children: <Widget>[
            new Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: new Text(
                'Síntomas actuales: ',
                style: new TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
            ),
            new Container(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              alignment: Alignment.centerLeft,
              child: new Wrap(
                direction: Axis.horizontal,
                spacing: 3,
                runSpacing: 0,
                children: List<Widget>.generate(data.length, (int index) {
                  return new Chip(
                    shadowColor: Theme.of(context).primaryColor,
                    elevation: 5,
                    backgroundColor: Theme.of(context).primaryColor,
                    label: new Text(
                      data[index],
                      style: TextStyle(color: Colors.white),
                    ),
                    deleteIcon: new Icon(
                      Icons.cancel,
                      color: Colors.white,
                    ),
                    onDeleted: () {
                      setState(() {
                        data.removeAt(index);
                        sintomasIds.removeAt(index);
                      });
                    },
                  );
                }),
              ),
            ),
            new Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: new Text(
                'Género: ',
                style: new TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
            ),
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                new Text(
                  'Masculino ',
                  style: new TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
                new CircularCheckBox(
                  activeColor: Theme.of(context).primaryColor,
                  value: generoI == 0 ? true : false,
                  onChanged: (value) {
                    setState(() {
                      if (generoI == 0) {
                        generoI = 1;
                      } else {
                        generoI = 0;
                      }
                    });
                  },
                  tristate: false,
                ),
                new Text(
                  'Femenino',
                  style: new TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
                new CircularCheckBox(
                  value: generoI == 0 ? false : true,
                  onChanged: (value) {
                    setState(() {
                      if (generoI == 1) {
                        generoI = 0;
                      } else {
                        generoI = 1;
                      }
                    });
                  },
                  activeColor: Theme.of(context).primaryColor,
                ),
              ],
            ),
            new Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: new Text(
                'Fecha de nacimiento: ' + (_value + 1920).toInt().toString(),
                style: new TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
            ),
            new Padding(
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 15),
              child: Slider(
                min: 0,
                max: 100,
                divisions: 100,
                activeColor: Theme.of(context).primaryColor,
                inactiveColor: Colors.grey[300],
                label: '' + (_value + 1920).toInt().toString(),
                value: _value,
                onChanged: (value) {
                  setState(() {
                    _value = value;
                  });
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width / 4,
                  vertical: 15),
              child: new RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18)),
                color: Theme.of(context).primaryColor,
                onPressed: () {
                  setState(() {
                    print(_value.toInt() + 1920);
                    print(generoI == 0 ? 'male' : 'female');
                    print(sintomasIds);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DiagnosticosLayout(
                                  year: _value.toInt() + 1920,
                                  genero: generoI == 0 ? 'male' : 'female',
                                  sintomas: sintomasIds,
                                )));
                    //go = 1;
                  });
                  //issues.clear();
                  //getDiagnostico(issues, _value.toInt() + 1920, sintomasIds,
                  //    generoI == 0 ? 'male' : 'female');
                },
                splashColor: Color.fromRGBO(59, 63, 109, 1.0),
                child: new Text('Diagnosticar',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16)),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    /*
    final suggestionList = sintomaName.where((p) => p.contains(query)).toList();
    return new ListView.builder(
      itemBuilder: (context, index) {
        return new ListTile(
          onTap: () {
            if (!data.contains(suggestionList[index])) {
              data.add(suggestionList[index]);
              for (var item in sintoma) {
                if (item.name.toLowerCase() == suggestionList[index]) {
                  sintomasIds.add(item.id);
                }
              }
              showResults(context);
              query = '';
            }
          },
          title: new RichText(
            text: new TextSpan(
                text: suggestionList[index]
                    .substring(0, suggestionList[index].indexOf(query)),
                style: new TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 14),
                children: [
                  new TextSpan(
                    text: suggestionList[index].substring(
                        suggestionList[index].indexOf(query),
                        suggestionList[index].indexOf(query) + query.length),
                    style: new TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                  new TextSpan(
                    text: suggestionList[index].substring(
                        suggestionList[index].indexOf(query) + query.length,
                        suggestionList[index].length),
                    style: new TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: 14),
                  ),
                ]),
          ),
        );
      },
      itemCount: suggestionList.length,
    );
    */
    return FutureBuilder(
      future: getSintomas(),
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
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              "ERROR: " + snapshot.error.toString(),
            ),
          );
        } else if (snapshot.data.length == 0) {
          return Center(
            child: Text(
              "No es posible establecer un diagnostico con los datos ingresados",
            ),
          );
        } else {
          List<String> list = convert(snapshot.data);
          final suggestionList = list.where((p) => p.contains(query)).toList();
          return new ListView.builder(
            itemBuilder: (context, index) {
              return new ListTile(
                onTap: () {
                  if (!data.contains(suggestionList[index])) {
                    data.add(suggestionList[index]);
                    for (var item in snapshot.data) {
                      if (item.name.toLowerCase() == suggestionList[index]) {
                        sintomasIds.add(item.id);
                      }
                    }
                    showResults(context);
                    query = '';
                  }
                },
                title: new RichText(
                  text: new TextSpan(
                      text: suggestionList[index]
                          .substring(0, suggestionList[index].indexOf(query)),
                      style: new TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 14),
                      children: [
                        new TextSpan(
                          text: suggestionList[index].substring(
                              suggestionList[index].indexOf(query),
                              suggestionList[index].indexOf(query) +
                                  query.length),
                          style: new TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                        new TextSpan(
                          text: suggestionList[index].substring(
                              suggestionList[index].indexOf(query) +
                                  query.length,
                              suggestionList[index].length),
                          style: new TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                        ),
                      ]),
                ),
              );
            },
            itemCount: suggestionList.length,
          );
        }
      },
    );
  }

  Future<List<Sintoma>> getSintomas() async {
    List<Sintoma> sintReturn = [];
    String url =
        'https://priaid-symptom-checker-v1.p.rapidapi.com/symptoms?format=json&language=es-es';
    var params = {'format': 'json', 'language': 'es-es'};
    Map<String, String> headers = {
      "x-rapidapi-host": 'priaid-symptom-checker-v1.p.rapidapi.com',
      "x-rapidapi-key": 'c0a81f9229msh777a7f784c73ec2p17a016jsnef261f701754',
    };
    http.Response response = await http.get(url, headers: headers);
    var data = jsonDecode(response.body);
    for (var item in data) {
      sintReturn.add(new Sintoma.fromJson(item));
    }
    return sintReturn;
  }

  List<String> convert(List<Sintoma> sintomas) {
    List<String> listReturn = [];
    for (var item in sintomas) {
      listReturn.add(item.name.toLowerCase());
    }
    return listReturn;
  }
}
