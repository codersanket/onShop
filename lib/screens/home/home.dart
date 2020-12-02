import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class home extends StatefulWidget {
  @override
  _homeState createState() => _homeState();
}

class _homeState extends State<home> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: "OnShop".text.make(),
        elevation: 6,
        actions: [
          CircleAvatar(
            backgroundColor: Vx.red500,
          ).pOnly(right: 20)
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("Category").snapshots(),
        builder: (context, snapshot) {
          final data=snapshot.data.docs;
          return snapshot.connectionState==ConnectionState.done?VxBox(
              child: HStack([
            "Category".text.textStyle(Theme.of(context).textTheme.headline4).make(),
            VxBox(
                child: GridView.builder(
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
              itemBuilder: (context, index) {
                return Text(data[index]["image"]);
              },
	          itemCount:data.length,
            )).make(),
          ])).make().pOnly(left: 20, top: 30):CircularProgressIndicator().centered();
        }
      ),
      drawer: Drawer(),
    );
  }
}
