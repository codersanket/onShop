import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import 'package:onshop/screens/userDetails/user.dart';
import 'package:onshop/screens/wishListScreen.dart';
import 'package:onshop/services/UserController.dart';

import 'package:velocity_x/velocity_x.dart';

class appBar extends StatelessWidget with PreferredSizeWidget {
  final bool isHomepage;
  appBar({this.isHomepage = true});

  UserController userController = Get.find();

  @override
  Widget build(BuildContext context) {
    return AppBar(
        title: RichText(
            text: TextSpan(
          children: [
            TextSpan(
              text: "O",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  color: Colors.yellow.shade800),
            ),
            TextSpan(
              text: "nMarke",
              style: TextStyle(
                fontSize: 28,
                color: Colors.black,
              ),
            ),
            TextSpan(
              text: "T",
              style: TextStyle(
                letterSpacing: -6,
                fontSize: 30,
                color: Colors.black,
              ),
            ),
          ],
        )),
        // title: Image.asset("assets/images/appLogo.png").box.width(170).make(),
        actions: [
          GestureDetector(
              onTap: () => Navigator.push(context,
                  CupertinoPageRoute(builder: (sontext) => wishListScreen())),
              child: FaIcon(
                FontAwesomeIcons.heart,
                color: Colors.black,
                size: 27,
              ).centered().pOnly(
                    right: 20,
                  )),
          isHomepage
              ? Container()
              : GetBuilder<UserController>(
                  initState: userController.setProfile(),
                  builder: (val) => GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed("/user");
                    },
                    child: FaIcon(
                      FontAwesomeIcons.user,
                      size: 27,
                      color: Colors.black,
                    ),
                    // child: CircleAvatar(
                    // backgroundImage: NetworkImage(val.user.photoURL != null
                    //     ? val.user.photoURL
                    //     : "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fupload.wikimedia.org%2Fwikipedia%2Fcommons%2Fthumb%2F7%2F7e%2FCircle-icons-profile.svg%2F1200px-Circle-icons-profile.svg.png&f=1&nofb=1"),
                    // ).pOnly(right: 10),
                  ).centered().pOnly(right: 20),
                ),
        ]);
  }

  @override
  Size get preferredSize => Size(double.infinity, 60);
}
