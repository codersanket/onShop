import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onshop/screens/changeAdress/changeAddress.dart';

import 'package:onshop/screens/orderComplete/order.dart';
import 'package:onshop/services/Controller.dart';
import 'package:onshop/services/cartservices.dart';
import 'package:onshop/widgets/textField.dart';

import 'package:sort_price/sort_price.dart';
import 'package:velocity_x/velocity_x.dart';
import './enterAdress.dart';
import '../../widgets/appBar.dart';

class information extends StatefulWidget {
  static const routeName = '/information';

  final String total_price;
  final bool buy;
  final DocumentSnapshot documents;
  information({this.total_price, this.buy = true, this.documents});
  @override
  _informationState createState() => _informationState();
}

class _informationState extends State<information> {
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
  User _user;
  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser;
  }

  Controller c = Get.put(Controller());
  Cartservices cart = Get.find();
  @override
  Widget build(BuildContext context) {
    print(widget.buy);
    return Scaffold(
      backgroundColor: Colors.white,
      key: _globalKey,
      appBar: appBar(),
      body: Container(
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
        
        child: Column(
          children:[
                      !widget.buy
                              ? 
                              Container()
                                : Card(
                                  shape: Vx.roundedSm,
                                    elevation: 6,
                                    child: HStack(
                                      [
                                        Image.network(
                                          widget.documents["image"]["0"],
                                          fit: BoxFit.contain,
                                        )
                                            .box
                                            .width(context.percentWidth * 40)
                                            .make().pOnly(right:20),
                                        VStack([
                                          
                                          "${widget.documents["title"]}"
                                          .text
                                          .xl
                                          .bold
                                          .make().box.width(context.percentWidth*30).make(),
                                          "₹${widget.documents["price"]}"
                                              .text
                                              .xl
                                              .bold
                                              .make(),
                                        ])
                                      ],
                                      alignment: MainAxisAlignment.start,
                                      crossAlignment: CrossAxisAlignment.center,
                                    ),
                                  )
                                    .pSymmetric(h: 20, v: 10)
                                    .box
                                    .height(context.percentHeight * 20)
                                    .width(context.screenWidth)
                                    .make(),
                            Card(
                               shape: Vx.roundedSm,
                                elevation: 6,
                                child: VStack([
                                  "Price Details"
                                      .text
                                      .xl2
                                      .bold
                                      .make()
                                      .pOnly(left: 5, top: 10),
                                  Divider(
                                    color: Colors.grey.withOpacity(0.4),
                                    height: 20,
                                    thickness: 1.5,
                                  ),
                                  Row(
                                    children: [
                                      "Price:".text.xl.semiBold.make(),
                                      "₹${sortPrice(int.parse(widget.total_price))}"
                                          .text
                                          .xl
                                          .semiBold
                                          .make(),
                                    ],
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                  ).pSymmetric(h: 10),
                                  (30).heightBox,
                                  Row(
                                    children: [
                                      "Delivery Charges:".text.xl.semiBold.make(),
                                      widget.buy
                                          ? "₹${sortPrice(widget.documents["Delivery Charges"])}"
                                              .text
                                              .xl
                                              .semiBold
                                              .make()
                                          : Obx(() =>
                                              "₹${sortPrice(cart.deliveryCharges.value)}"
                                                  .text
                                                  .xl
                                                  .semiBold
                                                  .make()),
                                    ],
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                  ).pSymmetric(h: 10),
                                  Divider(
                                    color: Colors.grey.withOpacity(0.4),
                                    height: 20,
                                    thickness: 1.5,
                                  ),
                                  Row(
                                    children: [
                                      "Total Amount:".text.xl2.semiBold.make(),
                                      widget.buy
                                          ? "₹${sortPrice(int.parse(widget.total_price) + widget.documents["Delivery Charges"])}"
                                              .text
                                              .xl2
                                              .semiBold
                                              .make()
                                          : Obx(() =>
                                              "₹${sortPrice(cart.deliveryCharges.value + int.parse(widget.total_price))}"
                                                  .text
                                                  .xl2
                                                  .semiBold
                                                  .make()),
                                    ],
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                  ).pSymmetric(h: 10, v: 10),
                                ])).pSymmetric(h: 20),
                          
                        
                        VxBox(
                          child: Card(
                            shape: Vx.roundedLg,
                            color: Colors.blueAccent,
                            elevation: 6,
                            child: ListTile(
                              onTap: () async {
                                
                                  Navigator.pushReplacement(
                                      context,
                                      CupertinoPageRoute(
                                          builder: (context) =>enterAdress(
                                            total_price: widget.total_price,
                                            buy: widget.buy,
                                            documents:widget.documents
                                          ) ));
                                
                              },
                              title: "Payment On Delivery"
                                  .text
                                  .white
                                  .xl2
                                  .bold
                                  .make(),
                              trailing: Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.white,
                              ),
                            ).centered(),
                          ).pSymmetric(h: 20),
                        ).make().h(70)
                      ],
                    ),
      )

                // ? SingleChildScrollView(
                //     child: Form(
                //       key: _form,
                //       child: Column(
                //         children: [
                //           textField(
                //             validator: (value) {
                //               if (value.isEmpty) {
                //                 return "Required Field";
                //               } else
                //                 return null;
                //             },
                //             onValueChanged: (value) {
                //               _form.currentState.validate();
                //             },
                //             textEditingController: _fullName,
                //             hint: "Full Name",
                //           ),
                //           textField(
                //             validator: (value) {
                //               if (value.isEmpty) {
                //                 return "Required Field";
                //               }
                //               if (value.length != 10) {
                //                 return "Invalid Number";
                //               }
                //               return null;
                //             },
                //             onValueChanged: (String value) {
                //               _form.currentState.validate();
                //             },
                //             textEditingController: _phoneNumber,
                //             hint: "Phone Number",
                //           ),
                //           textField(
                //             validator: (String value) {
                //               if (value.isEmpty) {
                //                 return "Required Field";
                //               }

                //               if (value.length != 6) {
                //                 return "Incorrect Pincode";
                //               }
                //               return null;
                //             },
                //             onSubmitted: (value) {
                //               c.getState(value);
                //             },
                //             onValueChanged: (String value) async {
                //               _form.currentState.validate();
                //               print("Hello");
                //               if (value.length == 6) {
                //                 await c.getState(value);
                //                 _city.text = c.city.toString();
                //                 _state.text = c.state.toString();
                //               }
                //             },
                //             textEditingController: _pinCode,
                //             hint: "Pincode",
                //           ),
                //           HStack([
                //             textField(
                //               onValueChanged: (value) {
                //                 _form.currentState.validate();
                //               },
                //               readOnly: true,
                //               textEditingController: _state,
                //               hint: "State",
                //             ).expand(),
                //             textField(
                //               onValueChanged: (value) {
                //                 _form.currentState.validate();
                //               },
                //               textEditingController: _city,
                //               readOnly: true,
                //               hint: "City",
                //             ).expand()
                //           ]),
                //           textField(
                //             validator: (value) {
                //               if (value.isEmpty) {
                //                 return "Required Field";
                //               } else
                //                 return null;
                //             },
                //             onValueChanged: (value) {
                //               _form.currentState.validate();
                //             },
                //             textEditingController: _houseNumber,
                //             hint: "Locality",
                //           ),
                //           textField(
                //             maxlines: 3,
                //             validator: (value) {
                //               if (value.isEmpty) {
                //                 return "Required Field";
                //               } else
                //                 return null;
                //             },
                //             onValueChanged: (value) {
                //               _form.currentState.validate();
                //             },
                //             textEditingController: _roadName,
                //             hint: "Address(Area and Street)",
                //           ),
                //           // VxBox(
                //           //         child: Card(
                //           //   child: VStack(
                //           //     [
                //           //       HStack(
                //           //         [
                //           //           "Total Price:".text.xl.make(),
                //           //           sortPrice(int.parse(widget.total_price))
                //           //               .text
                //           //               .xl
                //           //               .make(),
                //           //         ],
                //           //         alignment: MainAxisAlignment.spaceEvenly,
                //           //       )
                //           //     ],
                //           //   ).p8(),
                //           // ))
                //           //     .margin(EdgeInsets.all(10))
                //           //     .height(100)
                //           //     .width(context.screenWidth)
                //           //     .make(),

                //           // MaterialButton(
                //           //   onPressed: () async {
                //           //     // if (_option == paymentOption.paytm) {
                //           //     //   startTransection(context);
                //           //     // } else {
                //           //     //   print(_option);
                //           //     // }
                //           //   },
                //           //   child: "Order".text.white.xl.make(),
                //           //   color: Colors.black,
                //           //   shape: Vx.roundedLg,
                //           // )
                //           //     .box
                //           //     .width(context.screenWidth)
                //           //     .make()
                //           //     .h(50)
                //           //     .pSymmetric(h: 60, v: 10)
                //         ],
                //       ),
                //     ),
                //   )
                
          
          );
    
  }
}
