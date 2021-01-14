import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:onshop/screens/information/information.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class detailPage extends StatefulWidget {
  static const routeName = '/detailPage';
  final String index;
  final dynamic details;
  detailPage({this.index, this.details});

  @override
  _detailPageState createState() => _detailPageState();
}

class _detailPageState extends State<detailPage> {
  User _user;
  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser;
    description();
  }

  List<Widget> textWidget = [];
  description() {
    for (var i in widget.details["description"]) {
      textWidget.add("${i}".text.start.xl.bold.make());
    }
    setState(() {});
  }

  Future<void> addToWishList() async {
    return await FirebaseFirestore.instance
        .collection("wishlist")
        .doc(_user.uid)
        .collection("Items")
        .doc(widget.details["title"])
        .set(widget.details.data());
  }

  Future<void> deleteWishlist() async {
    return await FirebaseFirestore.instance
        .collection("wishlist")
        .doc(_user.uid)
        .collection("Items")
        .doc(widget.details["title"])
        .delete();
  }

  Future<void> deleteCart() async {
    await FirebaseFirestore.instance
        .collection("cart")
        .doc(_user.uid)
        .collection("Items")
        .doc(widget.details["title"])
        .delete();
    key.currentState.showSnackBar(SnackBar(
      key: key,
      content: "Deleted From Bag".text.make(),
      action: SnackBarAction(
        label: "Ok",
        onPressed: () {},
      ),
    ));
  }

  Future<void> addToCart() async {
    print("Hello");
    await FirebaseFirestore.instance
        .collection("cart")
        .doc(_user.uid)
        .collection("Items")
        .doc(widget.details["title"])
        .set({
      "id": widget.details["id"],
      "title": widget.details["title"],
      "price": widget.details["price"],
      "quantity": 1,
      "image": widget.details["image"],
      "parent": widget.details["parent"],
      "description": widget.details["description"],
      "Pparent": widget.details["Pparent"],
      "Delivery Charges": widget.details["Delivery Charges"]
    });
    key.currentState.showSnackBar(SnackBar(
      content: "Added To Bag".text.make(),
    ));
  }

  final GlobalKey<ScaffoldState> key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    children: [
                      Hero(
                        tag: widget.index,
                        child: Column(
                          children: [
                            Swiper(
                              itemCount: widget.details["image"].length,
                              controller: SwiperController(),
                              layout: SwiperLayout.DEFAULT,
                              itemBuilder: (context, index) {
                                return Image.network(
                                  widget.details["image"][index.toString()],
                                  fit: BoxFit.fill,
                                );
                              },
                            ).pOnly(bottom: 10).expand(),
                            "${widget.details["title"]}"
                                .text
                                .xl2
                                .bold
                                .make()
                                .centered()
                                .pOnly(left: 10),
                            " ₹${widget.details["price"]}"
                                .text
                                .xl
                                .bold
                                .make()
                                .pOnly(left: 10)
                                .pOnly(bottom: 20),
                          ],
                        ),
                      ),
                      StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection("wishlist")
                              .doc(_user.uid)
                              .collection("Items")
                              .snapshots(),
                          builder: (context, snap) {
                            return snap.connectionState ==
                                    ConnectionState.active
                                ? Positioned(
                                    right: 20,
                                    bottom: 20,
                                    child: FlatButton(
                                      child: !snap.data.docs.any((element) =>
                                              element.data()["id"] ==
                                              widget.details["id"])
                                          ? FaIcon(
                                              FontAwesomeIcons.heart,
                                              color: Colors.redAccent,
                                            )
                                          : FaIcon(
                                              FontAwesomeIcons.solidHeart,
                                              color: Colors.redAccent,
                                            ),
                                      onPressed: () async {
                                        print(!snap.data.docs.any((element) =>
                                            element.data()["id"] ==
                                            widget.details["id"]));
                                        !(snap.data.docs.any((element) =>
                                                element.data()["id"] ==
                                                widget.details["id"]))
                                            ? addToWishList()
                                            : deleteWishlist();
                                      },
                                    ))
                                : Positioned(
                                    right: 20,
                                    bottom: 20,
                                    child: IconButton(
                                      onPressed: () {},
                                      icon: FaIcon(FontAwesomeIcons.heart),
                                    ),
                                  );
                          }),
                      Positioned(
                        top: 20,
                        left: 20,
                        child: GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: Icon(
                            Icons.arrow_back,
                            size: 30,
                          ),
                        ),
                      ),
                    ],
                  )
                      .box
                      .shadowLg
                      .withDecoration(BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromRGBO(0, 0, 0, 0.1),
                              blurRadius: 15.0,
                              spreadRadius: -3.0,
                              offset: Offset(0.0, 10.0),
                            ),
                            const BoxShadow(
                              color: Color.fromRGBO(0, 0, 0, 0.05),
                              blurRadius: 6.0,
                              spreadRadius: -2.0,
                              offset: Offset(0.0, 4.0),
                            ),
                          ],
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(30),
                              bottomRight: Radius.circular(30))))
                      .height(context.percentHeight * 70)
                      .make(),
                  "Details:"
                      .text
                      .xl2
                      .bold
                      .make()
                      .pOnly(bottom: 10, left: 10, top: 10),
                  // ListView.builder(
                  //         itemCount: widget.details["description"].length,
                  //         itemBuilder: (context, i) {
                  //           return "${widget.details["description"][i]}"
                  //               .text
                  //               .make();
                  //         })
                  //     .box
                  //     .height(context.safePercentHeight)
                  //     .width(context.screenWidth)
                  VxBox(
                      child: Column(
                    children: [
                      //     .make(),
                      Column(
                        children: textWidget,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                      ).pOnly(bottom: 10),

                      Card(
                        elevation: 4,
                        child: VxBox(
                            child: Column(
                          children: [
                            "Return Policy/Warranty"
                                .text
                                .xl
                                .start
                                .semiBold
                                .make()
                                .pOnly(bottom: 10),
                            "${widget.details["Return Policy"]}"
                                .text
                                .size(14)
                                .semiBold
                                .make(),
                          ],
                          crossAxisAlignment: CrossAxisAlignment.start,
                        )).p8.make(),
                      ),
                      HStack([
                        "Country Of Origin:".text.semiBold.size(16).make(),
                        "${widget.details["origin"]}"
                            .text
                            .size(16)
                            .semiBold
                            .make()
                      ]).pOnly(top: 20, left: 10),
                    ],
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                  )).make().p8()
                ],
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
              ),
            ).expand(),
            VxBox(
              child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("cart")
                      .doc(_user.uid)
                      .collection("Items")
                      .where("id", isEqualTo: widget.details["id"])
                      .snapshots(),
                  builder: (context, snapshot) {
                    return snapshot.connectionState == ConnectionState.active
                        ? Row(
                            children: [
                              FloatingActionButton(
                                      heroTag: "1",
                                      elevation: 6,
                                      onPressed: () => (!snapshot.data.docs.any(
                                              (element) =>
                                                  element.data()["id"] ==
                                                  widget.details["id"])
                                          ? addToCart()
                                          : deleteCart()),
                                      child: snapshot.data.docs.isEmpty
                                          ? VxBox(
                                              child: FaIcon(
                                              FontAwesomeIcons.shoppingBag,
                                              color: Colors.grey[700],
                                            )).make()
                                          : VxBox(
                                                  child: FaIcon(
                                                      FontAwesomeIcons
                                                          .shoppingBag,
                                                      color: Colors.blueAccent))
                                              .make()
                                      // child: HStack(
                                      //   [
                                      //     Image.asset(
                                      //             "assets/images/shopping-bag.png")
                                      //         .box
                                      //         .height(30)
                                      //         .make(),
                                      //   ],
                                      // ),

                                      )
                                  .box
                                  .make()
                                  .pOnly(left: 10, right: 10),
                              RaisedButton(
                                padding: EdgeInsets.symmetric(vertical: 20),
                                color: Colors.white,
                                elevation: 10,
                                shape: Vx.roundedLg,
                                onPressed: () {
                                  Navigator.of(context)
                                      .pushReplacement(CupertinoPageRoute(
                                          builder: (context) => information(
                                                total_price: widget
                                                    .details["price"]
                                                    .toString(),
                                                buy: true,
                                                documents: widget.details,
                                              )));
                                },
                                child: "Buy Now"
                                    .text
                                    .bold
                                    .xl
                                    .color(Colors.blueAccent)
                                    .make(),
                              ).pSymmetric(h: 30).expand()
                            ],
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          )
                        : CircularProgressIndicator().centered();
                  }),
            ).height(context.percentHeight * 10).make()
          ],
        ),
      ),
    );
  }
}
