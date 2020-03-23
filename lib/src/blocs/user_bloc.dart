import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medigestion/src/models/user_model.dart';
import 'package:medigestion/src/providers/firebaseUser_provider.dart';
import 'package:medigestion/src/providers/profile_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:medigestion/src/blocs/validators.dart';

class UserBloc{
  final _userController         = new BehaviorSubject<User>();
  final _userBirthdayController = new BehaviorSubject<Timestamp>();
  final _userGenderController   = new BehaviorSubject<String>();
  final _userProvider           = new ProfileProvider();

  //Recuperar los datos del Stream
  Stream<User> get userStream => _userController.stream;
  //Añadimos el usuario
  Function(User) get updateProfile => _userController.sink.add;

  //Obtener el ultimo valor agregado a los streams
  User get userLastValue => _userController.value;

  Future<String> subirFoto(File foto, String uid) async {
    final fotoUrl = await _userProvider.uploadFile(foto, uid);
    return fotoUrl;
  }
  
  void agregarUsuario(User user) async {
    print('entro en agregar');
    await _userProvider.handleInfo(user);
  }

  //Creacion de todo lo que lleva un stream para el cumpleaños
  Stream<Timestamp>   get userBirthdayStream       => _userBirthdayController;
  Function(Timestamp) get updateUserBirthday       => _userBirthdayController.sink.add;
  Timestamp           get userBirthdayLastValue    => _userBirthdayController.value;

  //Creacion de todo lo que lleva un stream para el genero
  Stream<String>   get userGenderStream     => _userGenderController;
  Function(String) get updateUserGender     => _userGenderController.sink.add;
  String           get userGenderLastValue  => _userGenderController.value;
  
//Cerramos los Streams
  dispose(){
    _userController?.close();
  }
}