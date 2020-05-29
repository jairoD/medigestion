import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:list_tile_more_customizable/list_tile_more_customizable.dart';
import 'package:medigestion/src/pages/citaForm_page.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatefulWidget {
  static final String routeName = 'calendar';
  CalendarPage({Key key}) : super(key: key);

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  GlobalKey myKey = GlobalKey();
  List<GlobalKey> keys;
  Offset position;
  List<double> dy;
  CalendarController _calendarController;
  List<String> opciones = ['Agendar cita', 'Cancelar cita', 'Agregar a espera'];
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
  @override
  void initState() {
    super.initState();
    dy = new List();
    _calendarController = CalendarController();
    keys = new List();
    for (var item in horario) {
      setState(() {
        keys.add(new GlobalKey());
      });
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => getSizeAndPosition());
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  getSizeAndPosition() {
    for (var i = 0; i < horario.length; i++) {
      RenderBox box = keys[i].currentContext.findRenderObject();
      position = box.localToGlobal(Offset.zero);
      setState(() {
        dy.add(position.dy);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(),
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
                delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
              return new ListTile(
                key: keys[index],
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
                        position:
                            RelativeRect.fromLTRB(1000.0, dy[index], 0.0, 0.0),
                        items: <PopupMenuItem<String>>[
                          new PopupMenuItem(
                            child: new ListTile(
                              contentPadding: EdgeInsets.all(0),
                              title: new Text(
                                'Agendar cita',
                              ),
                              onTap: () {
                                print('${horario[index]}');
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>CitaForm(horario: int.parse(horario[index]),)));
                              },
                            ),
                            value: value,
                          ),
                          new PopupMenuItem(
                            child: new ListTile(
                              contentPadding: EdgeInsets.all(0),
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
                    }),
                title: new Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  decoration: new BoxDecoration(
                      color: index %2 == 0 ? Theme.of(context).primaryColor : Colors.white,
                      borderRadius: new BorderRadius.circular(10)),
                ),
              );
            }, childCount: horario.length))
          ],
        ));
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
