import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:interestchat/wid/widg.dart';
import 'package:interestchat/service/auth.dart';
import 'package:interestchat/service/database.dart';
import 'package:interestchat/views/chatr.dart';
import 'package:interestchat/helper/constants.dart';
import 'package:interestchat/helper/helperfunctions.dart';

import 'forgetpass.dart';

class Signin extends StatefulWidget {
  final Function toggleView;

  Signin(this.toggleView);

  @override
  _SigninState createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  TextEditingController emailTextEdit = new TextEditingController();
  TextEditingController passwordTextEdit = new TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isloading = false;

  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  signIn() async {
    if (formKey.currentState.validate()) {
      setState(() {
        isloading = true;
      });
      HelperFunctions.saveUserEmailSharedPreference(emailTextEdit.text);

      await authMethods.signInWithEmailAndPassword(emailTextEdit.text, passwordTextEdit.text).then((val) async {
        if (val != null) {
          QuerySnapshot userInfoSnapshot = await DatabaseMethods().getUserInfo(emailTextEdit.text);

          HelperFunctions.saveUserLoggedInSharedPreference(true);
          HelperFunctions.saveUserNameSharedPreference(userInfoSnapshot.docs[0].get("name"));
          HelperFunctions.saveUserEmailSharedPreference(userInfoSnapshot.docs[0].get("email"));

          //print("$val");
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ChatRoom()));
        } else {
          setState(() {
            isloading = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBarMAin(context),
        body: isloading
            ? Container(
                child: Center(child: CircularProgressIndicator()),
              )
            : SingleChildScrollView(
                child: Container(
                  height: MediaQuery.of(context).size.height - 50,
                  alignment: Alignment.center,
                  child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Form(
                            key: formKey,
                            child: Column(
                              children: [
                                TextFormField(
                                    validator: (val) {
                                      return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val) ? null : "Enter correct email";
                                    },
                                    controller: emailTextEdit,
                                    style: texts(Colors.white),
                                    decoration: textfieldDecor("Email")),
                                TextFormField(
                                    obscureText: true,
                                    validator: (val) {
                                      return val.length < 6 ? "Enter Password 6+ characters" : null;
                                    },
                                    controller: passwordTextEdit,
                                    style: texts(Colors.white),
                                    decoration: textfieldDecor("Password")),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ForgotPassword()));
                            },
                            child: Container(
                              alignment: Alignment.centerRight,
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                                child: Text(
                                  "Forgot Password?",
                                  style: texts(Colors.white),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          GestureDetector(
                            onTap: () {
                              signIn();
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.symmetric(vertical: 20),
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(colors: [
                                    const Color(0xff0079FA),
                                    const Color(0xff2A75BC)
                                  ]),
                                  borderRadius: BorderRadius.circular(30)),
                              child: Text(
                                "Sign In",
                                style: textb(),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("New to InterestChat?  ", style: textb()),
                              GestureDetector(
                                onTap: () {
                                  widget.toggleView();
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 17),
                                  child: Text("Register here!",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        decoration: TextDecoration.underline,
                                      )),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 60,
                          ),
                        ],
                      )),
                ),
              ));
  }
}
