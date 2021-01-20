import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:velocity_x/velocity_x.dart';
import 'package:intl/intl.dart';

class pastOrders extends StatefulWidget {
  static const routeName = '/pastOrders';
  @override
  _pastOrdersState createState() => _pastOrdersState();
}

class _pastOrdersState extends State<pastOrders> {
  User _user;
  @override
  void initState() {
    _user = FirebaseAuth.instance.currentUser;
    print(_user.uid);
    super.initState();
  }

  Color colors;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: "Past Orders".text.make(),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("UserOrders")
            .doc(_user.uid)
            .collection("UserOrders")
            .snapshots(),
        builder: (context, snapshot) {
          return snapshot.hasData
              ? snapshot.data.docs.isNotEmpty
                  ? ListView.builder(
                    cacheExtent: 9999,
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        return VxBox(
                          child: Column(
                            children: [
                              ListTile(
                                title: "${snapshot.data.docs[index]["title"]}"
                                    .text
                                    .xl
                                    .bold
                                    .make(),
                                // subtitle: "${DateFormat("dd-MM-yyyy").format(date)}"
                                //     .text
                                //     .make(),
                                leading: FadeInImage(
                                  image: NetworkImage(
                                      snapshot.data.docs[index]["image"]["0"]),
                                  placeholder: AssetImage(
                                      "assets/images/placeholder.jpg"),
                                ),
                                subtitle: Column(
                                  children: [
                                    "Order Id: ${snapshot.data.docs[index]["Order Id"]}"
                                        .text.lg
                                        .make(),
                                    RichText(
                                      text: TextSpan(
                                          text: "Order Status:",
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black54),
                                          children: [
                                            TextSpan(
                                                text: snapshot.data.docs[index]
                                                    ["Status"],
                                                style: TextStyle(
                                                    color: snapshot.data
                                                                    .docs[index]
                                                                ["Status"] ==
                                                            "Delivered"
                                                        ? Colors.green
                                                        : Colors.grey)),
                                          ]),
                                    ),
                                  ],
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                ),
                                trailing:
                                    "₹${snapshot.data.docs[index]["price"]}"
                                        .text
                                        .xl
                                        .bold
                                        .make(),
                              ).expand(),
                              Visibility(
                                visible: !(snapshot.data.docs[index]
                                            ["Status"] ==
                                        "Return Requested") ||
                                    DateTime.now()
                                            .difference(DateTime.parse(snapshot
                                                .data.docs[index]["Palced Date"]
                                                .toDate()
                                                .toString()))
                                            .inDays ==
                                        15,
                                child: FlatButton(
                                  shape: Vx.roundedLg,
                                  color: Colors.blueAccent,
                                  onPressed: () {
                                    showModalBottomSheet(
                                        context: context,
                                        builder: (context) {
                                          return dropDown(
                                              documents:
                                                  snapshot.data.docs[index]);
                                        });
                                  },
                                  child: "Request Return".text.white.xl.make(),
                                ),
                              )
                            ],
                          ),
                        )
                            .white
                            .height(context.percentHeight *15)
                            .shadow2xl
                            .make()
                            .p2();
                      },
                    )
                  : "No Orders Found".text.xl.black.make().centered()
              : CircularProgressIndicator().centered();
        },
      )
          .box
          .padding(EdgeInsets.all(15))
          .margin(EdgeInsets.only(top: 10, left: 7, right: 7, bottom: 10))
          .withDecoration(
            
            BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey.withOpacity(0.5), width: 3),
              borderRadius: BorderRadius.circular(
              55
              ),
            ),
          )
          .make(),
    );
  }
}

class dropDown extends StatefulWidget {
  final QueryDocumentSnapshot documents;

  const dropDown({Key key, this.documents}) : super(key: key);

  @override
  _dropDownState createState() => _dropDownState();
}

class _dropDownState extends State<dropDown> {
  User user = FirebaseAuth.instance.currentUser;

  List<DropdownMenuItem> dropdown = [
    DropdownMenuItem(
      value: "by mistake",
      child: "Order Created By Mistake".text.make(),
    ),
    DropdownMenuItem(
      value: "Not on Time",
      child: "Order Not Delivered on Time".text.make(),
    ),
    DropdownMenuItem(
      value: "Cheaper Somewhere",
      child: "Found some defacts".text.make(),
    ),
    DropdownMenuItem(
      value: "Chang Shipping Order",
      child: "Need to change Delivery Address".text.make(),
    ),
  ];
  String val = "Cheaper Somewhere";

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          "Select Reason".text.xl.bold.make().pOnly(bottom: 20),
          DropdownButton(
            hint: "Select Reason".text.make(),
            items: dropdown,
            value: val,
            onChanged: (value) {
              setState(() {
                val = value;
              });
            },
          ),
          RaisedButton(
            color: Colors.blueAccent,
            onPressed: () {
              FirebaseFirestore.instance.collection("Return Request").add({
                "title": widget.documents["title"],
                "price": widget.documents["price"],
                "reason": val,
                "Order Id": widget.documents["Order Id"]
              }).then((value) => print(value.id));
              FirebaseFirestore.instance
                  .collection("UserOrders")
                  .doc(user.uid)
                  .collection("UserOrders")
                  .doc(widget.documents.id)
                  .update({"Status": "Return Requested"});
              Navigator.pop(context);
            },
            child: "Submit".text.white.xl.make(),
          )
        ],
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
      ).box.height(200).make(),
    );
  }
}
