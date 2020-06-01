import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:list_tile_more_customizable/list_tile_more_customizable.dart';
import 'package:medigestion/src/blocs/provider.dart';
import 'package:medigestion/src/blocs/user_bloc.dart';
import 'package:medigestion/src/models/user_model.dart';
import 'package:medigestion/src/pages/citaForm_page.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatefulWidget {
  static final String routeName = 'calendar';
  CalendarPage({Key key}) : super(key: key);

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  //ProductosBloc productosBloc;
  User userModel;
  //final productoProvider = new ProductoProvider();
  UserBloc userBloc;
  //dia actual
  String currentDate = new DateTime(new DateTime.now().year,
          new DateTime.now().month, new DateTime.now().day, 12, 12, 12, 12, 12)
      .toString();
  //key global
  GlobalKey myKey = GlobalKey();
  //documento medico seleccionado
  DocumentSnapshot medicoSelected;
  //medico id en el drop
  String medicoUid;
  String namae = '';
  //dia seleccionado de calendario
  String dia = new DateTime(new DateTime.now().year, new DateTime.now().month,
      new DateTime.now().day, 12, 12, 12, 12, 12).toString();
  //keys de tiles en horario
  List<GlobalKey> keys = [
    new GlobalKey(),
    new GlobalKey(),
    new GlobalKey(),
    new GlobalKey(),
    new GlobalKey(),
    new GlobalKey(),
    new GlobalKey(),
    new GlobalKey(),
    new GlobalKey(),
    new GlobalKey(),
    new GlobalKey(),
    new GlobalKey(),
    new GlobalKey()
  ];
  //position
  Offset position;
  //posicion y de las opciones
  List<double> dy;
  CalendarController _calendarController;
  List<String> opciones = ['Agendar cita', 'Cancelar cita', 'Agregar a espera'];
  //horario por defecto
  List<String> horario = [
    '8',
    '9',
    '10',
    '11',
    '12',
    '13',
    '14',
    '15',
    '16',
    '17',
    '18',
    '19',
    '20'
  ];
  String value = '0';
  //citas actuales
  List<DocumentSnapshot> citasActuales;
  @override
  void initState() {
    super.initState();
    Firestore.instance.collection('doctors').getDocuments().then((value) {
      medicoUid = value.documents[0].data['uid'];
      medicoSelected = value.documents[0];
    });
    citasActuales = new List();
    Firestore.instance
        .collection('citas')
        .where('dia', isEqualTo: dia)
        .where('medicoUID', isEqualTo: medicoUid)
        .getDocuments()
        .then((value) {
      setState(() {
        citasActuales = value.documents;
      });
    });
    dy = new List();
    _calendarController = CalendarController();
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(),
        body: new CustomScrollView(
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: TableCalendar(
                startDay: DateTime.now(),
                locale: 'en_US',
                initialCalendarFormat: CalendarFormat.week,
                availableCalendarFormats: const {CalendarFormat.week: 'a'},
                calendarController: _calendarController,
                onDaySelected: (DateTime day, List events) {
                  setState(() {
                    dia = new DateTime(
                        day.year, day.month, day.day, 12, 12, 12, 12, 12).toString();
                  });
                  getAllCitas(dia);
                  print(new DateTime(day.year, day.month, day.day));
                  //print('Dia actual: ${currentDate}');
                  //print('Dia seleccionado: ${dia}');
                },
              ),
            ),
            SliverList(
                delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
              if (index == 0) {
                return new Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'Seleccionar Medico: ',
                    style: new TextStyle(
                      color: Color.fromRGBO(52, 54, 101, 1.0),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              } else if (index == 1) {
                return new StreamBuilder(
                  stream: Firestore.instance.collection('doctors').snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasData) {
                      //medicoUid = snapshot.data.documents[0]['uid'];
                      return Container(
                        padding: EdgeInsets.all(15),
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: new DropdownButton(
                          value: medicoUid,
                          isExpanded: true,
                          onChanged: (value) {
                            setState(() {
                              medicoUid = value;
                            });
                            setState(() {
                              medicoSelected = snapshot.data.documents
                                  .firstWhere(
                                      (element) => element['uid'] == medicoUid);
                            });
                            getAllCitas(dia);
                          },
                          items: snapshot.data.documents
                              .toList()
                              .map((DocumentSnapshot usuario) {
                            return new DropdownMenuItem(
                              value: usuario['uid'],
                              child: new Text(
                                '${usuario.data['name']} ${usuario.data['lastName']}',
                                maxLines: 1,
                                style: new TextStyle(
                                  color: Color.fromRGBO(52, 54, 101, 1.0),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      );
                    } else {
                      return new Center(
                          child: new CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).primaryColor),
                      ));
                    }
                  },
                );
              } else {
                return new Divider();
              }
            }, childCount: 3)),
            SliverList(
                delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
              bool aux = exists(horario[index]);
              return new Column(
                children: <Widget>[
                  ListTile(
                    enabled: true,
                    leading: int.parse(horario[index]) < 10
                        ? new Text(
                            '0${horario[index]}:00 a. m.',
                            style: new TextStyle(
                                color: aux
                                    ? Colors.grey
                                    : Theme.of(context).primaryColor,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          )
                        : new Text(
                            '${horario[index]}:00 a. m.',
                            style: new TextStyle(
                                color: aux
                                    ? Colors.grey
                                    : Theme.of(context).primaryColor,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                    trailing: !aux
                        ? new IconButton(
                            icon: new Icon(
                              Icons.calendar_today,
                              color: Theme.of(context).primaryColor,
                            ),
                            onPressed: () {
                              print('${horario[index]}');
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CitaForm(
                                            horario: int.parse(horario[index]),
                                            medico: medicoSelected,
                                            dia: dia,
                                          ))).then((value) {
                                getAllCitas(dia);
                              });
                            })
                        : null,
                    title: aux
                        ? new Text(
                            'No disponible',
                            style: new TextStyle(
                                color: aux
                                    ? Colors.grey
                                    : Theme.of(context).primaryColor,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          )
                        : new Text(
                            'Disponible',
                            style: new TextStyle(
                                color: aux
                                    ? Colors.grey
                                    : Theme.of(context).primaryColor,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                  ),
                  new Divider()
                ],
              );
            }, childCount: horario.length))
          ],
        ));
  }

  bool exists(String hora) {
    for (var item in citasActuales) {
      if (item['hora'] == hora) {
        return true;
      }
    }
    return false;
  }

  bool owner(User user) {
    for (var item in citasActuales) {
      if (item['pacienteUid'] == user.uid) {
        print('horario seleccionado: ' + item['pacienteUid']);
        //print(user.uid);
        return true;
      }
    }
    return false;
  }

  getAllCitas(String filt) {
    print(medicoUid);
    print(filt);
    Firestore.instance
        .collection('citas')
        .where('dia', isEqualTo: filt)
        .where('medicoUID', isEqualTo: medicoUid)
        .getDocuments()
        .then((value) {
      print(value.documents.length);
      setState(() {
        citasActuales = value.documents;
      });
    }).catchError((e) {
      print(e);
    });
  }

  void alertDialog(BuildContext context) {
    var alert = AlertDialog(
      title: Text("Dialog title"),
      content: Text("Dialog description"),
    );
    showDialog(context: context, builder: (BuildContext context) => alert);
  }
}

/*
 body: new CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: TableCalendar(
              locale: 'en_US',
              initialCalendarFormat: CalendarFormat.week,
              availableCalendarFormats: const {CalendarFormat.week: 'a'},
              calendarController: _calendarController,
              onDaySelected: (DateTime day, List events) {
                print(day);
              },
            ),
          ),
          SliverList(
              delegate:
                  SliverChildBuilderDelegate((BuildContext context, int index) {
            return new ListTile(
              enabled: false,
              leading: new Text('${horario[index]}:00 a. m.'),
              trailing: new IconButton(
                  icon: new Icon(
                    Icons.more_vert,
                    color: Theme.of(context).primaryColor,
                  ),
                  onPressed: () {
                    showMenu(
                      context: context,
                      position: RelativeRect.fromLTRB(1000.0, 1000.0, 0.0, 0.0),
                      items: <PopupMenuItem<String>>[
                        new PopupMenuItem(
                          child: new ListTile(
                            title: new Text('Agendar cita'),
                            onTap: () {
                              print('selected agendar $index');
                              Navigator.pop(context);
                            },
                          ),
                          value: value,
                        ),
                        new PopupMenuItem(
                          child: new ListTile(
                            title: new Text('Cancelar cita'),
                            onTap: () {
                              print('selected cancelar');
                              Navigator.pop(context);
                            },
                          ),
                          value: value,
                        ),
                      ],
                    );
                    print(value);
                  }),
              title: new Container(
                width: MediaQuery.of(context).size.width,
                height: 50,
                decoration: new BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: new BorderRadius.circular(10)),
              ),
            );
          }, childCount: horario.length))
        ],
      ),
    
 */
