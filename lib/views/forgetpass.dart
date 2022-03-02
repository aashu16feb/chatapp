import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:interestchat/wid/widg.dart';
import 'package:interestchat/service/auth.dart';
import 'package:interestchat/helper/authenticate.dart';

import 'signin.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  bool isloading = false;
  TextEditingController emailTextEdit = new TextEditingController();
  final formKey = GlobalKey<FormState>();

  AuthMethods authMethods = new AuthMethods();

  resetP() {
    authMethods.resetPass(emailTextEdit.text);
    emailTextEdit.text = "";
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Authenticate()));
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
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          GestureDetector(
                            onTap: () {
                              resetP();
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
                                "Send Password Reset link",
                                style: textb(),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 16,
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
