import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:onshop/main.dart';
import 'package:onshop/screens/detailsPage/detailPage.dart';
import 'package:onshop/screens/home/home.dart';
import 'package:onshop/screens/userDetails/user.dart';
import 'package:velocity_x/velocity_x.dart';

class orderComplete extends StatefulWidget {
  static const routeName = '/orderComplete';
  final String totalPrice;
  final DocumentSnapshot documentSnapshot;
  final bool isBuying;
  orderComplete(
      {this.totalPrice, this.documentSnapshot, this.isBuying, Key key})
      : super(key: key);

  @override
  _orderCompleteState createState() => _orderCompleteState();
}

class _orderCompleteState extends State<orderComplete> {
  bool isLoading = true;

  @override
  void initState() {
    Future.delayed(Duration(seconds: 2)).then((value) {
      setState(() {
        isLoading = false;
      });
    });
    widget.isBuying ? directBuy() : removeCart();
    super.initState();
  }

  directBuy() async {
    User _user = FirebaseAuth.instance.currentUser;
    DocumentSnapshot userDeatils = await FirebaseFirestore.instance
        .collection("Users")
        .doc(_user.uid)
        .get();
    DocumentSnapshot snapsh = await FirebaseFirestore.instance
        .collection("Temp")
        .doc("orderId")
        .get();
    int id = snapsh["order"] + 1;
    String suffix = snapsh["suffix"];
    String orderId = "$suffix$id";

    FirebaseFirestore.instance
        .collection("UserOrders")
        .doc(_user.uid)
        .collection("UserOrders")
        .add({
      "id": widget.documentSnapshot.data()["id"],
      "title": widget.documentSnapshot.data()["title"],
      "price": widget.documentSnapshot.data()["price"],
      "image": widget.documentSnapshot.data()["image"],
      "parent": widget.documentSnapshot.data()["parent"],
      "description": widget.documentSnapshot.data()["description"],
      "Pparent": widget.documentSnapshot.data()["Pparent"],
      "Palced Date": DateTime.now(),
      "Delivey Charges": widget.documentSnapshot.data()["Delivery Charges"],
      "Status": "Order Placed",
      "Order Id": orderId,
    }).then((value) {
      FirebaseFirestore.instance
          .collection("UserOrders")
          .doc(_user.uid)
          .collection("User Details")
          .doc("Adress")
          .set(userDeatils.data());
    });
    FirebaseFirestore.instance
        .collection("AllOrders")
        .doc(orderId.toString())
        .collection("Items")
        .add({
      "id": widget.documentSnapshot.data()["id"],
      "title": widget.documentSnapshot.data()["title"],
      "price": widget.documentSnapshot.data()["price"],
      "image": widget.documentSnapshot.data()["image"],
      "parent": widget.documentSnapshot.data()["parent"],
      "description": widget.documentSnapshot.data()["description"],
      "Pparent": widget.documentSnapshot.data()["Pparent"],
      "Placed Date": DateTime.now(),
      "Status": "Order Placed",
      "Delivey Charges": widget.documentSnapshot.data()["Delivery Charges"],
      "Order Id": orderId,
      "User_Id": _user.uid,
    });
    FirebaseFirestore.instance
        .collection("AllOrders")
        .doc(orderId.toString())
        .set(userDeatils.data());

    QuerySnapshot snaps = await FirebaseFirestore.instance
        .collection("SubCategory")
        .where("parent", isEqualTo: widget.documentSnapshot["Pparent"])
        .get();
    snaps.docs.forEach((element) {
      FirebaseFirestore.instance
          .collection("SubCategory")
          .doc(element.id)
          .update({"Torders": element.data()["Torders"] + 1});
    });

    snaps.docs.forEach((element) {
      FirebaseFirestore.instance
          .collection("Past")
          .doc(element.data()["title"])
          .set(element.data());
      FirebaseFirestore.instance
          .collection("Past")
          .doc(element.data()["title"])
          .update({"Torders": DateTime.now()});
      FirebaseFirestore.instance
          .collection("AllOrders")
          .doc(orderId.toString())
          .update({"Total Price": widget.totalPrice, "Total Items": 1});
      FirebaseFirestore.instance
          .collection("Temp")
          .doc("orderId")
          .update({"order": id});
    });
    FirebaseFirestore.instance
        .collection("Temp")
        .doc("orderId")
        .update({"order": id});
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("Items")
        .where("id", isEqualTo: widget.documentSnapshot.data()["id"])
        .get();
    snapshot.docs.forEach((element) {
      FirebaseFirestore.instance
          .collection("Items")
          .doc(element.id)
          .update({"Q": element.data()["Q"] - 1});
    });
  }

  removeCart() async {
    User _user = FirebaseAuth.instance.currentUser;
    DocumentSnapshot userDaetils = await FirebaseFirestore.instance
        .collection("Users")
        .doc(_user.uid)
        .get();
    DocumentSnapshot snapsh = await FirebaseFirestore.instance
        .collection("Temp")
        .doc("orderId")
        .get();
    int id = snapsh["order"] + 1;
    String suffix = snapsh["suffix"];
    String orderId = "$suffix$id";

    QuerySnapshot i = await FirebaseFirestore.instance
        .collection("cart")
        .doc(_user.uid)
        .collection("Items")
        .get();
    i.docs.forEach((element) async {
      FirebaseFirestore.instance
          .collection("UserOrders")
          .doc(_user.uid)
          .collection("UserOrders")
          .add({
        "id": element.data()["id"],
        "title": element.data()["title"],
        "price": element.data()["price"],
        "image": element.data()["image"],
        "parent": element.data()["parent"],
        "description": element.data()["description"],
        "Pparent": element.data()["Pparent"],
        "Palced Date": DateTime.now(),
        "Status": "Order Placed",
        "Delivey Charges": element.data()["Delivery Charges"],
        "Order Id": orderId,
      }).then((value) {
        FirebaseFirestore.instance
            .collection("cart")
            .doc(_user.uid)
            .collection("Items")
            .doc(element.id)
            .delete();
        FirebaseFirestore.instance
            .collection("UserOrders")
            .doc(_user.uid)
            .collection("User Details")
            .doc("Adress")
            .set(userDaetils.data());
      });

      FirebaseFirestore.instance
          .collection("AllOrders")
          .doc(orderId.toString())
          .collection("Items")
          .add({
        "id": element.data()["id"],
        "title": element.data()["title"],
        "price": element.data()["price"],
        "image": element.data()["image"],
        "parent": element.data()["parent"],
        "description": element.data()["description"],
        "Pparent": element.data()["Pparent"],
        "Placed Date": DateTime.now(),
        "Status": "Order Placed",
        "Delivey Charges": element.data()["Delivery Charges"],
        "Order Id": orderId,
        "User_Id": _user.uid,
      });
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection("Items")
          .where("id", isEqualTo: element.data()["id"])
          .get();
      snapshot.docs.forEach((element) {
        FirebaseFirestore.instance
            .collection("Items")
            .doc(element.id)
            .update({"Q": element.data()["Q"] - 1});
      });
      FirebaseFirestore.instance
          .collection("AllOrders")
          .doc(orderId.toString())
          .set(userDaetils.data());

      QuerySnapshot snaps = await FirebaseFirestore.instance
          .collection("SubCategory")
          .where("parent", isEqualTo: element.data()["Pparent"])
          .get();
      snaps.docs.forEach((element) {
        FirebaseFirestore.instance
            .collection("SubCategory")
            .doc(element.id)
            .update({"Torders": element.data()["Torders"] + 1});
      });
      snaps.docs.forEach((element) {
        FirebaseFirestore.instance
            .collection("Past")
            .doc(element.data()["title"])
            .set(element.data());
        FirebaseFirestore.instance
            .collection("Past")
            .doc(element.data()["title"])
            .update({"Torders": DateTime.now()});
        FirebaseFirestore.instance
            .collection("AllOrders")
            .doc(orderId.toString())
            .update({
          "Total Price": widget.totalPrice,
          "Total Items": i.docs.length
        });
        FirebaseFirestore.instance
            .collection("Temp")
            .doc("orderId")
            .update({"order": id});
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: isLoading
          ? CircularProgressIndicator().centered()
          : Column(
              children: [
                LottieBuilder.asset("assets/cart.json")
                    .box
                    .height(context.percentHeight * 30)
                    .make(),
                "Thank You for Shopping"
                    .text
                    .xl
                    .bold
                    .make()
                    .centered()
                    .pOnly(bottom: 10),
                RaisedButton(
                  shape: Vx.roundedLg,
                  color: Colors.blueAccent,
                  onPressed: () => Navigator.of(context).pop(),
                  child: "Continue Shopping".text.white.make().p12(),
                )
              ],
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
            ),
    );
  }
}
