import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:medigestion/src/blocs/provider.dart';
import 'package:medigestion/src/blocs/user_bloc.dart';
import 'package:medigestion/src/models/user_model.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CitaForm extends StatefulWidget {
  static final String routeName = 'citasForm';
  final int horario;
  final DocumentSnapshot medico;
  final String dia;
  CitaForm({Key key, this.horario, this.medico, this.dia}) : super(key: key);

  @override
  _CitaFormState createState() => _CitaFormState();
}

class _CitaFormState extends State<CitaForm> {
  DateTime aux;
  //ProductosBloc productosBloc;
  User userModel;
  //final productoProvider = new ProductoProvider();
  UserBloc userBloc;
  bool enabled = true;
  @override
  void initState() {
    super.initState();
    aux = DateTime.parse(widget.dia);
  }

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
                            fontSize: 24,
                            fontWeight: FontWeight.bold)),
                  ),
                  new Padding(padding: EdgeInsets.all(10)),
                  new Text('Paciente: ${userModel.name} ${userModel.lastName}',
                      style: new TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                  new Padding(padding: EdgeInsets.all(10)),
                  new Text('Correo: ${userModel.email}',
                      style: new TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                  new Padding(padding: EdgeInsets.all(10)),
                  new Text(
                      widget.horario >= 12
                          ? 'Hora de la cita: ${widget.horario} p. m.'
                          : 'Hora de la cita: ${widget.horario} a. m.',
                      style: new TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                  new Padding(padding: EdgeInsets.all(10)),
                  new Text(
                      'Dia de la cita: ${(aux.day)}-${(aux.month)}-${(aux.year)}',
                      style: new TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                  new Padding(padding: EdgeInsets.all(10)),
                  new Text(
                      'Medico: ${widget.medico['name']} ${widget.medico['lastName']}',
                      style: new TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                  new Padding(padding: EdgeInsets.all(10)),
                  new Text('Especialidad: ${widget.medico['about']}',
                      style: new TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                  new Padding(padding: EdgeInsets.all(10)),
                  new Center(
                    child: new FlatButton(
                        color: Theme.of(context).primaryColor,
                        onPressed: enabled == true
                            ? () {
                                setState(() {
                                  enabled = false;
                                });
                                print(widget.dia);
                                print(widget.horario);
                                Firestore.instance
                                    .collection('citas')
                                    .where('dia', isEqualTo: widget.dia)
                                    .where('hora',
                                        isEqualTo: widget.horario.toString())
                                    .getDocuments()
                                    .then((value) {
                                  if (value.documents.length != 0) {
                                    setState(() {
                                      enabled = true;
                                    });
                                    Fluttertoast.showToast(
                                        msg: 'Fecha no disponible');
                                    Navigator.pop(context);
                                  } else {
                                    Firestore.instance.collection('citas').add({
                                      'pacienteUid': '${userModel.uid}',
                                      'pacientefullName':
                                          '${userModel.name} ${userModel.lastName}',
                                      'correoPaciente': '${userModel.email}',
                                      'hora': '${widget.horario}',
                                      'medicoUID': '${widget.medico['uid']}',
                                      'medicofullName':
                                          '${widget.medico['name']} ${widget.medico['lastName']}',
                                      'medicoEspecialidad':
                                          '${widget.medico['about']}',
                                      'dia': widget.dia
                                    }).then((value) {
                                      setState(() {
                                        enabled = true;
                                      });
                                      Fluttertoast.showToast(
                                          msg: 'Cita agendada correctamente');
                                      print('Documento agregado');
                                      Navigator.pop(context);
                                    }).catchError((e) {
                                      Fluttertoast.showToast(
                                          msg: 'Error al agendar cita.');
                                      setState(() {
                                        enabled = true;
                                      });
                                    });
                                  }
                                });
                              }
                            : null,
                        child: enabled == true
                            ? new Text(
                                'Agendar Cita',
                                style: new TextStyle(color: Colors.white),
                              )
                            : CircularProgressIndicator()),
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
