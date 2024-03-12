import 'package:flutter/material.dart';
import 'package:eco_mealworm_farm/widgets/auth_widgets/login_widget.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   centerTitle: true,
      //   title: const Text('에코에코 밀웜팜'),
      // ),
      body: LoginWidget(),
    );
  }
}