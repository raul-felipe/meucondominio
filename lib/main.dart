import 'package:flutter/material.dart';
import 'register_page.dart';
import 'login_page.dart';
import 'package:firebase_core/firebase_core.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final routes = <String, WidgetBuilder>{
    LoginPage.tag: (context) => LoginPage(),
    RegisterPage.tag: (context) => RegisterPage(),
    //HomePage.tag: (context) => HomePage(),
  };

  Widget Screen() {
    return FutureBuilder(
      // Initialize FlutterFire
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return Text('Algo deu errado');
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return LoginPage();
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return Text('Carregando');
      },
    );
  }  

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meu condominio',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
        fontFamily: 'Nunito',
      ),
      home: Scaffold(
        body: Screen(),
      ), 
      routes: routes,
    );
  }
}