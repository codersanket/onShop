import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/cartservices.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter/cupertino.dart';
import '../orderComplete/order.dart';
import '../../services/Controller.dart';
import '../changeAdress/changeAddress.dart';
import '../../widgets/appBar.dart';

class enterAdress extends StatefulWidget {
  final String total_price;
  final bool buy;
  final DocumentSnapshot documents;
  enterAdress({this.total_price, this.buy = true, this.documents});

  @override
  _enterAdressState createState() => _enterAdressState();
}

class _enterAdressState extends State<enterAdress> {
  User _user;
  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser;
  }

  TextEditingController _fullName = TextEditingController();
  TextEditingController _houseNumber = TextEditingController();
  TextEditingController _state = TextEditingController();
  TextEditingController _city = TextEditingController();
  TextEditingController _pinCode = TextEditingController();
  TextEditingController _phoneNumber = TextEditingController();
  TextEditingController _roadName = TextEditingController();
  Cartservices _cart = Get.put(Cartservices());

  final GlobalKey<ScaffoldState> _globalKey = GlobalKey();
  final GlobalKey<FormState> _form = GlobalKey();
  Controller c = Get.put(Controller());
  Cartservices cart = Get.find();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Users")
            .doc(_user.uid)
            .snapshots(),
        builder: (context, snapshot) {
          return snapshot.connectionState == ConnectionState.active
              ?
              // _fullName.text = snapshot.data.data()["Full Name"] ?? "";
              // _phoneNumber.text = snapshot.data.data()["Phone"] ?? "";
              // _pinCode.text = snapshot.data.data()["pincode"] ?? "";
              // _state.text = snapshot.data.data()["state"] ?? "";
              // _city.text = snapshot.data.data()["city"] ?? "";
              // _houseNumber.text = snapshot.data.data()["house_no"] ?? "";
              // _roadName.text = snapshot.data.data()["roadName"] ?? "";
              Scaffold(
                appBar: appBar(),
                  body: SafeArea(
                    child: Container(
                       padding: EdgeInsets.only(top: 20,bottom: 20,left: 10,right: 10),
                       margin: EdgeInsets.only(top: 10, left: 7, right: 7, bottom: 10),
        decoration: BoxDecoration(
           color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 0.1,
                      spreadRadius: 1.5,
                    )
                  ],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(55),
                    topRight: Radius.circular(55),
                    bottomLeft: Radius.circular(55),
                    bottomRight: Radius.circular(55),
                  ),
                ),
        
                      child: VStack([
                        !snapshot.data.exists
                            ? Column(
                              children: [
                                MaterialButton(
                                  padding:EdgeInsets.symmetric(horizontal:20,vertical:20),
                                  color: Colors.blueAccent,
                                  shape: Vx.roundedLg,
                                  child: "Add Adress".text.size(18).white.make(),
                                  onPressed: () {
                                    Navigator.of(context).push(MaterialPageRoute(
                                        builder: (context) => changeAdress()));
                                  },
                                ).box.width(context.screenWidth).make().pOnly(
                                  top: context.percentWidth*20,
                                  left: 20,
                                  right: 20
                                ),
                                "To Place order fill address. ".text.xl2.bold.make().pOnly(top: 12),
                                "ऑर्डर नक्की करण्यासाठी पत्ता भरा.".text.xl2.make().p2()
                                
                              ],
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                            )
                            : Card(
                              elevation: 6,
                              shape: Vx.roundedSm,
                                child: ZStack([
                                  VStack(
                                    [
                                      "Delivery Address"
                                          .text
                                          .xl2
                                          .bold
                                          .make()
                                          .pOnly(left: 10,top: 10,bottom: 10),
                                      Divider(
                                        color: Colors.grey.withOpacity(0.4),
                                        height: 20,
                                        thickness: 1.5,
                                      ),
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
                                       Navigator.of(context).push(MaterialPageRoute(builder: (context)=>changeAdress()));
                                      },
                                    ),
                                  ),
                                ]),
                              ),
                        Container().expand(),
                        RaisedButton(
                          color: Colors.blueAccent,
                          padding: EdgeInsets.symmetric(vertical: 20),
                          shape: Vx.roundedLg,
                          child: "Confirm Order".text.bold.size(18).white.make(),
                          onPressed: !snapshot.data.exists
                              ? null
                              : () {
                                  {
                                    Navigator.pushReplacement(
                                        context,
                                        CupertinoPageRoute(
                                            builder: (context) => orderComplete(
                                                  totalPrice: widget.buy
                                                      ? (int.parse(widget
                                                                  .total_price) +
                                                              widget.documents[
                                                                  "Delivery Charges"])
                                                          .toString()
                                                      : (cart.deliveryCharges
                                                                  .value +
                                                              int.parse(widget
                                                                  .total_price))
                                                          .toString(),
                                                  documentSnapshot:
                                                      widget.documents,
                                                  isBuying: widget.buy,
                                                )));
                                  }
                                },
                        ).box.width(context.screenWidth).padding(EdgeInsets.symmetric(horizontal
:12)).make()
                      ]),
                    ),
                  ),
                )
              : CircularProgressIndicator().centered();
        });
  }
}
