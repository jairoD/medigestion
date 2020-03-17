import 'package:flutter/material.dart';
import 'package:medigestion/src/blocs/provider.dart';
import 'package:medigestion/src/pages/botones_page.dart';
import 'package:medigestion/src/pages/login_page.dart';
import 'package:medigestion/src/providers/firebaseUser_provider.dart';

class HomePage extends StatelessWidget {
  static final String routeName = 'home';
  // final productosProvider = new ProductoProvider();

  @override
  Widget build(BuildContext context) {
    //final bloc = Provider.of(context);
    final loginBLoc = Provider.of(context);
    final firebaseUserProvider = new FirebaseUserProvider();
    print('entro');
    return Scaffold(
      /*appBar: new AppBar(
        title: new Text('Home'),
        leading:
            new IconButton(icon: new Icon(Icons.exit_to_app), onPressed: (){
              firebaseUserProvider.signOut();}
            ),
      ),*/
      body: _handleCurrentView(loginBLoc,firebaseUserProvider),
     // floatingActionButton: _crearBoton(context),
    );
  }

  Widget _handleCurrentView(LoginBloc loginBloc, FirebaseUserProvider firebaseUserProvider){
    return new StreamBuilder(
      stream: loginBloc.isSignedIn,
      builder: (BuildContext context, AsyncSnapshot snapshot){
         if(snapshot.hasData){
             firebaseUserProvider.getUser().then((user) => print('Email: ${user.email} - Id: ${user.uid}'));
             return new BotonesPage();
         }else{
           print('¡SALIO!');
           print(snapshot.data);
           return new LoginPage();
         } 
      }
      );
  }
}
