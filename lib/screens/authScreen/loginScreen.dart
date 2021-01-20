import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onshop/services/UserController.dart';
import 'package:onshop/services/authservices.dart';
import 'package:onshop/widgets/appBar.dart';
import 'package:onshop/widgets/textField.dart';
import 'package:velocity_x/velocity_x.dart';

class loginScreen extends StatefulWidget {
  @override
  _loginScreenState createState() => _loginScreenState();
}

class _loginScreenState extends State<loginScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _globalKey = GlobalKey();
  AuthServices auth = AuthServices();
  bool isLogin = true;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Form(
            key: _globalKey,
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
                textField(
                  hint: "Email-ईमेल टाईप करा",
                  textEditingController: _emailController,
                ).p8(),
                textField(
                  hint: "Password-पासवर्ड टाईप करा",
                  textEditingController: _passwordController,
                  validator: (value){
                    if(value.legth!=10){
                      return "Valid Number";
                    }
                  },
                  onValueChanged: (value) {
                    
                  },
                  isPassword: true,
                ).p8(),
                AnimatedContainer(
                  height: context.percentHeight * 8,
                  width: isLogin
                      ? context.percentWidth * 40
                      : context.percentWidth * 40,
                  duration: Duration(milliseconds: 200),
                  child: MaterialButton(
                    child: isLogin
                        ? isLoading
                            ? "Loading....".text.make()
                            : "Login".text.xl2.white.make()
                        : isLoading
                            ? "Loading....".text.make()
                            : "SignUp".text.xl2.white.make(),
                    color: Colors.blue,
                    onPressed: isLoading
                        ? null
                        : () async {
                            try {
                              setState(() {
                                isLoading = true;
                              });
                              UserCredential user = isLogin
                                  ? await auth.login(_emailController.text,
                                      _passwordController.text)
                                  : await auth.signUp(_emailController.text,
                                      _passwordController.text);
                              print(user);
                            } on FirebaseAuthException catch (e) {
                              setState(() {
                                isLoading = false;
                              });
                              VxToast.show(context, msg: e.message);
                            }
                          },
                    shape: Vx.roundedLg,
                  ),
                ).centered(),
                (100).heightBox,
                Column(
                  children: [
                    isLogin
                        ? "Don't have account create one "
                            .text
                            .black
                            .size(16)
                            .make()
                        : Container(),
                    isLogin
                        ? "नवीन अकाउंट बनवण्यासाठी इथे क्लिक करा "
                            .text
                            .black
                            .size(16)
                            .make()
                            .pOnly(top: 10)
                        : Container(),
                    RaisedButton(
                      shape: Vx.rounded,
                      color: Colors.blueAccent,
                      onPressed: () {
                        setState(() {
                          isLogin = !isLogin;
                        });
                      },
                      child: isLogin
                          ? "Sign up here".text.white.size(16).make()
                          : "Log In".text.white.size(16).make(),
                    ).centered(),
                  ],
                  mainAxisAlignment: MainAxisAlignment.center,
                )
              ],
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
            ),
          )
              .box
              .withDecoration(BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(30),
                      topLeft: Radius.circular(30))))
              .make(),
        ),
      ),
    );
  }
}
