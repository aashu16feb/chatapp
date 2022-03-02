import 'package:flutter/material.dart';
import 'package:interestchat/wid/widg.dart';
import 'package:interestchat/service/auth.dart';
import 'package:interestchat/service/database.dart';
import 'package:interestchat/views/chatr.dart';
import 'package:interestchat/helper/constants.dart';
import 'package:interestchat/helper/helperfunctions.dart';

class Signup extends StatefulWidget {
  final Function toggleView;

  Signup(this.toggleView);

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  bool isloading = false;

  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  final formKey = GlobalKey<FormState>();
  TextEditingController unameTextEdit = new TextEditingController();
  TextEditingController emailTextEdit = new TextEditingController();
  TextEditingController passwordTextEdit = new TextEditingController();
  String valueChoose;
  List listitem = [
    'Cricket',
    'Football',
    'Badminton',
    'Tennis'
  ];
  registerme() {
    if (formKey.currentState.validate()) {
      setState(() {
        isloading = true;
      });
      authMethods.signUpWithEmailAndPassword(emailTextEdit.text, passwordTextEdit.text).then((val) {
        //print("$val");
        Map<String, String> userInfoMap = {
          "name": unameTextEdit.text,
          "email": emailTextEdit.text,
          "interest": valueChoose.toString()
        };
        HelperFunctions.saveUserEmailSharedPreference(emailTextEdit.text);
        HelperFunctions.saveUserNameSharedPreference(unameTextEdit.text);

        databaseMethods.addUserInfo(userInfoMap);
        HelperFunctions.saveUserLoggedInSharedPreference(true);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ChatRoom()));
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
                          child: Column(children: [
                            TextFormField(
                                validator: (val) {
                                  return val.isEmpty || val.length < 4 ? "Please provide username" : null;
                                },
                                controller: unameTextEdit,
                                style: texts(Colors.white),
                                decoration: textfieldDecor("Username")),
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
                            Container(
                              color: Colors.blueGrey[400],
                              child: DropdownButtonFormField(
                                hint: Text("Select any interest"),
                                dropdownColor: Colors.black54,
                                icon: Icon(Icons.arrow_drop_down),
                                iconSize: 36,
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                                isExpanded: true,
                                value: valueChoose,
                                onChanged: (newValue) {
                                  setState(() {
                                    valueChoose = newValue;
                                  });
                                },
                                items: listitem.map((valueitem) {
                                  return DropdownMenuItem(
                                    value: valueitem,
                                    child: Text(valueitem),
                                  );
                                }).toList(),
                              ),
                            ),
                          ]),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            registerme();
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
                              "Sign Up",
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
                            Text("Already have an account?  ", style: textb()),
                            GestureDetector(
                              onTap: () {
                                widget.toggleView();
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 17),
                                child: Text("Login here!",
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
            ),
    );
  }
}
