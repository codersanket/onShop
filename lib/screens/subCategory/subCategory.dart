import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:neumorphic/neumorphic.dart';
import 'package:onshop/screens/Cart/cart.dart';
import 'file:///C:/flutter/flutterProject/onshop/lib/screens/subSub/subSub.dart';
import 'package:onshop/widgets/appBar.dart';
import 'package:velocity_x/velocity_x.dart';

class subCategory extends StatefulWidget {
  static const routeName = '/subCategory';
  final int id;
  subCategory({this.id});
  @override
  _subCategoryState createState() => _subCategoryState();
}

class _subCategoryState extends State<subCategory> {
  User _user;
  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    print(widget.id);
    return Scaffold(
      appBar: appBar(),
      body: VxBox(
        child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("SubCategory")
                .where("parent", isEqualTo: widget.id)
                .snapshots(),
            builder: (context, snapshot) {
              return snapshot.hasData
                  ? CustomScrollView(
                      slivers: [
                        SliverList(
                          delegate: SliverChildListDelegate([
                            "Your Favorite Store"
                                .text
                                .textStyle(Theme.of(context)
                                    .textTheme
                                    .headline4
                                    .copyWith(fontSize: 22))
                                .make()
                                .pOnly(top: 20, left: 20, bottom: 10),
                          ]),
                        ),
                        SliverGrid(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  mainAxisSpacing: 5,
                                  crossAxisSpacing: 5,
                                  crossAxisCount: 3,
                                  childAspectRatio: 0.7),
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: () => Navigator.of(context)
                                    .push(CupertinoPageRoute(
                                        builder: (contex) => subSub(
                                              subCategory:
                                                  snapshot.data.docs[index],
                                            ))),
                                child: VStack(
                                  [
                                    NeuCard(
                                            curveType: CurveType.concave,
                                            bevel: 15,
                                            decoration: NeumorphicDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(8)),
                                            child: FadeInImage(
                                              placeholder: AssetImage(
                                                  "assets/images/placeholder.jpg"),
                                              image: NetworkImage(snapshot
                                                  .data.docs[index]["image"]),
                                            ).p8()
                                            // child: CircleAvatar(
                                            //   backgroundImage: NetworkImage(
                                            //       snapshot.data.docs[index]["image"]),
                                            //   radius: 50,
                                            // ),
                                            )
                                        .box
                                        .make()
                                        .expand(),
                                    (5).heightBox,
                                    "${snapshot.data.docs[index]["title"]}"
                                        .text
                                        .center
                                        .xl2
                                        .make(),
                                    HStack([
                                      "( ".text.make(),
                                      FaIcon(
                                        FontAwesomeIcons.shoppingBag,
                                        color: Colors.black,
                                        size: 17,
                                      ),
                                      " ${snapshot.data.docs[index]["Torders"]}"
                                          .text
                                          .xl
                                          .make(),
                                      ")".text.make()
                                    ])
                                  ],
                                  alignment: MainAxisAlignment.center,
                                  crossAlignment: CrossAxisAlignment.center,
                                ),
                              );
                            },
                            childCount: snapshot.data.docs.length,
                          ),
                        )
                      ],
                    )
                  : VxBox(child: CircularProgressIndicator().centered())
                      .white
                      .make();
            }).px2(),
      )
          .height(context.screenHeight)
          .withDecoration(
            BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.blueAccent,
                  blurRadius: 0.1,
                  spreadRadius: 1.5,
                )
              ],
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(55),
                topRight: Radius.circular(55),
              ),
            ),
          )
          .margin(EdgeInsets.only(top: 10))
          .make(),
      floatingActionButton: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("cart")
              .doc(_user.uid)
              .collection("Items")
              .snapshots(),
          builder: (context, snapshot) {
            return snapshot.connectionState == ConnectionState.active
                ? Visibility(
                    visible: snapshot.data.docs.length != 0,
                    child: FloatingActionButton(
                        isExtended: true,
                        onPressed: () {
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (contex) => cartScreen()));
                        },
                        child: FaIcon(
                          FontAwesomeIcons.shoppingBag,
                          color: Colors.blueAccent,
                        )),
                  )
                : CircularProgressIndicator();
          }),
    );
  }
}
