import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onshop/screens/subCategory/subCategory.dart';
import 'package:onshop/widgets/appBar.dart';
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
      appBar: appBar(),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("Category").snapshots(),
        builder: (context, snapshot) {

          return snapshot.data != null?VxBox(
              child: VStack([
              "Category".text.textStyle(Theme.of(context).textTheme.headline4).make().pOnly(bottom: 20),

            VxBox(
                child: GridView.builder(
                  scrollDirection: Axis.vertical,
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3,mainAxisSpacing: 30),
                     itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: ()=>Navigator.of(context).push(CupertinoPageRoute(builder: (context)=>subCategory(category: snapshot.data.docs[index].id,))),
                  child: VStack(
                       [
                        Expanded(
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(snapshot.data.docs[index]["image"]),
                            radius: 50,
                          ),
                        ),
                         "${snapshot.data.docs[index]["title"]}".text.xl2.make()
                       ],
                    alignment: MainAxisAlignment.center,
                    crossAlignment: CrossAxisAlignment.center,
                  ),
                );
              },
	          itemCount:snapshot.data.docs.length,
            )).size(context.screenWidth, context.percentHeight*60).make(),
          ])).make().pOnly(left: 20, top: 30):CircularProgressIndicator().centered();
        }
      ),
      drawer: Drawer(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: (){}, label: "Buy".text.xl.make().pSymmetric(h: 20),


      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
