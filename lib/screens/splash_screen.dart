import 'dart:async';

import 'package:eco_mealworm_farm/screens/login_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 1), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => LoginScreen()));
    });
  }

  Color mainColor = const Color.fromRGBO(94, 130, 87, 1.0);
  TextStyle splashTitleFontStyle = const TextStyle(fontSize: 84, fontFamily: 'NotoSansKR', fontWeight: FontWeight.w900, color: Colors.white);
  TextStyle splashStringFontStyle = const TextStyle(fontSize: 24, fontFamily: 'NotoSansKR', fontWeight: FontWeight.w900, color: Colors.white);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: mainColor,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children:[
              Text('밀웜으로 재테크 하는 시대', style: splashStringFontStyle,),
              SizedBox(height: 8,),
              Text('MEALK', style: splashTitleFontStyle),
            ]
          )
        ),
      ),
    );
  }
}