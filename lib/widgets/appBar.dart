

import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class appBar extends StatelessWidget with PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return  AppBar(
	    title: "OnShop".text.make(),
	    elevation: 6,
	    actions: [
		    CircleAvatar(
			    backgroundColor: Vx.red500,
		    ).pOnly(right: 10)
	    ],
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize =>Size(double.infinity,55);
}
