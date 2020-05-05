import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:medigestion/src/models/infectado.dart';
import 'package:medigestion/src/models/prueba.dart';
import 'package:medigestion/src/pages/pie.dart';

class Covid extends StatefulWidget {
  static final String routeName = 'covid';
  Covid({Key key}) : super(key: key);

  @override
  _CovidState createState() => _CovidState();
}

class _CovidState extends State<Covid> {
  List<String> deptos;
  List<Infectado> infectados;
  String cityFilt = '';

  @override
  void initState() {
    super.initState();
    infectados = new List();
    deptos = new List();
    getCiudades().then((e) {
      for (var item in e) {
        print(item);
        setState(() {
          deptos.add(item.toString());
        });
      }
      cityFilt = deptos[0];
    });
    getAllCases().then((e) {
      for (var item in e) {
        setState(() {
          infectados.add(new Infectado.fromJson(item));
        });
      }
    });
  }

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
                      new Text('Departamentos: ',
                          style: new TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold)),
                      new FutureBuilder(
                          future: getCiudades(),
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
                              return new Text(snapshot.data.length.toString(),
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
          new Padding(
            padding: EdgeInsets.all(4),
            child: new Text(
              'Informacion Departamental',
              style: new TextStyle(
                  color: Color.fromRGBO(52, 54, 101, 1.0),
                  fontSize: 28,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          new Padding(
            padding: EdgeInsets.all(4),
            child: new Row(
              children: <Widget>[
                new Text(
                  'Ciudad/Departamento: ',
                  style: new TextStyle(
                    color: Color.fromRGBO(52, 54, 101, 1.0),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  width: 150,
                  child: new DropdownButton(
                    isExpanded: true,
                    hint: new Text(
                      cityFilt,
                      style: new TextStyle(
                        color: Color.fromRGBO(52, 54, 101, 1.0),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    items: deptos.map((String depto) {
                      return new DropdownMenuItem(
                        value: depto,
                        child: new Text(
                          depto,
                          maxLines: 1,
                          style: new TextStyle(
                            color: Color.fromRGBO(52, 54, 101, 1.0),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        cityFilt = value;
                        print('Hombres: ' +
                            infectados
                                .where((e) =>
                                    e.departamanto == cityFilt &&
                                        e.sexo == 'M' ||
                                    e.sexo == 'm')
                                .length
                                .toString());
                        print('Mujeres: ' +
                            infectados
                                .where((e) =>
                                    e.departamanto == cityFilt &&
                                        e.sexo == 'F' ||
                                    e.sexo == 'f')
                                .length
                                .toString());
                      });
                      print(cityFilt);
                    },
                    value: cityFilt,
                  ),
                )
              ],
            ),
          ),
          _infectadosChart(),
          _recuperadosChart(),
          _fallecidosChart()
        ],
      ),
    );
  }

  Widget _infectadosChart() {
    int m = infectados
        .where(
            (e) => e.departamanto == cityFilt && e.sexo == 'M' || e.sexo == 'm')
        .length;
    int f = infectados
        .where(
            (e) => e.departamanto == cityFilt && e.sexo == 'F' || e.sexo == 'f')
        .length;
    return new Column(
      children: <Widget>[
        new Container(
          constraints: BoxConstraints(maxHeight: 270),
          height: MediaQuery.of(context).size.width * 0.7,
          child: SimplePieChart(_createSampleData(m, f)),
          //child: SimplePieChart(
          //  _createSampleData(),
          //  animate: false,
          //),
        ),
        new Padding(
          padding: EdgeInsets.all(4),
          child: new Text(
            'Infectados: ${m + f}',
            textAlign: TextAlign.center,
            style: new TextStyle(
              color: Color.fromRGBO(52, 54, 101, 1.0),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _recuperadosChart() {
    int m = infectados
        .where((e) =>
            e.departamanto == cityFilt &&
            e.atencion == 'Recuperado' &&
            (e.sexo == 'M' || e.sexo == 'm'))
        .length;
    int f = infectados
        .where((e) =>
            e.departamanto == cityFilt &&
            e.atencion == 'Recuperado' &&
            (e.sexo == 'F' || e.sexo == 'f'))
        .length;
    return new Column(
      children: <Widget>[
        new Container(
          constraints: BoxConstraints(maxHeight: 270),
          height: MediaQuery.of(context).size.width * 0.7,
          child: SimplePieChart(_createSampleData(m, f)),
          //child: SimplePieChart(
          //  _createSampleData(),
          //  animate: false,
          //),
        ),
        new Padding(
          padding: EdgeInsets.all(4),
          child: new Text(
            'Recuperados: ${m + f}',
            textAlign: TextAlign.center,
            style: new TextStyle(
              color: Color.fromRGBO(52, 54, 101, 1.0),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _fallecidosChart() {
    int m = infectados
        .where((e) =>
            e.departamanto == cityFilt &&
            e.atencion == 'Fallecido' &&
            (e.sexo == 'M' || e.sexo == 'm'))
        .length;
    int f = infectados
        .where((e) =>
            e.departamanto == cityFilt &&
            e.atencion == 'Fallecido' &&
            (e.sexo == 'F' || e.sexo == 'f'))
        .length;
    return new Column(
      children: <Widget>[
        new Container(
          constraints: BoxConstraints(maxHeight: 270),
          height: MediaQuery.of(context).size.width * 0.7,
          child: SimplePieChart(_createSampleData(m, f)),
          //child: SimplePieChart(
          //  _createSampleData(),
          //  animate: false,
          //),
        ),
        new Padding(
          padding: EdgeInsets.all(4),
          child: new Text(
            'Fallecidos: ${m + f}',
            textAlign: TextAlign.center,
            style: new TextStyle(
              color: Color.fromRGBO(52, 54, 101, 1.0),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  static List<charts.Series<DataChart, int>> _createSampleData(int m, int f) {
    final data = [
      new DataChart(0, m, 'Hombres'),
      new DataChart(1, f, 'Mujeres'),
    ];

    return [
      new charts.Series<DataChart, int>(
        id: 'Sales',
        domainFn: (DataChart sales, _) => sales.aux,
        measureFn: (DataChart sales, _) => sales.value,
        data: data,

        // Set a label accessor to control the text of the arc label.
        labelAccessorFn: (DataChart row, _) => '${row.sexo}:${row.value}',
      )
    ];
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
    //print(data[0]['count_id_de_caso']);
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
    //print(data[0]['count_id_de_caso']);
    return data[0]['count_id_de_caso'].toString();
  }

  Future<String> getM() async {
    String url = 'https://www.datos.gov.co/resource/gt2j-8ykr.json?\$' +
        'select' +
        '=count(id_de_caso)&atenci_n=Fallecido';

    Map<String, String> headers = {
      "X-App-Token": '5iOVFz2oJKIvMGqHBYiN9mCzd',
    };
    http.Response response = await http.get(url, headers: headers);
    List<dynamic> data = jsonDecode(response.body);
    //print(data[0]['count_id_de_caso']);
    return data[0]['count_id_de_caso'].toString();
  }

  Future getCiudades() async {
    String url = 'https://www.datos.gov.co/resource/gt2j-8ykr.json?\$' +
        'select=distinct departamento';

    Map<String, String> headers = {
      "X-App-Token": '5iOVFz2oJKIvMGqHBYiN9mCzd',
    };
    http.Response response = await http.get(url, headers: headers);
    List<dynamic> data = jsonDecode(response.body);
    List<String> aux = new List();
    for (var item in data) {
      aux.add(item['departamento']);
    }
    return aux;
  }

  Future getAllCases() async {
    String url = 'https://www.datos.gov.co/resource/gt2j-8ykr.json?\$' +
        'limit=9999999999';
    Map<String, String> headers = {
      "X-App-Token": '5iOVFz2oJKIvMGqHBYiN9mCzd',
    };
    http.Response response = await http.get(url, headers: headers);
    List<dynamic> data = jsonDecode(response.body);
    return data;
  }
}
