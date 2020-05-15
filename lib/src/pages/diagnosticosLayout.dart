import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:medigestion/src/pages/issueInfoLayout.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../models/issue.dart';

class DiagnosticosLayout extends StatelessWidget {
  static final String routeName = 'diagnosticos';
  final String genero;
  final List<int> sintomas;
  final int year;
  const DiagnosticosLayout({Key key, this.genero, this.sintomas, this.year})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(),
      body: new FutureBuilder(
          future: getDiagnostico(year, sintomas, genero),
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
              return new ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return new Card(
                    elevation: 5,
                    child: ListTile(
                      title: new Text(
                        snapshot.data[index].name,
                        style: new TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold),
                      ),
                      subtitle: new Text(
                        snapshot.data[index].profName,
                        style: new TextStyle(color: Colors.grey),
                      ),
                      leading: new CircularPercentIndicator(
                        radius: 40.0,
                        lineWidth: 5.0,
                        percent:
                            double.parse(snapshot.data[index].accuracy) / 100,
                        center: new Text(
                          (double.parse(snapshot.data[index].accuracy)
                                      .roundToDouble())
                                  .toString() +
                              '%',
                          style: new TextStyle(fontSize: 10),
                        ),
                        progressColor: double.parse(snapshot.data[index].accuracy) /
                                    100 >=
                                0.75
                            ? Colors.green
                            : (double.parse(snapshot.data[index].accuracy) /
                                            100 <
                                        0.75 &&
                                    double.parse(snapshot.data[index].accuracy) /
                                            100 >
                                        0.5)
                                ? Colors.orange
                                : (double.parse(snapshot.data[index].accuracy) /
                                                100 <
                                            0.5 &&
                                        double.parse(snapshot
                                                    .data[index].accuracy) /
                                                100 >
                                            0.25)
                                    ? Colors.yellow
                                    : Colors.red,
                      ),
                      trailing: new IconButton(
                          icon: Icon(Icons.arrow_forward),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => IssueInfoLayout(
                                          id: snapshot.data[index].id,
                                        )));
                          }),
                    ),
                  );
                },
              );
            }
          }),
    );
  }

  Future<List<Issue>> getDiagnostico(
      int year, List<int> symptoms, String gender) async {
    String sintomas = symptoms.toList().toString();
    List<Issue> respuesta = [];
    print('---consultando---');
    String url =
        'https://priaid-symptom-checker-v1.p.rapidapi.com/diagnosis?format=json&symptoms=$sintomas&gender=$gender&year_of_birth=$year&language=es-es';
    Map<String, String> headers = {
      "x-rapidapi-host": 'priaid-symptom-checker-v1.p.rapidapi.com',
      "x-rapidapi-key": '53ae8b865bmsh0fce0879e97417cp1f6ad7jsnce1daced22c7',
    };
    http.Response response = await http.get(url, headers: headers);

    List<dynamic> responseJson = jsonDecode(response.body);
    for (var item in responseJson) {
      respuesta.add(new Issue.fromJson(item['Issue']));
    }
    return respuesta;
  }
}
