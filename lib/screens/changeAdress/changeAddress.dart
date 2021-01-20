import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onshop/services/Controller.dart';
import 'package:onshop/widgets/textField.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../widgets/appBar.dart';

class changeAdress extends StatefulWidget {
  const changeAdress({Key key}) : super(key: key);

  @override
  _changeAdressState createState() => _changeAdressState();
}

class _changeAdressState extends State<changeAdress> {
  User _user;

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser;
  }

  TextEditingController _fullName = TextEditingController();
  TextEditingController _locality = TextEditingController();
  TextEditingController _state = TextEditingController(text: "Maharashtra");
  TextEditingController _city = TextEditingController(text: "Aurangabad");
  TextEditingController _pinCode = TextEditingController(text: "431001");
  TextEditingController _phoneNumber = TextEditingController();
  TextEditingController _address = TextEditingController();
  GlobalKey<FormState> _form = GlobalKey();
  Controller c = Get.put(Controller());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection("Users")
              .doc(_user.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data.exists) {
              _fullName.text = snapshot.data.data()["Full Name"] ?? "";
              _phoneNumber.text = snapshot.data.data()["Phone"] ?? "";
              // _pinCode.text = snapshot.data.data()["pincode"] ?? "";
              // _state.text = snapshot.data.data()["state"] ?? "";
              // _city.text = snapshot.data.data()["city"] ?? "";
              _locality.text = snapshot.data.data()["Locality"] ?? "";
              _address.text = snapshot.data.data()["Address"] ?? "";
            }

            return snapshot.connectionState == ConnectionState.active
                ? Container(
                  height: context.screenHeight,
                  padding: EdgeInsets.only(top: 20,bottom: 20),
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
                  child: SingleChildScrollView(
                    
                      child: Form(
                        key: _form,
                        child: Column(
                          children: [
                            "Address".text.xl2.bold.make(),
                            textField(
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Required Field";
                                } else
                                  return null;
                              },
                              onValueChanged: (value) {
                                _form.currentState.validate();
                              },
                              textEditingController: _fullName,
                              hint: "Full Name-तुमचे नाव",
                            ),
                            textField(
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Required Field";
                                }
                                if (value.length != 10) {
                                  return "Invalid Number";
                                }
                                return null;
                              },
                              onValueChanged: (String value) {
                                _form.currentState.validate();
                              },
                              textEditingController: _phoneNumber,
                              hint: "Phone Number-तुमचा मोबाईल नंबर",
                            ),
                            textField(
                              validator: (String value) {
                                if (value.isEmpty) {
                                  return "Required Field";
                                }

                                if (value.length != 6) {
                                  return "Incorrect Pincode";
                                }
                                return null;
                              },
                              onSubmitted: (value) {
                                c.getState(value);
                              },
                              onValueChanged: (String value) async {
                                _form.currentState.validate();
                                print("Hello");
                                if (value.length == 6) {
                                  await c.getState(value);
                                  _city.text = c.city.toString();
                                  _state.text = c.state.toString();
                                }
                              },
                              readOnly: true,
                              textEditingController: _pinCode,
                              hint: "Pincode-पिन कोड",
                            ),
                            HStack([
                              textField(
                                onValueChanged: (value) {
                                  _form.currentState.validate();
                                },
                                readOnly: true,
                                textEditingController: _state,
                                hint: "State-राज्य",
                              ).expand(),
                              textField(
                                onValueChanged: (value) {
                                  _form.currentState.validate();
                                },
                                textEditingController: _city,
                                readOnly: true,
                                hint: "City-शहर",
                              ).expand()
                            ]),
                            textField(
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Required Field";
                                } else
                                  return null;
                              },
                              onValueChanged: (value) {
                                _form.currentState.validate();
                              },
                              textEditingController: _locality,
                              hint: "Locality-परिसर",
                            ),
                            textField(
                              maxlines: 3,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Required Field";
                                } else
                                  return null;
                              },
                              onValueChanged: (value) {
                                _form.currentState.validate();
                              },
                              textInputAction: TextInputAction.done,
                              textEditingController: _address,
                              maxLength: 50,
                              hint:
                                  "Address(Area and Street)-तुमचा संपूर्ण पत्ता",
                            ),
                            // VxBox(
                            //         child: Card(
                            //   child: VStack(
                            //     [
                            //       HStack(
                            //         [
                            //           "Total Price:".text.xl.make(),
                            //           sortPrice(int.parse(widget.total_price))
                            //               .text
                            //               .xl
                            //               .make(),
                            //         ],
                            //         alignment: MainAxisAlignment.spaceEvenly,
                            //       )
                            //     ],
                            //   ).p8(),
                            // ))
                            //     .margin(EdgeInsets.all(10))
                            //     .height(100)
                            //     .width(context.screenWidth)
                            //     .make(),

                            // MaterialButton(
                            //   onPressed: () async {
                            //     // if (_option == paymentOption.paytm) {
                            //     //   startTransection(context);
                            //     // } else {
                            //     //   print(_option);
                            //     // }
                            //   },
                            //   child: "Order".text.white.xl.make(),
                            //   color: Colors.black,
                            //   shape: Vx.roundedLg,
                            // )
                            //     .box
                            //     .width(context.screenWidth)
                            //     .make()
                            //     .h(50)
                            //     .pSymmetric(h: 60, v: 10)

                            RaisedButton(
                              elevation: 6,
                              color: Colors.blueAccent,
                              shape: Vx.roundedLg,
                              padding: EdgeInsets.all(15),
                              onPressed: () async {
                                FocusScope.of(context).unfocus();
                                if (_form.currentState.validate()) {
                                  await FirebaseFirestore.instance
                                      .collection("Users")
                                      .doc(_user.uid)
                                      .set({
                                    "Full Name": _fullName.text.trim(),
                                    "Phone": _phoneNumber.text.trim(),
                                    "pincode": _pinCode.text.trim(),
                                    "state": _state.text.trim(),
                                    "city": _city.text.trim(),
                                    "Locality": _locality.text.trim(),
                                    "Address": _address.text.trim()
                                  }).then((value) {
                                    Navigator.pop(context);
                                  });
                                }
                              },
                              child: "Save".text.white.xl.make().centered(),
                            ).pSymmetric(h:50)
                          ],
                        ),
                      ).paddingOnly(bottom:12),
                    ),
                )
                : CircularProgressIndicator().centered();
          }).pOnly(top: 10,bottom: 10),
    );
  }
}
