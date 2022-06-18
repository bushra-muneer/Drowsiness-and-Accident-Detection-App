import 'package:driverassistant/Login_Screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'CameraPreview.dart';

import 'package:splashscreen/splashscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MaterialApp(
      home: MyApp(),
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
      ),
      debugShowCheckedModeBanner: false,
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
        seconds: 10,
        navigateAfterSeconds: new  LoginScreen(),
        title: new Text('AcciPrev',
          style: new TextStyle(
            color: Colors.deepOrange,
              fontWeight: FontWeight.bold,
              fontSize: 34.0
          ),),
        image: new Image.asset('assets/animated_logo.gif'),
        backgroundColor: Colors.white,
        styleTextUnderTheLoader: new TextStyle(),
        photoSize: MediaQuery.of(context).size.width * 0.67,
        onClick: ()=>print("AcciPrev Launched"),

        loaderColor: Colors.white
    );
  }
}
