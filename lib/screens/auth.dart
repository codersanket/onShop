import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:velocity_x/velocity_x.dart';
class auth extends StatefulWidget {
  @override
  _authState createState() => _authState();
}

class _authState extends State<auth> {
	GlobalKey<FormState> _key=GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
	    body: Form(
		    key: _key,
	      child: Column(
	        children: [
	          Center(
		    child: IntlPhoneField(

			    validator: (value){
			    	if(value.length==10){
			    		return "Enter Valid Number";
				    }
			    	return null;
			    },
			    decoration: InputDecoration(
				    labelText: 'Phone Number',
				    border: OutlineInputBorder(
					    borderSide: BorderSide(),
				    ),
			    ),
			    initialCountryCode: 'IN',
			    onChanged: (phone) {
						_key.currentState.validate();
				    print(phone.completeNumber);
			    },
		    ).p16(),
	          ),
		      MaterialButton(
			      onPressed: (){
			      	_key.currentState.validate();
			      },
			      color: Colors.red,
			      child: Text("Hello"),
		      )
	        ],
	      ),
	    ),
    );
  }
}
