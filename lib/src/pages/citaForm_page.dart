import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:medigestion/src/blocs/provider.dart';
import 'package:medigestion/src/blocs/user_bloc.dart';
import 'package:medigestion/src/models/user_model.dart';

class CitaForm extends StatefulWidget {
  static final String routeName = 'citasForm';
  final int horario;
  CitaForm({Key key, this.horario}) : super(key: key);

  @override
  _CitaFormState createState() => _CitaFormState();
}

class _CitaFormState extends State<CitaForm> {
  
  //ProductosBloc productosBloc;
  User userModel;
  //final productoProvider = new ProductoProvider();
  UserBloc userBloc;
  @override
  Widget build(BuildContext context) {
    userBloc = Provider.userBlocOf(context);
    return new StreamBuilder(
      stream: userBloc.userStream,
      builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
        if (snapshot.hasData) {
          userModel = snapshot.data;
          print("Vista ProfileUser: ${userModel.email} - ${userModel.uid}");
          return new Scaffold(
            appBar: new AppBar(),
            body: SingleChildScrollView(
              padding: EdgeInsets.all(15),
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Center(
                    child: new Text('Agendar Cita',
                        textAlign: TextAlign.center,
                        style: new TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                  ),
                  new Padding(padding: EdgeInsets.all(10)),
                  new Text('Paciente: ${userModel.name}  ${userModel.lastName}',
                      style: new TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                  new Padding(padding: EdgeInsets.all(10)),
                  new Text('Horario de la cita: ${widget.horario}',
                      style: new TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                  new Padding(padding: EdgeInsets.all(10)),
                  new Text('Doctor: ', style: new TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                  new Padding(padding: EdgeInsets.all(10)),
                  new Center(
                    child: new FlatButton(
                        color: Theme.of(context).primaryColor,
                        onPressed: () {},
                        child: new Text(
                          'Agendar Cita',
                          style: new TextStyle(color: Colors.white),
                        )),
                  )
                ],
              ),
            ),
          );
        } else {
          return new Scaffold(
            body: new Center(
              child: new CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
