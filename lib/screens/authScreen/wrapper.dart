import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:onshop/screens/home/home.dart';
import 'package:velocity_x/velocity_x.dart';
import './phoneAuth.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, AsyncSnapshot<User> snapshot) {
        return snapshot.connectionState == ConnectionState.active
            ? (snapshot.hasData ? home() : phoneAuth())
            : Scaffold(
                backgroundColor: Colors.white,
                body: CircularProgressIndicator().centered());
      },
    );
  }
}
