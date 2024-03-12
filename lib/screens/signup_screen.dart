import 'package:flutter/material.dart';
import 'package:eco_mealworm_farm/widgets/auth_widgets/signup_widget.dart';

class SignUpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('회원가입', style: TextStyle(fontFamily: 'NotoSansKR', fontWeight: FontWeight.w900, fontSize: 24),),
        centerTitle: true,
        backgroundColor: Color.fromRGBO(94, 130, 87, 1.0),
      ),
      body: SignUpWidget(),
    );
  }
}
