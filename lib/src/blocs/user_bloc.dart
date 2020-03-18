import 'dart:async';
import 'package:medigestion/src/models/user_model.dart';
import 'package:medigestion/src/providers/firebaseUser_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:medigestion/src/blocs/validators.dart';

class UserBloc{
  final _userController = new BehaviorSubject<User>();

  Stream<User> get userStream => _userController.stream;
  
  Function(User) get updateProfile => _userController.sink.add;


}