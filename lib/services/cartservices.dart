import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/list_notifier.dart';
import 'package:sort_price/sort_price.dart';

enum paymentOption { paytm, cod }

class Cartservices extends GetxController {
  RxString finaltotal = "0".obs;
  var deliveryCharges = 0.obs;

  var paymentsite = paymentOption.cod.obs;

  getTotal(QuerySnapshot snapshot) {
    print("Started Get");
    int total = 0;
    int deliveryCharege = 0;
    snapshot.docs.forEach((element) {
      total = total + (element.data()["price"] * element.data()["quantity"]);
      deliveryCharege = deliveryCharege + element.data()["Delivery Charges"];
    });
    finaltotal.value = total.toString();
    deliveryCharges.value = deliveryCharege;
  }

  @override
  void onInit() {
    getProduct();

    super.onInit();
  }

  onChanged() {
    paymentsite = Rx(paymentOption.paytm);
  }

  getProduct() async {
    User _user = await FirebaseAuth.instance.currentUser;
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("cart")
        .doc(_user.uid)
        .collection("Items")
        .get();

    getTotal(snapshot);
  }
}
