import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:onshop/widgets/appBar.dart';

import 'package:velocity_x/velocity_x.dart';
import 'package:onshop/screens/detailsPage/detailPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:sort_price/sort_price.dart';

class wishListScreen extends StatefulWidget {
  static const routeName = '/wishList';
  @override
  _wishListScreenState createState() => _wishListScreenState();
}

class _wishListScreenState extends State<wishListScreen> {
  User _user;
  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser;
    print(_user);
//
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar(),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("wishlist")
              .doc(_user.uid)
              .collection("Items")
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            return snapshot.connectionState == ConnectionState.active ||
                    _user.uid == null
                ? snapshot.data.docs.isEmpty
                    ? "No WishList Found".text.makeCentered()
                    : Column(
                        children: [
                          "WishList"
                              .text
                              .xl2
                              .bold
                              .make()
                              .pOnly(left: 20, top: 20),
                          ListView.builder(
                            itemCount: snapshot.data.docs.length,
                            itemBuilder: (context, index) => Card(
                              elevation: 6,
                              child: ListTile(
                                onTap: () => Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                        builder: (context) => detailPage(
                                              index: index.toString(),
                                              details:
                                                  snapshot.data.docs[index],
                                            ))),
                                trailing: IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () async {
                                    await FirebaseFirestore.instance
                                        .collection("wishlist")
                                        .doc(_user.uid)
                                        .collection("Items")
                                        .doc(snapshot.data.docs[index]["id"])
                                        .delete();     
                                  },
                                ),
                                title: snapshot.data.docs[index]["title"]
                                    .toString()
                                    .text
                                    .xl
                                    .semiBold
                                    .make(),
                                    subtitle: "₹${sortPrice(snapshot.data.docs[index]["price"])}".text.make(),
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      snapshot.data.docs[index]["image"]["0"]),
                                ),
                              ),
                            ),
                          ).expand()
                        ],
                      )
                : CircularProgressIndicator().centered();
          },
        )
            .box
            .withDecoration(
              BoxDecoration(
                color: Colors.white,
                border:
                    Border.all(color: Colors.grey.withOpacity(0.5), width: 3),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(55),
                  topRight: Radius.circular(55),
                ),
              ),
            )
            .make());
  }
}
