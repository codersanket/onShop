import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:onshop/widgets/appBar.dart';
import 'package:velocity_x/velocity_x.dart';
class subCategory extends StatefulWidget {
	final String category;
	subCategory({this.category});
  @override
  _subCategoryState createState() => _subCategoryState();
}

class _subCategoryState extends State<subCategory> {

	GlobalKey _key=GlobalKey();
  @override
  Widget build(BuildContext context) {

  	print(widget.category);
    return Scaffold(
	    key: _key,
	    appBar: appBar(),
	    body: VxBox(
	      child: StreamBuilder<QuerySnapshot>(
	        stream: FirebaseFirestore.instance.collection("Category").doc(widget.category).collection("Subcategory").snapshots(),
	        builder: (context, snapshot) {
	          return snapshot!=null?CustomScrollView(
		    slivers: [
		    	SliverList(delegate: SliverChildListDelegate(
				    [
					"Subcategory".text.textStyle(Theme.of(context).textTheme.headline4).make().pOnly(top: 20,left: 20),
				    ]
			    ),),

			    SliverGrid(
				    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(

				    crossAxisCount: 3
				    ),
				    delegate: SliverChildBuilderDelegate(
							    (BuildContext context, int index) {
						    return GestureDetector(
							    onTap: ()=>{},
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
					    childCount: snapshot.data.docs.length,
				    ),
			    )
		    ],
	          ):CircularProgressIndicator();
	        }
	      ),
	    ).make()
    );
  }

  Widget text (context){
  	return Text("Catgory");
  }
}
