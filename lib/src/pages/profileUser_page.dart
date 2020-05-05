import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medigestion/src/blocs/provider.dart';
import 'package:medigestion/src/blocs/user_bloc.dart';
import 'package:medigestion/src/models/user_model.dart';
import 'package:medigestion/src/pages/home_page.dart';
import 'package:medigestion/src/providers/profile_provider.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';

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

  final String minDateTime  = '1920-01-01';
  final String maxDateTime  = '2020-05-25';
  final String initDateTime = '2000-06-15';
  String _format = 'yyyy-MMMM-dd';
 DateTimePickerLocale _locale = DateTimePickerLocale.es;

  TextEditingController _inputFieldDateController    = new TextEditingController();
  TextEditingController _inputFieldGenderController2 = new TextEditingController();
  FixedExtentScrollController scrollController = FixedExtentScrollController(
    initialItem: 0
  );
  int selectitem = 0; 

  String valueName;
  String valueLastName;
  List<bool> isFormEditingEmpty = [false,false,false,false];
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    userBloc = Provider.userBlocOf(context);
    return new StreamBuilder(
      stream: userBloc.userStream,
      builder:(BuildContext context, AsyncSnapshot<User> snapshot) {
        if(snapshot.hasData){
            userModel = snapshot.data;
            print("Vista ProfileUser: ${userModel.email} - ${userModel.uid}");
          return _createProfile(context);
        }else{
          return new Scaffold(
            body: new Center(
              child: new CircularProgressIndicator(),
            ),
          );
        }
      },);
  }


  Widget _createProfile(BuildContext context){
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
                  _crearFecha(context),
                  _crearGenero(context),
                  _tipodeBoton(context),
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
      decoration: new InputDecoration(
        labelText: 'Nombre',
        suffixIcon: new Icon(Icons.face),
      ),
      onSaved: (value) => userModel.name = value,
      onChanged: (value) {
         if(value.isEmpty){
           setState(() {
             isFormEditingEmpty[0] = true;
           });
         }else{
           setState(() {
             isFormEditingEmpty[0] =false;
           });
         }
         print('value NAME: $value');
      },
      validator: (value) {
        if (value.length < 3) {
          return 'Ingrese su nombre';
        } else {
          print('Entro validator nombre: NULL');
          return null;
        }
      },
    );
  }
Widget _crearApellido() {
    return new TextFormField(
      initialValue: userModel.lastName,
      textCapitalization: TextCapitalization.sentences,
      decoration: new InputDecoration(
        labelText: 'Apellido',
        suffixIcon: new Icon(Icons.face),
      ),
      onSaved: (value) => userModel.lastName = value,
      onChanged: (value) {
         value = value;
         if(value.isEmpty){
           setState(() {
             isFormEditingEmpty[1] = true;
           });
         }else{
           setState(() {
             isFormEditingEmpty[1] =false;
           });
         }
         print('value LastName: $value');
      },
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
  Widget _tipodeBoton(BuildContext context){
    print('Entro onPressed');
          //Caso en el que venga con informacion 
          if(userBloc.userLastValue.name     != null    && 
             userBloc.userLastValue.lastName != null    &&
             userBloc.userLastValue.birthday != null    &&
             userBloc.userLastValue.gender   != null  ){
               //Caso en el que quiera cambiar informacion, con valores ya establecidos
            if(isFormEditingEmpty.contains(true)){
               print('ENtro 1 if');
               return _crearBotonNoHabilitado(context); 
            }else{return _crearBoton(context);}
          }else{
            //Caso en el que quiera editar sin tener informacion
            if(_inputFieldDateController.text.isNotEmpty && _inputFieldGenderController2.text.isNotEmpty){
              if(isFormEditingEmpty.contains(true)){
                return _crearBotonNoHabilitado(context); 
              }else{
                return _crearBoton(context);
              }
            }else{return _crearBotonNoHabilitado(context);}
          } 
  }
Widget _crearBotonNoHabilitado(BuildContext context) {
    return new RaisedButton.icon(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        color: Theme.of(context).primaryColor,
        textColor: Colors.white,
        onPressed:null,
        icon: new Icon(Icons.save),
        label: new Text('Guardar'));
  }
  Widget _crearBoton(BuildContext context) {
    return new RaisedButton.icon(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        color: Theme.of(context).primaryColor,
        textColor: Colors.white,
        onPressed:(_guardando) ? null : ()=> _submit(context),
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
    userModel.available = "1";
    userModel.birthday  = userBloc.userBirthdayLastValue;
    userModel.gender    = userBloc.userGenderLastValue;
    userBloc.agregarUsuario(userModel);
    //userBloc.updateProfile(userModel);
    setState(() {
      _cargando = false;
    });
    
    //mostrarSnackbar('Registro guardado');
    //Lo mando al HomePage cosa de que actualice enseguida el stream del User y no usar el updateProfile de la linea 158 ya que en el home lo hara
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

  //////Genero/////
  Widget _crearGenero(BuildContext context){
    return new StreamBuilder(
      stream: userBloc.userGenderStream,
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if(snapshot.hasData){
          if(userBloc.userLastValue.gender == null || _inputFieldGenderController2.text.length != 0){
          return new TextField(
            controller:_inputFieldGenderController2,
            decoration: new InputDecoration(
              labelText: 'Genero',
              hintText: 'Genero',
              suffixIcon: new Icon(Icons.wc),
            ),
            onTap: () {
              FocusScope.of(context).requestFocus(new FocusNode());
              _showGenderPicker(context);
            }
          );
          }else{
          return new TextFormField(
            initialValue: (userBloc.userLastValue.gender != null)
                          ? userBloc.userLastValue.gender
                          :"",
            decoration: new InputDecoration(
              labelText: 'Genero',
              hintText: 'Genero',
              suffixIcon: new Icon(Icons.wc),
            ),
            onTap: () {
              FocusScope.of(context).requestFocus(new FocusNode());
              _showGenderPicker(context);
            }
          );
        }
      }else{
          return new TextFormField(
            initialValue: (userBloc.userLastValue.gender != null)
                          ? userBloc.userLastValue.gender
                          :"",
            decoration: new InputDecoration(
              labelText: 'Genero',
              hintText: 'Genero',
              suffixIcon: new Icon(Icons.wc),
            ),
            onTap: () {
              FocusScope.of(context).requestFocus(new FocusNode());
              _showGenderPicker(context);
            }
          );

      }
      },
    );

  }
  ///Fecha////
  Widget _crearFecha(BuildContext context){
    return new StreamBuilder(
      stream: userBloc.userBirthdayStream,
      builder: (BuildContext context, AsyncSnapshot<Timestamp> snapshot) {
        if(snapshot.hasData){
          if(userBloc.userLastValue.birthday == null || _inputFieldDateController.text.length != 0){
          print('entro cumpleaños: ${snapshot.data} input ${_inputFieldDateController.text} userBirthday: ${userBloc.userLastValue.birthday}  ');
          return new TextField(
            controller:_inputFieldDateController,
            decoration: new InputDecoration(
              labelText: 'Fecha de nacimiento',
              hintText: 'Fecha de nacimiento',
              suffixIcon: new Icon(Icons.perm_contact_calendar),
            ),
            onTap: () {
              FocusScope.of(context).requestFocus(new FocusNode());
              _showDatePicker();
            }
          );
          }else{
          print('entro cumpleaños ELSE: ${snapshot.data}');
          return new TextFormField(
            initialValue: (userBloc.userLastValue.birthday != null)? userBloc.userLastValue.birthday.toDate().toIso8601String().substring(0,10)
                                                                   :"",
            decoration: new InputDecoration(
              labelText: 'Fecha de nacimiento',
              hintText: 'Fecha de nacimiento',
              suffixIcon: new Icon(Icons.perm_contact_calendar),
            ),
            onTap: () {
              FocusScope.of(context).requestFocus(new FocusNode());
              _showDatePicker();
            }
          );
        }
      }else{
          return new TextFormField(
            initialValue: (userBloc.userLastValue.birthday != null)? userBloc.userLastValue.birthday.toDate().toIso8601String().substring(0,10)
                                                                   :"",
            decoration: new InputDecoration(
              labelText: 'Fecha de nacimiento',
              hintText: 'Fecha de nacimiento',
              suffixIcon: new Icon(Icons.perm_contact_calendar),
            ),
            onTap: () {
              FocusScope.of(context).requestFocus(new FocusNode());
              _showDatePicker();
            }
          );

      }
    },
  );
}

  void _showDatePicker() {
    DatePicker.showDatePicker(
      context,
      pickerTheme: DateTimePickerTheme( 
        showTitle: true,
        confirm: Text('Listo', style: TextStyle(color: Color.fromRGBO(52, 54, 101, 1.0))),
      ), 
      minDateTime: DateTime.parse(minDateTime),
      maxDateTime: DateTime.parse(maxDateTime),
      initialDateTime: DateTime.parse(initDateTime),
      dateFormat: _format,
      locale: _locale,
      onChange: (dateTime, List<int> index) {
        //print(dateTime);
        setState(() {
           _inputFieldDateController.text = dateTime.toIso8601String().substring(0,10);
           userBloc.updateUserBirthday(Timestamp.fromDate(DateTime.parse(_inputFieldDateController.text)));
           
        });
      },
      onConfirm: (dateTime, List<int> index) {
        setState(() {
           _inputFieldDateController.text = dateTime.toIso8601String().substring(0,10);
            userBloc.updateUserBirthday(Timestamp.fromDate(DateTime.parse(_inputFieldDateController.text)));
        });
      },
    );
  }

  void _showGenderPicker(BuildContext context){
   showModalBottomSheet(
    context: context,
    builder: (context) {
      return Container(
        height:MediaQuery.of(context).copyWith().size.height/3,
        child: new Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(45.0), 
            child: new AppBar(
              elevation: 0.3,
              backgroundColor: Colors.white,
              actions: <Widget>[
                Container(
                  margin: EdgeInsets.only(right: 19.0),
                  child: new IconButton(
                    icon: new Text("Ok", style: new TextStyle(color: Color.fromRGBO(52, 54, 101, 1.0),fontWeight: FontWeight.w500,),) , 
                    onPressed: (){
                      if(selectitem == 0){
                        _inputFieldGenderController2.text = "Hombre";
                        userBloc.updateUserGender(_inputFieldGenderController2.text);
                        selectitem=0;
                        setState(() {});
                      }
                      if(selectitem == 1){
                        _inputFieldGenderController2.text = "Mujer";
                        userBloc.updateUserGender(_inputFieldGenderController2.text);
                        selectitem=0;
                        setState(() {});
                      }
                      Navigator.of(context).pop();
                    }
                  ),
                )
              ],
            ),
          ),
          body: new GestureDetector(
            onTap: () {
              if(selectitem == 0){
                _inputFieldGenderController2.text = "Hombre";
                userBloc.updateUserGender(_inputFieldGenderController2.text);
                selectitem=0;
                setState(() {});
              }

              if(selectitem == 1){
                _inputFieldGenderController2.text = "Mujer";
                userBloc.updateUserGender(_inputFieldGenderController2.text);
                selectitem=0;
                setState(() {});
             }
              Navigator.of(context).pop();
            },
            child: new Container(   
                  child: new CupertinoPicker(
                  //magnification: 1.5,
                  backgroundColor: Colors.white,
                  children: <Widget>[
                    new Text(
                    "Hombre", 
                    style:new TextStyle(color: Color.fromRGBO(52, 54, 101, 1.0))),
                    new Text(
                    "Mujer", 
                    style:new TextStyle(color: Color.fromRGBO(52, 54, 101, 1.0))),
                  ],
                  itemExtent: 25, //height of each item
                  //looping: true,
                  scrollController: scrollController,
                  onSelectedItemChanged: (int index) {  
                    selectitem = index;
                    if(selectitem == 0){
                      _inputFieldGenderController2.text = "Hombre";
                      userBloc.updateUserGender(_inputFieldGenderController2.text);
                      setState(() {});
                    }
                    if(selectitem == 1){
                      _inputFieldGenderController2.text = "Mujer";   
                      userBloc.updateUserGender(_inputFieldGenderController2.text);
                      setState(() {});
                    }
                  },
                ),
            ),
          ) ,    
        ),
      );
    }, 
  );
      
}

}