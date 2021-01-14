import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Controller extends GetxController {
  var city = "".obs;
  var state = "".obs;
  RxBool paytm = true.obs;
  RxBool cod = false.obs;

  @override
  void onInit() {
    super.onInit();
  }

  getState(String pincode) async {
    print(pincode);
    var response =
        await http.get("https://api.postalpincode.in/pincode/${pincode}");
    print("https://api.postalpincode.in/pincode/${pincode}");

    var data = jsonDecode(response.body);
    print(data);
    print(data[0]["PostOffice"][0]["District"]);

    city.value = data[0]["PostOffice"][0]["District"];
    state.value = data[0]["PostOffice"][0]["State"];
  }
}

// To parse this JSON data, do
//
//     final postCode = postCodeFromJson(jsonString);

PostCode postCodeFromJson(String str) => PostCode.fromJson(json.decode(str));

String postCodeToJson(PostCode data) => json.encode(data.toJson());

class PostCode {
  PostCode({
    this.message,
    this.status,
    this.postOffice,
  });

  String message;
  String status;
  List<PostOffice> postOffice;

  factory PostCode.fromJson(Map<String, dynamic> json) => PostCode(
        message: json["Message"],
        status: json["Status"],
        postOffice: List<PostOffice>.from(
            json["PostOffice"].map((x) => PostOffice.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Message": message,
        "Status": status,
        "PostOffice": List<dynamic>.from(postOffice.map((x) => x.toJson())),
      };
}

class PostOffice {
  PostOffice({
    this.name,
    this.description,
    this.branchType,
    this.deliveryStatus,
    this.circle,
    this.district,
    this.division,
    this.region,
    this.block,
    this.state,
    this.country,
    this.pincode,
  });

  String name;
  dynamic description;
  String branchType;
  String deliveryStatus;
  String circle;
  String district;
  String division;
  String region;
  String block;
  String state;
  String country;
  String pincode;

  factory PostOffice.fromJson(Map<String, dynamic> json) => PostOffice(
        name: json["Name"],
        description: json["Description"],
        branchType: json["BranchType"],
        deliveryStatus: json["DeliveryStatus"],
        circle: json["Circle"],
        district: json["District"],
        division: json["Division"],
        region: json["Region"],
        block: json["Block"],
        state: json["State"],
        country: json["Country"],
        pincode: json["Pincode"],
      );

  Map<String, dynamic> toJson() => {
        "Name": name,
        "Description": description,
        "BranchType": branchType,
        "DeliveryStatus": deliveryStatus,
        "Circle": circle,
        "District": district,
        "Division": division,
        "Region": region,
        "Block": block,
        "State": state,
        "Country": country,
        "Pincode": pincode,
      };
}
