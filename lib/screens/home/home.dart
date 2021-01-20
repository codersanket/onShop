import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:neumorphic/neumorphic.dart';
import 'package:onshop/screens/Cart/cart.dart';
import 'package:onshop/screens/subCategory/subCategory.dart';
import 'package:onshop/screens/subSub/subSub.dart';

import 'package:onshop/widgets/appBar.dart';

import 'package:velocity_x/velocity_x.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class home extends StatefulWidget {
  static const routeName = '/home';

  @override
  _homeState createState() => _homeState();
}

class _homeState extends State<home> {
  User _user;
  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser;
    getData();
  }

  getData() async {
    print("Sanket");
    QuerySnapshot data =
        await FirebaseFirestore.instance.collection("Category").get();
    for (var i in data.docs) {
      print(i.data()["title"]);
    }
  }

  int length = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(isHomepage: false),
      body: Stack(
        children: [
          StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("Category")
                      .orderBy("id", descending: false)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      print(snapshot.data.docs[0]["title"]);
                    }
                    return snapshot.data != null
                        ? CustomScrollView(
                         physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                      
                            slivers: [
                              SliverList(
                                  delegate: SliverChildListDelegate([
                                    "Shop From City Store".text.bold.xl2.make().pOnly(bottom:5, left: 20),
                                    Divider(
                                      color: Colors.black.withOpacity(0.8),
                                    ).pOnly(right:20),
                                "Categories"
                                    .text
                                    .textStyle(Theme.of(context)
                                        .textTheme
                                        .headline4
                                        .copyWith(
                                          fontSize: 20,
                                          color: Colors.grey
                                        ))
                                    .make()
                                    .pOnly(bottom: 20, left: 20),
                              ])),
                              SliverGrid(
                                  delegate: SliverChildBuilderDelegate(
                                      (context, index) {
                                    return GestureDetector(
                                      onTap: () => Navigator.of(context)
                                          .push(CupertinoPageRoute(
                                              builder: (context) => subCategory(
                                                    id: snapshot
                                                        .data.docs[index]["id"],
                                                  ))),
                                      child: VStack(
                                        [
                                        
                                          Container(

                                              height:context.percentHeight * 10,
                                          width:context.percentHeight * 10,
                                            child: Card(
                                                elevation: 6,
                                                shape: Vx.roundedSm,
                                                child: FadeInImage(
                                                  placeholder: AssetImage(
                                                      "assets/images/placeholder.jpg"),
                                                  image: NetworkImage(snapshot
                                                      .data
                                                      .docs[index]["image"]),
                                                  fit: BoxFit.cover,
                                                ).p4()),
                                          )

                                             ,
                                          "${snapshot.data.docs[index]["title"]}"
                                              .text.maxLines(2)
                                              .overflow(
                                                  TextOverflow.ellipsis)
                                              .center
                                              .size(context.percentHeight*2.2)
                                              .semiBold
                                              .make().pOnly(top:3).expand()
                                             
                                        ],
                                        alignment: MainAxisAlignment.center,
                                        crossAlignment:
                                            CrossAxisAlignment.center,
                                      ),
                                    ).box.make().pOnly(right: 5);
                                  }, childCount: snapshot.data.docs.length),
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3,
                                          mainAxisSpacing: 30,
                                          crossAxisSpacing: 10)),
                              SliverList(
                                  delegate: SliverChildListDelegate([
                                "Recent Shopping From"
                                    .text
                                    .xl
                                    .bold
                                    .make()
                                    .pOnly(top: 20, left: 10, bottom: 20),
                                StreamBuilder<QuerySnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection("Past")
                                      .limit(10)
                                      .orderBy("Torders", descending: true)
                                      .snapshots(),
                                  builder: (context, snap) {
                                    return snap.hasData
                                        ? snap.data.docs.isEmpty
                                            ? "No Data Found"
                                                .text
                                                .make()
                                                .centered()
                                            : ListView.builder(
                                              physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                                              
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemCount:
                                                    snap.data.docs.length,
                                                itemBuilder: (context, index) {

                                                  return GestureDetector(
                                                    onTap: () => Navigator.push(
                                                        context,
                                                        CupertinoPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    subSub(
                                                                      subCategory: snap
                                                                          .data
                                                                          .docs[index],
                                                                    ))),
                                                    child: VxBox(
                                                      child: VStack(
                                                        [
                                                         
                                                          ClipOval(
                                                            
                                                            child: NeuCard(
                                                              curveType:
                                                                  CurveType
                                                                      .concave,
                                                              bevel: 15,
                                                              decoration: NeumorphicDecoration(
                                                                  color: Colors
                                                                      .white,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8)),
                                                              child:
                                                                  FadeInImage(
                                                                image: NetworkImage(snap
                                                                            .data
                                                                            .docs[
                                                                        index]
                                                                    ["image"]),
                                                                fit:
                                                                    BoxFit.fill,
                                                                placeholder:
                                                                    AssetImage(
                                                                        "assets/images/placeholder.jpg"),
                                                              )
                                                                      .box
                                                                      .height(
                                                                          80)
                                                                      .shadowLg
                                                                      .width(80)
                                                                      .make(),
                                                            ),
                                                          )
                                                              .box
                                                              .withDecoration(
                                                                  BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                    color: Colors
                                                                        .blueAccent,
                                                                    blurRadius:
                                                                        5.0,
                                                                    spreadRadius:
                                                                        0.5,
                                                                  )
                                                                ],
                                                              ))
                                                              .make().pOnly(top:5),
                                                         (20).heightBox,
                                                          "${snap.data.docs[index]["title"]}"
                                                              .text
                                                              .xl
                                                              .semiBold
                                                              .center
                                                              .make()
                                                              .box
                                                              .width(context
                                                                      .percentWidth *
                                                                  30)
                                                              .make()
                                                        ],
                                                        alignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                      ),
                                                    ).make(),
                                                  );
                                                },
                                              )
                                        : CircularProgressIndicator()
                                            .centered();
                                  },
                                ).h(context.percentWidth*50)
                              ]))
                            ],
                          )

                        // VxBox(
                        //     child: VStack([
                        //     "Categories"
                        //         .text
                        //         .textStyle(
                        //             Theme.of(context).textTheme.headline4.copyWith(
                        //                   fontSize: 22,
                        //                 ))
                        //         .make()
                        //         .pOnly(bottom: 20, left: 20),
                        //     VxBox(
                        //       child: GridView.builder(
                        //         physics: NeverScrollableScrollPhysics(),
                        //         scrollDirection: Axis.vertical,
                        //         gridDelegate:
                        //             SliverGridDelegateWithFixedCrossAxisCount(
                        //                 crossAxisCount: 3, mainAxisSpacing: 30),
                        //         itemBuilder: (context, index) {
                        //           return GestureDetector(
                        //             onTap: () => Navigator.of(context)
                        //                 .push(CupertinoPageRoute(
                        //                     builder: (context) => subCategory(
                        //                           id: snapshot.data.docs[index]
                        //                               ["id"],
                        //                         ))),
                        //             child: VStack(
                        //               [
                        //                 // VxBox(
                        //                 // child:
                        //                 NeuCard(
                        //                   curveType: CurveType.flat,
                        //                   bevel: 1,
                        //                   decoration: NeumorphicDecoration(
                        //                       color: Colors.blueAccent,
                        //                       borderRadius:
                        //                           BorderRadius.circular(8)),
                        //                   alignment: Alignment.center,
                        //                   child: Center(
                        //                       child: FadeInImage(
                        //                     placeholder: AssetImage(
                        //                         "assets/images/placeholder.jpg"),
                        //                     image: NetworkImage(
                        //                         snapshot.data.docs[index]["image"]),
                        //                   )),
                        //                 )
                        //                     .box
                        //                     .height(80)
                        //                     .width(80)
                        //                     //     .white
                        //                     //     .shadowLg
                        //                     //     .roundedSM
                        //                     .margin(EdgeInsets.all(10))
                        //                     .make(),
                        //                 "${snapshot.data.docs[index]["title"]}"
                        //                     .text
                        //                     .softWrap(true)
                        //                     .xl2
                        //                     .semiBold
                        //                     .make()
                        //               ],
                        //               alignment: MainAxisAlignment.center,
                        //               crossAlignment: CrossAxisAlignment.center,
                        //             ),
                        //           );
                        //         },
                        //         itemCount: snapshot.data.docs.length,
                        //       ),
                        //     )
                        //         .size(
                        //             context.screenWidth, context.percentHeight * 40)
                        //         .make(),
                        //     SizedBox(
                        //       height: 40,
                        //     ),
                        //     VxBox(
                        //             child: Column(
                        //       children: [
                        //         "Recent Shopping From"
                        //             .text
                        //             .xl
                        //             .bold
                        //             .make()
                        //             .pOnly(left: 10, bottom: 20),
                        //         StreamBuilder<QuerySnapshot>(
                        //           stream: FirebaseFirestore.instance
                        //               .collection("Past")
                        //               .limit(10)
                        //               .orderBy("Torders", descending: true)
                        //               .snapshots(),
                        //           builder: (context, snap) {
                        //             return snap.hasData
                        //                 ? snap.data.docs.isEmpty
                        //                     ? "No Data Found".text.make().centered()
                        //                     : ListView.builder(
                        //                         scrollDirection: Axis.horizontal,
                        //                         itemCount: snap.data.docs.length,
                        //                         itemBuilder: (context, index) {
                        //                           return GestureDetector(
                        //                             onTap: () => Navigator.push(
                        //                                 context,
                        //                                 CupertinoPageRoute(
                        //                                     builder: (context) =>
                        //                                         subSub(
                        //                                           subCategory: snap
                        //                                               .data
                        //                                               .docs[index],
                        //                                         ))),
                        //                             child: VxBox(
                        //                               child: VStack(
                        //                                 [
                        //                                   ClipOval(
                        //                                     clipBehavior: Clip
                        //                                         .antiAliasWithSaveLayer,
                        //                                     child: NeuCard(
                        //                                       curveType:
                        //                                           CurveType.concave,
                        //                                       bevel: 15,
                        //                                       decoration: NeumorphicDecoration(
                        //                                           color:
                        //                                               Colors.white,
                        //                                           borderRadius:
                        //                                               BorderRadius
                        //                                                   .circular(
                        //                                                       8)),
                        //                                       child: FadeInImage(
                        //                                         image: NetworkImage(
                        //                                             snap.data.docs[
                        //                                                     index]
                        //                                                 ["image"]),
                        //                                         fit: BoxFit.fill,
                        //                                         placeholder: AssetImage(
                        //                                             "assets/images/placeholder.jpg"),
                        //                                       )
                        //                                           .box
                        //                                           .height(80)
                        //                                           .shadowLg
                        //                                           .width(80)
                        //                                           .make(),
                        //                                     ),
                        //                                   )
                        //                                       .box
                        //                                       .withDecoration(
                        //                                           BoxDecoration(
                        //                                         shape:
                        //                                             BoxShape.circle,
                        //                                         boxShadow: [
                        //                                           BoxShadow(
                        //                                             color: Colors
                        //                                                 .blueAccent,
                        //                                             blurRadius: 5.0,
                        //                                             spreadRadius:
                        //                                                 0.5,
                        //                                           )
                        //                                         ],
                        //                                       ))
                        //                                       .make(),
                        //                                   (context.safePercentHeight)
                        //                                       .heightBox,
                        //                                   "${snap.data.docs[index]["title"]}"
                        //                                       .text
                        //                                       .xl
                        //                                       .semiBold
                        //                                       .center
                        //                                       .make()
                        //                                       .box
                        //                                       .width(context
                        //                                               .percentWidth *
                        //                                           30)
                        //                                       .make()
                        //                                 ],
                        //                                 alignment:
                        //                                     MainAxisAlignment.start,
                        //                                 crossAlignment:
                        //                                     CrossAxisAlignment
                        //                                         .center,
                        //                               ),
                        //                             ).make(),
                        //                           );
                        //                         },
                        //                       )
                        //                 : CircularProgressIndicator().centered();
                        //           },
                        //         ).expand()
                        //       ],
                        //       mainAxisAlignment: MainAxisAlignment.start,
                        //       crossAxisAlignment: CrossAxisAlignment.start,
                        //     ))
                        //         .height(context.percentHeight * 25)
                        //         .width(context.screenWidth)
                        //         .make()
                        //   ])).make()
                        : CircularProgressIndicator().centered();
                  })
              .pOnly(left: 10, top: 10)
              .box
              .height(context.screenHeight)
              .withDecoration(
                BoxDecoration(
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
              )
              .margin(EdgeInsets.only(top: 10, left: 7, right: 7, bottom: 10))
              .make(),
          Positioned(
            bottom: 30,
            right: 30,
            child: StreamBuilder<QuerySnapshot>(
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
                      : CircularProgressIndicator().centered();
                }),
          ),
        ],
      ),
      // drawer: Drawer(),

      // floatingActionButton: StreamBuilder<QuerySnapshot>(
      //     stream: FirebaseFirestore.instance
      //         .collection("cart")
      //         .doc(_user.uid)
      //         .collection("Items")
      //         .snapshots(),
      //     builder: (context, snapshot) {
      //       return snapshot.connectionState == ConnectionState.active
      //           ? Visibility(
      //               visible: snapshot.data.docs.length != 0,
      //               child: FloatingActionButton(
      //                 isExtended: true,
      //                 onPressed: () {
      //                   Navigator.push(
      //                       context,
      //                       CupertinoPageRoute(
      //                           builder: (context) => cartScreen()));
      //                 },
      //                 // child: HStack([
      //                 child: FaIcon(
      //                   FontAwesomeIcons.shoppingBag,
      //                   color: Colors.blueAccent,
      //                 ),
      //                 // Positioned(
      //                 //   right: 0,
      //                 //   child: Text(
      //                 //     "${snapshot.data.docs.length}",
      //                 //     style:
      //                 //         TextStyle(color: Colors.grey, fontSize: 16),
      //                 //   ),
      //                 // )

      //                 // SizedBox(
      //                 //   width: 10,
      //                 // ),
      //                 // Text(
      //                 //   "${snapshot.data.docs.length}",
      //                 //   style: TextStyle(color: Colors.black, fontSize: 16),
      //                 // )
      //                 //     .box
      //                 //     .padding(EdgeInsets.all(10))
      //                 //     .roundedFull
      //                 //     .gray400
      //                 //     .make()
      //                 // ]).pSymmetric(h: 20, v: 40),
      //               ),
      //             )
      //           : Container();
      //     }),
    );
  }
}
