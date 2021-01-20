import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:velocity_x/velocity_x.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:sms_autofill/sms_autofill.dart';

class phoneAuth extends StatefulWidget {
  @override
  _phoneAuthState createState() => _phoneAuthState();
}

class _phoneAuthState extends State<phoneAuth>  {
  bool val=false;
  bool loading=false;
  int tapped=0;
 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      body: codeSent(),
    );
  }
  final TextEditingController controller = TextEditingController();
  TextEditingController otp=TextEditingController();
  String initialCountry = 'IN';
  GlobalKey<ScaffoldState> _key=GlobalKey();


  String verifcationCode;
  String phonNumber;
   
  String signature = "{{ app signature }}";
  
  
  

@override
void initState() { 
  super.initState();
 
}
String appSignature;
autofill()async{


await SmsAutoFill().hint.then((value) {
  if(!value.isEmptyOrNull){
  print(value);
controller.text=value.replaceAll("+91", "");
verifyNumber("+91${controller.text}");
EasyLoading.show();
  }



});

}

GlobalKey<FormState> key=GlobalKey();
 Widget codeSent(){
   return SingleChildScrollView(
     child: SafeArea(
        child: SafeArea(
       child: Column(
         children: [
           Image.asset("assets/images/logo.png")
                      .box
                      .height(150)
                      .alignCenter
                      .make()
                      .pOnly(bottom: 40),
                  "We Welcome You !".text.xl2.bold.start.make().pOnly(left: 20),
                  "आम्ही आपले सहर्ष स्वागत करतो !"
                      .text
                      .xl2
                      .bold
                      .start
                      .make()
                      .pOnly(left: 20),
                      
          //  InternationalPhoneNumberInput(
          //       hintText: "Enter mobile Number/मोबाईल नंबर टाका",
              
                
          //           onInputChanged: (PhoneNumber number) {
          //             print(number.phoneNumber);
          //               phonNumber=number.phoneNumber;
          //           },
          //           onInputValidated: (bool value) {
          //             print(value);
          //           },
          //           selectorConfig: SelectorConfig(
          //             selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
          //           ),
          //           ignoreBlank: false,
          //           autoValidateMode: AutovalidateMode.always,
          //           selectorTextStyle: TextStyle(color: Colors.black),
          //           initialValue: number,
          //           textFieldController: controller,
          //           formatInput: false,
          //           keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
          //           inputBorder: OutlineInputBorder(),
          //           onSaved: (PhoneNumber number) {
          //             print('On Saved: $number');
          //           },
          //         ).p16().centered(),
          Row(
            children: [
              "🇮🇳+91".text.size(16).center.make().pOnly(right: 20),
              Form(
                key: key,
                child: TextFormField(
                  onTap: (){
                      if(tapped==0){
                          autofill();
                          tapped++;
                      }
                  },
                keyboardType: TextInputType.number,
                  controller: controller,
                 
                  onChanged: (value){
                    key.currentState.validate();

                    }
                  ,
                  style:TextStyle(
                      fontSize: 16
                    ),
                  decoration: InputDecoration(
                   
                    prefixStyle: TextStyle(
                      fontSize: 16
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30)
                    ),
                    hintText: "Enter mobile Number/मोबाईल नंबर टाका"
                  
                  ),
                  
                ).expand(),
              ),

            ],
            mainAxisAlignment: MainAxisAlignment.start,
          ).h10(context).p16(),
                 
        RaisedButton(
          color: Colors.blueAccent,
          child: "Register".text.xl2.white.bold.make(),
          shape: Vx.roundedLg,
          padding: EdgeInsets.symmetric(vertical:20,horizontal: 50),
          
          onPressed: (){
           FocusScope.of(context).unfocus();

          try{
          EasyLoading.show();
          verifyNumber("+91${controller.text}");
          }catch(e){
           EasyLoading.dismiss();
          }
          
          },
        ).centered(),
       
       
       val?
      phoneInput()
       :Container()
         
         ],
         mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start
        
       ),


      
     ).box.withDecoration(BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(30),
                        topLeft: Radius.circular(30))))
                .make(),
   )
   );
 }
 Widget phoneInput(){
   print(verifcationCode);
   return Column(
     children: [
       (context.percentHeight*10).heightBox,
     "Enter Your Otp".text.xl2.make(),

     PinFieldAutoFill(

              decoration: BoxLooseDecoration(strokeColorBuilder: FixedColorBuilder(Colors.black.withOpacity(0.3))),
      
              onCodeSubmitted:(code)async{
               signIn(code);
              },
              onCodeChanged:(code)async{
                if (code.length == 6) {
                signIn(code);
                }
              
              } //code changed callback
             
            ).p32(),
        "Check Your Inbox".text.xl.bold.make(),
        errortext==''?Container():errortext.text.red900.make()

    
  // OTPTextField(
  
  
  // length: 6,
  // width: context.percentWidth*80,
  // fieldWidth: 40,
  // style: TextStyle(
  //   fontSize: 17
  // ),
  // textFieldAlignment: MainAxisAlignment.spaceAround,
  // fieldStyle: FieldStyle.box,
  // onCompleted: (pin) {
    
  //  signIn(pin);
  // },

  // ).centered()


 
    ],
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
   );
 }

 


String errortext="";

signIn(String otp) async {
      FocusScope.of(context).unfocus();
       await Future.delayed(Duration(milliseconds:500)); 
      EasyLoading.show();

        try {    
            final AuthCredential credential = PhoneAuthProvider.credential(    
            verificationId: verifcationCode,    
            smsCode: otp,    
            );    
          await Future.delayed(Duration(milliseconds: 500)).then((value)async {
          var user = await FirebaseAuth.instance.signInWithCredential(credential);    
            final User currentUser =  FirebaseAuth.instance.currentUser;    
            EasyLoading.dismiss();
            
            if(user.user==currentUser)   {
                  val=false;
                  
                  
                      }            } );
          
              
                    
          


        } on FirebaseAuthException catch (e) {    
          EasyLoading.dismiss();
          print("${e.message}");
          setState(() {
            if(e.code=="invalid-verification-code"){
            errortext="Invalid Verification Code";
            }
          });    
        }    
    }   
verifyNumber(String phonNumber)async{
  try{
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phonNumber, 
    verificationCompleted: (AuthCredential cred)async{
      await FirebaseAuth.instance.signInWithCredential(cred);
    }, 
    verificationFailed: (FirebaseAuthException e){
      EasyLoading.dismiss();
       _key.currentState.showSnackBar(SnackBar(content: "${e.code}".text.make(),));
      print(e.code);
    }, 
    codeSent: (String _ ,int code)async{
      print("Code Sent");
        verifcationCode=_ ;
       
        await SmsAutoFill().listenForCode;
       
        setState(() {
          val=true;
        });
         EasyLoading.dismiss();
    }, 
    codeAutoRetrievalTimeout: (timeout){
      print(timeout);
    });

  }catch(e){
      EasyLoading.dismiss();

      _key.currentState.showSnackBar(SnackBar(content: "$e".text.make(),));
  }
}

@override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    SmsAutoFill().unregisterListener();
  }
 

}