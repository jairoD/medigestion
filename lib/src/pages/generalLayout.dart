import 'dart:convert';

import 'package:circular_check_box/circular_check_box.dart';
import 'package:flutter/material.dart';
import 'package:medigestion/src/models/issue.dart';
import 'package:medigestion/src/models/sintoma.dart';
import 'package:http/http.dart' as http;
import 'package:medigestion/src/pages/diagnosticosLayout.dart';
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(52, 54, 101, 1.0),
        elevation: 0.0,
        brightness: Brightness.light,
        iconTheme: IconThemeData(color: Colors.white),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.search),
              color: Colors.white,
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: Datasearch(),
                );
              })
        ],
      ),
    );
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

  Datasearch() {
    
  }

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

  Future<List<Issue>> getDiagnostico(
      int year, List<int> symptoms, String gender) async {
    String sintomas = symptoms.toList().toString();
    List<Issue> respuesta = [];
    String url =
        'https://priaid-symptom-checker-v1.p.rapidapi.com/diagnosis?format=json&symptoms=$sintomas&gender=$gender&year_of_birth=$year&language=es-es';
    Map<String, String> headers = {
      "x-rapidapi-host": 'priaid-symptom-checker-v1.p.rapidapi.com',
      "x-rapidapi-key": 'd3ee42e476msh1a9257b1255ff2fp10bac7jsnbda69fd8a290',
    };
    http.Response response = await http.get(url, headers: headers);

    List<dynamic> responseJson = jsonDecode(response.body);
    for (var item in responseJson) {
      respuesta.add(new Issue.fromJson(item['Issue']));
    }
    return respuesta;
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
