import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:onshop/screens/information/information.dart';
import 'package:onshop/services/cartservices.dart';
import 'package:sort_price/sort_price.dart';
import 'package:velocity_x/velocity_x.dart';

class cartScreen extends StatefulWidget {
  static const routeName = '/cartScreen';
  @override
  _cartScreenState createState() => _cartScreenState();
}

class _cartScreenState extends State<cartScreen> {
  User _user;
  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser;
  }

  final Cartservices c = Get.put(Cartservices());

  @override
  Widget build(BuildContext context) {
    c.getProduct();
    return Scaffold(
      appBar: AppBar(
        title: "Cart".text.make(),
      ),
      backgroundColor: Colors.grey.shade300,
      body: _user != null
          ? StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("cart")
                  .doc(_user.uid)
                  .collection("Items")
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) c.getTotal(snapshot.data);
                return snapshot.connectionState == ConnectionState.active
                    ? snapshot.data.docs.length != 0
                        ? Column(
                            children: [
                              VxBox(
                                child: ListView.builder(
                                  itemCount: snapshot.data.docs.length,
                                  itemBuilder: (context, index) {
                                    return Card(
                                      child: VStack(
                                        [
                                          HStack(
                                            [
                                              VStack(
                                                [
                                                  "${snapshot.data.docs[index]["title"]}"
                                                      .text
                                                      .xl2
                                                      .semiBold
                                                      .make()
                                                      .pOnly(left: 20, top: 20),
                                                  "₹${sortPrice(snapshot.data.docs[index]["price"])}"
                                                      .text
                                                      .xl
                                                      .semiBold
                                                      .make()
                                                      .pOnly(left: 20, top: 5),
                                                ],
                                              ),
                                              SizedBox().expand(),
                                              FadeInImage(
                                                placeholder: AssetImage(
                                                    "assets/images/placeholder.jpg"),
                                                image: NetworkImage(snapshot
                                                    .data
                                                    .docs[index]["image"]["0"]),
                                              )
                                                  .box
                                                  .size(
                                                      context.percentWidth * 30,
                                                      context.percentHeight *
                                                          20)
                                                  .make(),
                                            ],
                                            alignment: MainAxisAlignment.start,
                                            crossAlignment:
                                                CrossAxisAlignment.start,
                                          ).expand(),
                                          VxBox(
                                                  child: FlatButton(
                                            onPressed: () async {
                                              await FirebaseFirestore.instance
                                                  .collection("cart")
                                                  .doc(_user.uid)
                                                  .collection("Items")
                                                  .doc(snapshot.data.docs[index]
                                                      ["title"])
                                                  .delete();
                                            },
                                            child: "Delete"
                                                .text
                                                .size(18)
                                                .semiBold
                                                .gray700
                                                .make(),
                                          ).centered())
                                              .height(50)
                                              .make()
                                        ],
                                        alignment: MainAxisAlignment.start,
                                        crossAlignment:
                                            CrossAxisAlignment.start,
                                      ),
                                    )
                                        .box
                                        .height(context.percentHeight * 20)
                                        .make();
                                  },
                                ),
                              ).make().expand(),
                              VxBox(
                                      child: HStack(
                                [
                                  Obx(() => Text(
                                        "₹" +
                                            sortPrice(int.parse(
                                                c.finaltotal.toString())),
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )),
                                  MaterialButton(
                                    onPressed: () {
                                      Navigator.pushReplacement(
                                          context,
                                          CupertinoPageRoute(
                                              builder: (context) => information(
                                                    total_price:
                                                        c.finaltotal.toString(),
                                                    buy: false,
                                                  )));
                                    },
                                    color: Colors.blueAccent,
                                    child: "Place Order".text.white.make(),
                                  )
                                ],
                                alignment: MainAxisAlignment.spaceAround,
                              ))
                                  .height(60)
                                  .width(context.screenWidth)
                                  .white
                                  .neumorphic()
                                  .make()
                            ],
                          )
                        : "Please Add Some Items\nin Cart"
                            .text
                            .black
                            .xl
                            .center
                            .makeCentered()
                    : LottieBuilder.asset(
                        "assets/cart.json",
                        repeat: true,
                      ).centered();
              })
          : CircularProgressIndicator().centered(),
    );
  }
}
