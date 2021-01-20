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

      print(snapshot.data()["id"]);
     await FirebaseFirestore.instance
        .collection("wishlist")
        .doc(_user.uid)
        .collection("Items")
        .doc(snapshot["id"])
        .set(snapshot.data());


 


  }

  Future<void> deleteWishlist(QueryDocumentSnapshot snapshot) async {
     await FirebaseFirestore.instance
        .collection("wishlist")
        .doc(_user.uid)
        .collection("Items")
        .doc(snapshot["id"])
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: parent == null
          ? CircularProgressIndicator().centered()
          : parent != 1
              ? Stack(
                children: [
                  StreamBuilder<QuerySnapshot>(
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
                                    physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                                 
                                  cacheExtent: 9999,
                                  slivers: [
                                    SliverList(
                                      delegate: SliverChildListDelegate(
                                        [
                                          top(widget.subCategory, context)
                                             ,
                                              (context.percentHeight*2).heightBox,
                                          middle(widget.subCategory, context)
                                              .box
                                              .height(context.percentHeight * 18)
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
                                              childAspectRatio: 0.7,
                                              crossAxisCount: 2,
                                              crossAxisSpacing: 5,
                                              mainAxisSpacing: 5 ),
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
                                                    ZStack(
                                                      
                                                      [
                                                        VxBox()
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
                                                                        .fitHeight))
                                                            .make(),
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
                                                    ).box.height(context.percentHeight*19).make(),
                                                    "${snapshot.data.docs[index]["title"]}"
                                                    
                                                     .text.overflow(TextOverflow.ellipsis)
                                                     .size(18).maxLines(2)
                                                     .bold.center
                                                     .make()
                                                     .pOnly(top: 10),
                                                  
                                                  // if(snapshot.data.docs[index]["Subtitle"].isNotEmpty) FittedBox(
                                                  //     child: "${snapshot.data.docs[index]["Subtitle"]}"
                                                  //         .text.gray700
                                                  //         .size(14)
                                                  //         .semiBold
                                                  //         .make()
                                                  //        ,
                                                  //   ),

                                                    FittedBox(
                                                        child: "₹${sortPrice(snapshot.data.docs[index]["price"]) ?? ""}"
                                                          .text.start
                                                          .size(16)
                                                          .semiBold
                                                          .make(),
                                                    ),
                                                  ],
                                                  alignment:
                                                      MainAxisAlignment.center,
                                                  crossAlignment:
                                                      CrossAxisAlignment.center,
                                                ),
                                              ).pOnly(left:10,right: 10),
                                          childCount: snapshot == null
                                              ? 0
                                              : snapshot.data.docs.length),
                                    )
                                  ],
                                ).box.withDecoration(BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                       55)
                                )).margin(EdgeInsets.symmetric(horizontal: 13,vertical: 13)).make(),
                              )
                                
                                .make();
                      }).box.height(context.screenHeight)
                                .withDecoration(
                                 
                                  BoxDecoration(
                                     boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 0.1,
                      spreadRadius: 1.5,
                    )],
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(
                                       55))).margin(EdgeInsets.all(10)).make(),

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
              )
              : "Categories Not Found "
                  .text
                  .xl
                  .make()
                  .centered()
                  .pOnly(left: 10, top: 10),
    
    );
  }

  Widget top(dynamic subCategory, BuildContext context) {
    print(subCategory["title"]);
    return VStack(
      [
        VxBox()
            .height(context.percentHeight * 20)
            .width(context.screenWidth)
            .withDecoration(
              BoxDecoration(
               
                image: DecorationImage(
                    image: NetworkImage(subCategory["bg"]),
                    fit: BoxFit.cover),
             
                borderRadius: BorderRadius.only(
                   topLeft: Radius.circular(55),
                topRight: Radius.circular(55),
                bottomLeft: Radius.circular(55),
                bottomRight: Radius.circular(55),
                ),
              ),
            )
            .make(),
            (context.percentHeight*2).heightBox,
         HStack(
            [
             
              ClipOval(
                child: FadeInImage(
                  placeholder: AssetImage("assets/images/placeholder.jpg"),
                  image: NetworkImage(
                    subCategory["image"],
                  ),
                  fit: BoxFit.cover,
                ).box.color(Colors.white).height(context.percentHeight*12).width(context.percentHeight*12).make(),
              ),
              // CircleAvatar(
              //   backgroundColor: Colors.white,
              //   radius: 50,
              //   child: CircleAvatar(
              //     radius: 45,
              //     backgroundImage: NetworkImage(subCategory["image"]),
              //   ),
              // ),
              SizedBox(width: 10),
              Column(
                children: [
                  "${subCategory["title"]}"
                      .text
                      .size(context.percentHeight*3)
                      .bold
                      .start
                      .make()
                      .box.width(context.percentWidth * 50).make(),
                     RichText(
              text: TextSpan(children: [
            TextSpan(
                text: "Address :-\u200B",
                style: TextStyle(color: Colors.black,
                fontWeight:FontWeight.w700,
                 fontSize: 14)),
            TextSpan(
              text: "${subCategory["subTitle"]}",
              style: TextStyle(
                  color: Colors.black,
                
                  fontSize:14 ),
            ),
            
          ])).box.width(context.percentWidth*50).make(),


                  // Row(
                  //     children: [
                  //       "Address :- ".text.semiBold.make(),
                  //       VxBox(
                  //                 child: "${subCategory["subTitle"]}"
                  // .text.maxLines(3)
                  // .size(14)
                  // .gray700
                  // .start
                  // .make())
                              
                  //            .width(context.percentWidth*43) .make(),
                  //     ],
                  //     mainAxisAlignment: MainAxisAlignment.start,
                  //     crossAxisAlignment: CrossAxisAlignment.start
                  //   )
                ],
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
              ),
            ],
            alignment: MainAxisAlignment.start,
            crossAlignment: CrossAxisAlignment.start,
          ),
      
      ],
    );
  }

  Future<QuerySnapshot> getSubCategory() async {
    QuerySnapshot result = await FirebaseFirestore.instance
        .collection("SubSubCat")
        .where("parent", isEqualTo: widget.subCategory["id"]
        
        )
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
                       physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                                 
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
                                ).pOnly(bottom:5),
                                "${_querySnapshot.docs[index]["title"]}"
                                    .text
                                    .xl
                                    .center
                                    .semiBold
                                    .make()
                              ],
                            ).pOnly(left: 10),
                          );
                        },
                      )
                    : "No Data Found".text.make()
                : CircularProgressIndicator().centered())
        .make();
  }
}
