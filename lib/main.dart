import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:onshop/screens/auth.dart';
import 'package:onshop/screens/home/home.dart';
import 'package:velocity_x/velocity_x.dart';

void main() {

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          color: Colors.white,
          iconTheme: IconThemeData(
            color: Colors.black,
            size:30
          ),
            textTheme: TextTheme(
              title: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 25
              )
            ),
        ),
        textTheme: TextTheme(
          headline4: TextStyle(
            color: Colors.black,
            fontSize: 28,
            fontWeight: FontWeight.w500
          )
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.black,


        )

      ),
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
        future:Firebase.initializeApp(),
        builder: (context,snapshot){
           if(snapshot.hasError){
             print("Error");
          }
           if(snapshot.connectionState==ConnectionState.done){
             return home();
           }
           return CircularProgressIndicator();
        },
      ),
    );
  }
}
