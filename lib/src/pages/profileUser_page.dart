import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medigestion/src/blocs/provider.dart';
import 'package:medigestion/src/blocs/user_bloc.dart';
import 'package:medigestion/src/models/user_model.dart';
import 'package:medigestion/src/pages/home_page.dart';
import 'package:medigestion/src/providers/profile_provider.dart';

class ProfileUserPage extends StatefulWidget {
  static final routeName = 'userProfile';
  @override
  _ProfileUserPageState createState() => _ProfileUserPageState();
}

class _ProfileUserPageState extends State<ProfileUserPage> {
  final formKey = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final profileProvider = new ProfileProvider();

  //ProductosBloc productosBloc;
  User userModel;
  //final productoProvider = new ProductoProvider();
  UserBloc userBloc;
  File foto;
  bool _guardando = false;
  bool _cargando = false;
  @override
  Widget build(BuildContext context) {
    userBloc = Provider.userBlocOf(context);
    //productosBloc = Provider.productosBlocOf(context);
    /*final User userArgument = ModalRoute.of(context).settings.arguments;

    if (userArgument != null) {
      userModel = userArgument;
    }*/
    return new StreamBuilder(
      stream: userBloc.userStream,
      builder:(BuildContext context, AsyncSnapshot<User> snapshot) {
        if(snapshot.hasData){
            userModel = snapshot.data;
            print("Vista ProfileUser: ${userModel.email} - ${userModel.uid}");
          return _createProfile();
        }else{
          return new Scaffold(
            body: new Center(
              child: new CircularProgressIndicator(),
            ),
          );
        }
      },);
  }


  Widget _createProfile(){
    return  new Scaffold(
      key: scaffoldKey,
      appBar: new AppBar(
        title: new Text('Perfil'),
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.photo_size_select_actual),
            onPressed: _seleccionarFoto,
          ),
          new IconButton(
            icon: new Icon(Icons.camera_alt),
            onPressed: _tomarFoto,
          )
        ],
      ),
      body: new SingleChildScrollView(
        child: new Container(
          padding: EdgeInsets.all(15.0),
          child: new Form(
              key: formKey,
              child: new Column(
                children: <Widget>[
                  _mostrarFoto(),
                  _crearNombre(),
                  _crearApellido(),
                  _crearBoton(context),
                  _crearCargando()
                ],
              )),
        ),
      ),
    );
  }
  Widget _crearNombre() {
    return new TextFormField(
      initialValue: userModel.name,
      textCapitalization: TextCapitalization.sentences,
      decoration: new InputDecoration(labelText: 'Nombre'),
      onSaved: (value) => userModel.name = value,
      validator: (value) {
        if (value.length < 3) {
          return 'Ingrese su nombre';
        } else {
          return null;
        }
      },
    );
  }
Widget _crearApellido() {
    return new TextFormField(
      initialValue: userModel.lastName,
      textCapitalization: TextCapitalization.sentences,
      decoration: new InputDecoration(labelText: 'Apellido'),
      onSaved: (value) => userModel.lastName = value,
      validator: (value) {
        if (value.length < 3) {
          return 'Ingrese su Apellido';
        } else {
          return null;
        }
      },
    );
  }
  

  Widget _crearCargando() {
    if (_cargando) {
      return new Center(
        child: new CircularProgressIndicator(),
      );
    } else {
      return new Container();
    }
  }

  Widget _crearBoton(BuildContext context) {
    return new RaisedButton.icon(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        color: Theme.of(context).primaryColor,
        textColor: Colors.white,
        onPressed: (_guardando) ? null : ()=> _submit(context),
        icon: new Icon(Icons.save),
        label: new Text('Guardar'));
  }

  void _submit(BuildContext context) async {
    if (!formKey.currentState.validate()) return;
    formKey.currentState.save();

    setState(() {
      _guardando = true;
      _cargando = true;
    });

    if (foto != null) {
      userModel.photoUrl = await userBloc.subirFoto(foto, userModel.uid);
    }

    userBloc.agregarUsuario(userModel);
    setState(() {
      _cargando = false;
    });
    
    mostrarSnackbar('Registro guardado');
    Navigator.pushNamed(context, HomePage.routeName);
  }


  void mostrarSnackbar(String mensaje) {
    final snackbar = new SnackBar(
      content: new Text(mensaje),
      duration: new Duration(seconds: 2),
      shape:
          new RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
    );
    scaffoldKey.currentState.showSnackBar(snackbar);
  }

   _mostrarFoto() {
    if (userModel.photoUrl != null) {

      return new Material(
        child: new CachedNetworkImage(
          placeholder: (context, url) => new Container(
            child:new CircularProgressIndicator(
              strokeWidth: 2.0,
              valueColor:AlwaysStoppedAnimation<Color>(
                    Theme.of(context).primaryColor) ,
            ),
            width: 300.0,
            height: 300.0,
            padding: EdgeInsets.all(20.0),
          ),
          imageUrl: userModel.photoUrl,
          width: 300.0,
          height: 300.0,
          fit: BoxFit.cover,          
        ),
        borderRadius: BorderRadius.all(Radius.circular(45.0)),
        clipBehavior: Clip.hardEdge,
      );
      /* return new FadeInImage(
        image: new NetworkImage(userModel.photoUrl),
        placeholder: new AssetImage('assets/img/jar-loading.gif'),
        height: 300.0,
        fit: BoxFit.contain,
      ); */
    } else {
      if (foto != null) {
        return new Material(
          child: Image.file(
            foto,
            fit: BoxFit.cover,
            height: 300.0,
            width: 300.0,
          ),
         borderRadius: BorderRadius.all(Radius.circular(45.0)),
        clipBehavior: Clip.hardEdge,
        );
      }
      return Image.asset('assets/img/no-image2.png');
    }
  } 

  _seleccionarFoto() async {
    _procesarImagen(ImageSource.gallery);
  }

  _tomarFoto() async {
    _procesarImagen(ImageSource.camera);
  }

  _procesarImagen(ImageSource fuente) async {
    foto = await ImagePicker.pickImage(source: fuente);
    if (foto != null) {
      userModel.photoUrl = null;
    }
    setState(() {});
  }
}