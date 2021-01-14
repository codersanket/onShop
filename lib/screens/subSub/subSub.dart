import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:onshop/screens/Cart/cart.dart';
import 'package:onshop/screens/detailsPage/detailPage.dart';
import 'package:onshop/screens/subCategory/subCategory.dart';
import 'package:sort_price/sort_price.dart';

import 'package:onshop/widgets/appBar.dart';
import 'package:velocity_x/velocity_x.dart';

class subSub extends StatefulWidget {
  static const routeName = '/subSub';
  final dynamic subCategory;
  subSub({this.subCategory});

  @override
  _subSubState createState() => _subSubState();
}

class _subSubState extends State<subSub> {
  List list;

  int parent;
  List id = [];
  QuerySnapshot _querySnapshot;
  bool isLoading = true;
  User _user;

  @override
  void initState() {
    print(widget.subCategory["title"]);
    super.initState();
    getSubCategory();
    _user = FirebaseAuth.instance.currentUser;
  }

  Future<void> addToWishList(QueryDocumentSnapshot snapshot) async {
    return await FirebaseFirestore.instance
        .collection("wishlist")
        .doc(_user.uid)
        .collection("Items")
        .doc(snapshot["title"])
        .set(snapshot.data());
  }

  Future<void> deleteWishlist(QueryDocumentSnapshot snapshot) async {
    return await FirebaseFirestore.instance
        .collection("wishlist")
        .doc(_user.uid)
        .collection("Items")
        .doc(snapshot["title"])
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: parent == null
          ? CircularProgressIndicator().centered()
          : parent != 1
              ? StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("Items")
                      .where("Q", isNotEqualTo: 0)
                      .where("parent", isEqualTo: parent)
                      .snapshots(),
                  builder: (context, snapshot) {
                    return !snapshot.hasData
                        ? CircularProgressIndicator().centered()
                        : VxBox(
                            child: CustomScrollView(
                              slivers: [
                                SliverList(
                                  delegate: SliverChildListDelegate(
                                    [
                                      top(widget.subCategory, context)
                                          .box
                                          .height(context.percentHeight * 30)
                                          .make(),
                                      middle(widget.subCategory, context)
                                          .box
                                          .height(context.percentHeight * 15)
                                          .make()
                                          .pOnly(left: 10),
                                      "Our Best Products:-"
                                          .text
                                          .xl2
                                          .bold
                                          .make()
                                          .pOnly(left: 10),
                                    ],
                                  ),
                                ),
                                SliverGrid(
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                          childAspectRatio: 0.8,
                                          crossAxisCount: 2,
                                          crossAxisSpacing: 10,
                                          mainAxisSpacing: 10),
                                  delegate: SliverChildBuilderDelegate(
                                      (context, index) => GestureDetector(
                                            onTap: () => Navigator.push(
                                                context,
                                                CupertinoPageRoute(
                                                    builder: (context) =>
                                                        detailPage(
                                                          index:
                                                              index.toString(),
                                                          details: snapshot
                                                              .data.docs[index],
                                                        ))),
                                            child: VStack(
                                              [
                                                Expanded(
                                                  child: ZStack(
                                                    [
                                                      Hero(
                                                        tag: index,
                                                        child: VxBox()
                                                            .white
                                                            .rounded
                                                            .shadowLg
                                                            .bgImage(
                                                                DecorationImage(
                                                                    image:
                                                                        NetworkImage(
                                                                      snapshot
                                                                          .data
                                                                          .docs[index]["image"]["0"],
                                                                    ),
                                                                    fit: BoxFit
                                                                        .cover))
                                                            .make(),
                                                      ),
                                                      StreamBuilder<
                                                              QuerySnapshot>(
                                                          stream:
                                                              FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      "wishlist")
                                                                  .doc(
                                                                      _user.uid)
                                                                  .collection(
                                                                      "Items")
                                                                  .snapshots(),
                                                          builder:
                                                              (context, snap) {
                                                            return snap.connectionState ==
                                                                    ConnectionState
                                                                        .active
                                                                ? Positioned(
                                                                    right: 0,
                                                                    child:
                                                                        IconButton(
                                                                      icon: !snap.data.docs.any((element) =>
                                                                              element.data()["id"] ==
                                                                              snapshot.data.docs[index][
                                                                                  "id"])
                                                                          ? FaIcon(FontAwesomeIcons
                                                                              .heart)
                                                                          : FaIcon(
                                                                              FontAwesomeIcons.solidHeart),
                                                                      color: Colors
                                                                          .redAccent,
                                                                      onPressed:
                                                                          () async {
                                                                        print(!snap
                                                                            .data
                                                                            .docs
                                                                            .any((element) =>
                                                                                element.data()["id"] ==
                                                                                snapshot.data.docs[index]["id"]));
                                                                        !(snap.data.docs.any((element) =>
                                                                                element.data()["id"] ==
                                                                                snapshot.data.docs[index]["id"]))
                                                                            ? addToWishList(snapshot.data.docs[index])
                                                                            : deleteWishlist(snapshot.data.docs[index]);
                                                                      },
                                                                    )

                                                                    // Positioned(
                                                                    //   bottom: 10,
                                                                    //   right: 0,
                                                                    //   child: IconButton(
                                                                    //     onPressed: (){},
                                                                    //     icon:Icon(Icons.shopping_bag_outlined,color: Colors.black.withOpacity(0.6),size: 30,),
                                                                    //   ),
                                                                    // )
                                                                    )
                                                                : Positioned(
                                                                    right: 0,
                                                                    child:
                                                                        IconButton(
                                                                      onPressed:
                                                                          () {},
                                                                      icon: FaIcon(
                                                                          FontAwesomeIcons
                                                                              .heart),
                                                                    ),
                                                                  );
                                                          }),
                                                    ],
                                                  ),
                                                ),
                                                "${snapshot.data.docs[index]["title"]}"
                                                    .text
                                                    .size(20)
                                                    .bold
                                                    .make()
                                                    .pOnly(top: 10),
                                                "₹${sortPrice(snapshot.data.docs[index]["price"]) ?? ""}"
                                                    .text
                                                    .size(18)
                                                    .semiBold
                                                    .make()
                                              ],
                                              alignment:
                                                  MainAxisAlignment.center,
                                              crossAlignment:
                                                  CrossAxisAlignment.center,
                                            ),
                                          ),
                                      childCount: snapshot == null
                                          ? 0
                                          : snapshot.data.docs.length),
                                )
                              ],
                            ),
                          )
                            .height(context.screenHeight)
                            .withDecoration(BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(55),
                                    topRight: Radius.circular(55))))
                            .make();
                  })
              : "Categories Not Found "
                  .text
                  .xl
                  .make()
                  .centered()
                  .pOnly(left: 10, top: 10),
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
                : CircularProgressIndicator().centered();
          }),
    );
  }

  Widget top(dynamic subCategory, BuildContext context) {
    print(subCategory["title"]);
    return ZStack(
      [
        Positioned(
          top: 0,
          child: VxBox()
              .height(context.percentHeight * 18)
              .width(context.screenWidth)
              .withDecoration(
                BoxDecoration(
                  border: Border.all(color: Colors.blueAccent, width: 2),
                  image: DecorationImage(
                      image: NetworkImage(subCategory["bg"]),
                      fit: BoxFit.cover),
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(55),
                    topRight: Radius.circular(55),
                  ),
                ),
              )
              .make(),
        ),
        Positioned(
          bottom: 5,
          left: 10,
          child: HStack(
            [
              ClipOval(
                child: FadeInImage(
                  placeholder: AssetImage("assets/images/placeholder.jpg"),
                  image: NetworkImage(
                    subCategory["image"],
                  ),
                  fit: BoxFit.cover,
                ).box.color(Colors.white).height(100).width(100).make(),
              ),
              // CircleAvatar(
              //   backgroundColor: Colors.white,
              //   radius: 50,
              //   child: CircleAvatar(
              //     radius: 45,
              //     backgroundImage: NetworkImage(subCategory["image"]),
              //   ),
              // ),
              Column(
                children: [
                  " ${subCategory["title"]}"
                      .text
                      .xl3
                      .bold
                      .start
                      .make()
                      .pOnly(top: 20),
                  VxBox(
                          child: "  ${subCategory["subTitle"]}"
                              .text
                              .size(14)
                              .gray700
                              .start
                              .make())
                      .width(context.percentWidth * 70)
                      .make()
                ],
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
              ),
            ],
            alignment: MainAxisAlignment.end,
            crossAlignment: CrossAxisAlignment.start,
          ),
        )
      ],
    );
  }

  Future<QuerySnapshot> getSubCategory() async {
    QuerySnapshot result = await FirebaseFirestore.instance
        .collection("SubSubCat")
        .where("parent", isEqualTo: widget.subCategory["id"])
        .get();
    print(result.docs[0]["id"]);

    parent = result.docs.isEmpty ? 1 : result.docs[0]["id"];
    _querySnapshot = result;
    setState(() {});
    return result;
  }

  Widget middle(dynamic SubCategory, BuildContext context) {
    return VxBox(
            child: _querySnapshot != null
                ? _querySnapshot.docs.isNotEmpty
                    ? ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _querySnapshot.docs.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                parent = _querySnapshot.docs[index]["id"];
                              });
                            },
                            child: Column(
                              children: [
                                CircleAvatar(
                                  radius:
                                      parent == _querySnapshot.docs[index]["id"]
                                          ? 37
                                          : 30,
                                  child: CircleAvatar(
                                    radius: parent ==
                                            _querySnapshot.docs[index]["id"]
                                        ? 35
                                        : 30,
                                    backgroundImage: NetworkImage(
                                        _querySnapshot.docs[index]["image"]),
                                  ),
                                ).pOnly(left: 10, bottom: 5),
                                "${_querySnapshot.docs[index]["title"]}"
                                    .text
                                    .xl
                                    .center
                                    .semiBold
                                    .make()
                              ],
                            ),
                          );
                        },
                      )
                    : "No Data Found".text.make()
                : CircularProgressIndicator().centered())
        .make();
  }
}
