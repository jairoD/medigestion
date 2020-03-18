import 'package:flutter/material.dart';
import 'package:medigestion/src/blocs/provider.dart';
import 'package:medigestion/src/pages/doctorChatList_page.dart';
import 'package:medigestion/src/pages/home_page.dart';
import 'package:medigestion/src/pages/login_page.dart';
import 'package:medigestion/src/pages/registro_page.dart';

void main() async{
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Provider(
      child: MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TeleMedicina',
      initialRoute: LoginPage.routeName,
      routes: {
        LoginPage.routeName: (BuildContext context) => new LoginPage(),
        HomePage.routeName: (BuildContext context) => new HomePage(),
        RegistroPage.routeName: (BuildContext context) => new RegistroPage(),
        DoctorListPage.routeName: (BuildContext context) => new DoctorListPage(),
      },
      theme: new ThemeData(primaryColor: Colors.deepPurple),
    ));
  }
}
