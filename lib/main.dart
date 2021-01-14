import 'package:custom_splash/custom_splash.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onshop/screens/Cart/cart.dart';
import 'package:onshop/screens/Pastorders/pastOrders.dart';

import 'package:onshop/screens/authScreen/loginScreen.dart';
import 'package:onshop/screens/authScreen/wrapper.dart';
import 'package:onshop/screens/detailsPage/detailPage.dart';
import 'package:onshop/screens/home/home.dart';
import 'package:onshop/screens/information/information.dart';
import 'package:onshop/screens/orderComplete/order.dart';

import 'package:onshop/screens/subCategory/subCategory.dart';
import 'package:onshop/screens/subSub/subSub.dart';
import 'package:onshop/screens/userDetails/editUser.dart';
import 'package:onshop/screens/userDetails/user.dart';
import 'package:onshop/screens/wishListScreen.dart';
import 'package:onshop/services/UserController.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: "/",
      routes: {
        information.routeName: (context) => information(),
        '/': (context) => Start(),
        '/wrapper': (context) => Wrapper(),
        '/login': (context) => loginScreen(),
        home.routeName: (context) => home(),
        detailPage.routeName: (context) => detailPage(),
        subCategory.routeName: (context) => subCategory(),
        subSub.routeName: (context) => subSub(),
        users.routeName: (context) => users(),
        orderComplete.routeName: (context) => orderComplete(),
        cartScreen.routeName: (context) => cartScreen(),
        wishListScreen.routeName: (context) => wishListScreen(),
        editUser.routeName: (context) => editUser(),
        pastOrders.routeName: (context) => pastOrders(),
      },
      theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: AppBarTheme(
            color: Colors.white,
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.black, size: 30),
            textTheme: TextTheme(
                title: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 25)),
          ),
          textTheme: TextTheme(
              headline4: TextStyle(
                  color: Colors.black,
                  fontSize: 28,
                  fontWeight: FontWeight.w500)),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            elevation: 4,
            backgroundColor: Colors.white,
          )),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Start extends StatelessWidget {
  UserController controller = Get.put(UserController());
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print("Error");
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return CustomSplash(
            home: Wrapper(),
            duration: 2000,
            imagePath: 'assets/images/logo.png',
          );
        }
        return Scaffold(
            backgroundColor: Colors.white,
            body: Center(child: CircularProgressIndicator()));
      },
    );
  }
}
