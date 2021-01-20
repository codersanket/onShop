import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:onshop/screens/Pastorders/pastOrders.dart';

import 'package:onshop/screens/userDetails/editUser.dart';
import 'package:onshop/services/authservices.dart';
import 'package:onshop/widgets/appBar.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:url_launcher/url_launcher.dart';

class users extends StatefulWidget {
  static const routeName = '/user';
  users({Key key}) : super(key: key);

  @override
  _usersState createState() => _usersState();
}

class _usersState extends State<users> {
  User _user;
  DocumentSnapshot document;
  DocumentSnapshot tempData;
  @override
  void initState() {
    _user = FirebaseAuth.instance.currentUser;

    getUserProfile();
    super.initState();
  }

  getUserProfile() async {
    tempData = await FirebaseFirestore.instance
        .collection("Temp")
        .doc("orderId")
        .get();
    document = await FirebaseFirestore.instance
        .collection("Users")
        .doc(_user.uid)
        .get();
    setState(() {});
  }

  _makingPhoneCall(bool isMail) async {
    var url = isMail ? 'mailto:contact@onMarket.app' : 'tel:${tempData["num"]}';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print("Sorry");
    }
  }

  AuthServices auth = AuthServices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: document != null
          ? SingleChildScrollView(
                      child: Column(
                    children: [
                    (context.percentHeight * 4).heightBox,
                    Card(
                        elevation: 6,
                        child: Column(
                                children: [
                              "नमस्ते ! ${document.exists ? document["Full Name"] : "User"}"
                                  .text
                                  .xl2
                                  .bold
                                  .make()
                                  .pOnly(left: 20, bottom: 10),
                              Divider(
                                thickness: 1.5,
                              ),
                              ListTile(
                                  onTap: () => Navigator.of(context).push(
                                      CupertinoPageRoute(
                                          builder: (context) => editUser())),
                                  title: "Edit Details".text.make(),
                                  trailing:
                                      Icon(Icons.edit, color: Colors.blueAccent)),
                              Divider(
                                thickness: 1,
                              ),
                              ListTile(
                                onTap: () => Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                        builder: (context) => pastOrders())),
                                title: "Orders".text.make(),
                                trailing: FaIcon(FontAwesomeIcons.shoppingBag,
                                    color: Colors.blueAccent),
                              )
                            ],
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start)
                            .box
                            .make()),
                    // ClipOval(
                    //   child: FadeInImage(
                    //     image: NetworkImage(_user.photoURL ??
                    //         "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fupload.wikimedia.org%2Fwikipedia%2Fcommons%2Fthumb%2F7%2F7e%2FCircle-icons-profile.svg%2F1200px-Circle-icons-profile.svg.png&f=1&nofb=1"),
                    //     placeholder: AssetImage("assets/images/placeholder.jpg"),
                    //   ).box.height(100).width(100).shadowLg.make(),
                    // ).centered(),
                    // "${_user.displayName}".text.xl.bold.make(),

                    Card(
                        elevation: 6,
                        child: VxBox(
                            child: VStack([
                          "Discuss Your Questions"
                              .text
                              .bold
                              .xl
                              .make()
                              .pOnly(left: 20, top: 10),
                          Divider(
                            thickness: 1.5,
                            color: Colors.grey,
                          ),
                          ListTile(
                            onTap: () => _makingPhoneCall(true),
                            title: "Email Us".text.make(),
                            trailing: Icon(Icons.email, color: Colors.blueAccent),
                            subtitle: "contact@onmarket.app".text.make(),
                          ),
                          Divider(
                            thickness: 1,
                          ),
                          ListTile(
                            onTap: () => _makingPhoneCall(false),
                            title: "Call Us".text.make(),
                            trailing: Icon(Icons.call, color: Colors.blueAccent),
                            subtitle: "${tempData["num"]}".text.make(),
                          ),
                          ListTile(
                            onTap: () async {
                              await launch("mailto:sell@onMarket.app");
                            },
                            title: "For Business Enquiry".text.make(),
                            subtitle: "sell@onMarket.app".text.make(),
                            trailing: FaIcon(FontAwesomeIcons.handshake,
                                color: Colors.blueAccent),
                          )
                        ])).make()),
                    Card(
                      elevation: 6,
                      child: ListTile(
                        onTap: () async {
                          await launch(
                              "https://www.privacypolicygenerator.info/live.php?token=NnAMnMgjYe0SsRh5qziRRRxobZeSeiJq");
                        },
                        title: "Privacy".text.bold.make(),
                        trailing: Icon(Icons.shield, color: Colors.blueAccent),
                      ),
                    ),
                    Card(
                      elevation: 6,
                      child: ListTile(
                        onTap: () {
                          auth.signOut(context);
                        },
                        title: "LogOut".text.bold.make(),
                        trailing: Icon(
                          Icons.logout,
                          color: Colors.blueAccent,
                        ),
                      ),
                    ),
                  ],
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start)
                .box
                
                .withDecoration(
                  BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30)),
                  ),
                )
                .make(),
          )
          : CircularProgressIndicator().centered(),
    );
  }
}
