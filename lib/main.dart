import 'package:flutter/material.dart';
import 'package:interestchat/views/signup.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'helper/authenticate.dart';
import 'helper/helperfunctions.dart';
import 'views/chatr.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyDdXbpkmVesRjqhDNXc6CnvBH2ZZp4kuxg", // Your apiKey
      appId: "1:1019338914269:android:d76f9211a99de449925e34", // Your appId
      messagingSenderId: "1019338914269", // Your messagingSenderId
      projectId: "interestchat-574c7", // Your projectId
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.

  bool userIsLoggedIn;

  @override
  void initState() {
    getLoggedInState();
    super.initState();
  }

  getLoggedInState() async {
    await HelperFunctions.getUserLoggedInSharedPreference().then((value) {
      setState(() {
        userIsLoggedIn = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Application name
      title: 'Flutter Hello World',
      debugShowCheckedModeBanner: false,
      // Application theme data, you can set the colors for the application as
      // you want
      theme: ThemeData(
        primaryColor: Color(0xff145C9E),
        scaffoldBackgroundColor: Color(0xff1F1F1F),
        primarySwatch: Colors.blue,
      ),
      // A widget which will be started on application startup
      home: AnimatedSplashScreen(
        splashTransition: SplashTransition.scaleTransition,
        splashIconSize: 400,
        nextScreen: userIsLoggedIn != null
            ? userIsLoggedIn
                ? ChatRoom()
                : Authenticate()
            : Container(
                child: Center(
                  child: Authenticate(),
                ),
              ),
        splash: Image.asset("assets/images/start.png"),
      ),
    );
  }
}
