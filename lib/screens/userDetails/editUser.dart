import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:onshop/screens/changeAdress/changeAddress.dart';
import 'package:onshop/widgets/appBar.dart';
import 'package:velocity_x/velocity_x.dart';

class editUser extends StatefulWidget {
  static const routeName = '/editUser';
  const editUser({Key key}) : super(key: key);

  @override
  _editUserState createState() => _editUserState();
}

class _editUserState extends State<editUser> {
  auth.User _user;
  @override
  void initState() {
    _user = auth.FirebaseAuth.instance.currentUser;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection("Users")
              .doc(_user.uid)
              .snapshots(),
          builder: (context, snapshot) {
            return snapshot.connectionState == ConnectionState.active
                ? Card(
                    elevation: 6,
                    child: VxBox(
                            child: snapshot.data.exists
                                ? ZStack([
                                    VStack(
                                      [
                                        "${snapshot.data.data()["Full Name"]}"
                                            .text
                                            .semiBold
                                            .xl
                                            .make()
                                            .pOnly(left: 20),
                                        "Phone No.: ${snapshot.data.data()["Phone"]}"
                                            .text
                                            .semiBold
                                            .xl
                                            .make()
                                            .pOnly(left: 20),
                                        "Address: ${snapshot.data.data()["Address"]}"
                                            .text
                                            .semiBold
                                            .xl
                                            .make()
                                            .pOnly(left: 20),
                                        "State: ${snapshot.data.data()["state"]}"
                                            .text
                                            .semiBold
                                            .xl
                                            .make()
                                            .pOnly(left: 20),
                                        "City: ${snapshot.data.data()["city"]}"
                                            .text
                                            .semiBold
                                            .xl
                                            .make()
                                            .pOnly(left: 20),
                                        "PinCode:${snapshot.data.data()["pincode"]}"
                                            .text
                                            .semiBold
                                            .xl
                                            .make()
                                            .pOnly(left: 20),
                                        "Locality: ${snapshot.data.data()["Locality"]}"
                                            .text
                                            .semiBold
                                            .xl
                                            .make()
                                            .pOnly(left: 20)
                                      ],
                                      alignment: MainAxisAlignment.start,
                                      crossAlignment: CrossAxisAlignment.start,
                                    ).pOnly(bottom: 40, top: 10),
                                    Positioned(
                                      right: 5,
                                      bottom: 5,
                                      child: RaisedButton(
                                        shape: Vx.roundedLg,
                                        color: Colors.blueAccent,
                                        child: "Edit".text.white.make(),
                                        onPressed: () {
                                          Navigator.of(context).push(
                                              CupertinoPageRoute(
                                                  builder: (context) =>
                                                      changeAdress()));
                                        },
                                      ),
                                    ),
                                  ])
                                : VStack([
                                    "Delivery Address"
                                        .text
                                        .xl2
                                        .bold
                                        .make()
                                        .pOnly(left: 5),
                                    Divider(
                                      color: Colors.grey.withOpacity(0.4),
                                      height: 20,
                                      thickness: 1.5,
                                    ),
                                    RaisedButton(
                                      shape: Vx.roundedLg,
                                      color: Colors.blueAccent,
                                      child: "Add Adresss".text.white.make(),
                                      onPressed: () {
                                        Navigator.of(context).push(
                                            CupertinoPageRoute(
                                                builder: (context) =>
                                                    changeAdress()));
                                      },
                                    ).centered(),
                                  ]))
                        .width(context.screenWidth)
                        .make(),
                  ).pSymmetric(h: 20)
                : CircularProgressIndicator().centered();
          }),
    );
  }
}
