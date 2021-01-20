import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:onshop/screens/information/information.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

import 'package:sort_price/sort_price.dart';

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

  int length=0;

  List<Widget> textWidget = [];
  description() {
   

    for (var i in widget.details["description"]) {
      textWidget.add(Row(
        children: [
          "- ".text.bold.make(),
          "${i}".text.start.xl.gray700.semiBold.make().expand()
        ],
      ));
    }
    setState(() {});
  }

  Future<void> addToWishList() async {

   
    return await FirebaseFirestore.instance
        .collection("wishlist")
        .doc(_user.uid)
        .collection("Items")
        .doc(widget.details["id"])
        .set(widget.details.data());
  }

  Future<void> deleteWishlist() async {
    return await FirebaseFirestore.instance
        .collection("wishlist")
        .doc(_user.uid)
        .collection("Items")
        .doc(widget.details["id"])
        .delete();
  }

  Future<void> deleteCart() async {
    await FirebaseFirestore.instance
        .collection("cart")
        .doc(_user.uid)
        .collection("Items")
        .doc(widget.details["id"])
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
    print(widget.details.id);
    await FirebaseFirestore.instance
        .collection("cart")
        .doc(_user.uid)
        .collection("Items")
        .doc(widget.details["id"])
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
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  Stack(
                    children: [
                      Column(
                        children: [
                          Swiper(
                            loop: false,
                            
                            itemCount: widget.details["image"].length,
                            controller: SwiperController(),
                            layout: SwiperLayout.DEFAULT,
                            pagination: SwiperPagination(alignment: Alignment.bottomCenter,builder:SwiperPagination.dots),
                            itemBuilder: (context, index) {
                              return VxBox().withDecoration(
                                BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                image:NetworkImage(widget.details["image"][index.toString()])
                              ))).make();
                              
                            },
                          ).pOnly(bottom: 10,left: 10,right: 10,top: 10).expand(),
                          "${widget.details["title"]}"
                              .text
                              .xl2
                              .bold
                              .make()
                              .centered()
                              .pOnly(left: 10),
                          " ₹ ${sortPrice(widget.details["price"])}"
                              .text
                              .xl
                              .bold
                              .make()
                              .pOnly(left: 10)
                              .pOnly(bottom: 20),
                        ],
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
                                    bottom: 10,
                                    child: FlatButton(
                                      hoverColor: Colors.transparent,
                                      color: Colors.transparent,
                                      splashColor: Colors.transparent,
                                      shape: Vx.roundedLg,
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
                                            padding: EdgeInsets.symmetric(horizontal: 20,vertical: 30),
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
                        top: 15,
                        left: 10,
                        child: NeumorphicButton(
                          
                          style: NeumorphicStyle(
                            color: Colors.white,
                            boxShape: NeumorphicBoxShape.circle(),
                          
                          ),
                         
                        onPressed: () => Navigator.of(context).pop(),
                          child: Icon(
                            Icons.arrow_back_rounded,
                            size: 24,
                            color: Colors.black,
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
                          border: Border.all(color:Colors.black),
                          borderRadius: BorderRadius.circular(
                            30)))
                      .height(context.percentHeight * 74)
                      .make().pOnly(left:12,right:12,top:12),
                  "Product Details :- "
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

                      VxBox(
                          child: Column(
                        children: [
                          "Return Policy/Warranty"
                              .text
                              .xl
                              .start
                              .bold
                              .make()
                              .pOnly(bottom: 10),
                          "${widget.details["Return Policy"]}"
                              .text
                              .size(14)
                              .semiBold
                              .make(),
                        ],
                        crossAxisAlignment: CrossAxisAlignment.start,
                      )).withDecoration
                      
                      (BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      
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
                        ])).rounded.padding(EdgeInsets.symmetric(horizontal: 20,vertical: 20)).make(),

                        (context.percentHeight*3).heightBox,
                            VxBox(
                          child: "This Product is original and 100% Genuine"
                              .text
                              .xl
                              .start
                              .bold
                              .make()
                             ).withDecoration(BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          
                        ),
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
                        ])).rounded.padding(EdgeInsets.symmetric(horizontal: 10,vertical: 10)).make(),
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
                                  .box.roundedFull.border()
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
                                    .size(context.percentHeight*2.1)
                                    .color(Colors.blueAccent)
                                    .make(),
                              ).box.withDecoration(
                                BoxDecoration(
                                  color: Colors.transparent,
                                  border: Border.all(),borderRadius: BorderRadius.circular(30))).make().pSymmetric(h: 30).expand()
                            ],
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          )
                        : CircularProgressIndicator().centered();
                  }),
            ).height(context.percentHeight*12).make()
          ],
        ),
      ),
    );
  }
}
