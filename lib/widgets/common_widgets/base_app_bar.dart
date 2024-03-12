// base_app_bar.dart
import 'package:eco_mealworm_farm/screens/user_screens/user_main_screen.dart';
import 'package:flutter/material.dart';

class BaseAppBar extends StatelessWidget implements PreferredSizeWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey;

  BaseAppBar({Key? key, required GlobalKey<ScaffoldState> scaffoldKey})
      : _scaffoldKey = scaffoldKey,
        super(key: key);
  // const BaseAppBar({Key? key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return
      AppBar(
      title: InkWell(
        onTap: () {
          Navigator.pushNamedAndRemoveUntil(context, 'userMain', (_) => false);
        },
        // child: Image.asset(
        //   'assets/PNG/logo.png',
        //   height: 30,
        // ),
        child: const Text('MEALK', style: 
          TextStyle(fontFamily: 'NotoSansKR', fontSize: 30, fontWeight: FontWeight.w900, color: Color.fromRGBO(94, 130, 87, 1.0),),),
      ),
      centerTitle: true,
      backgroundColor: Color.fromRGBO(196, 232, 181, 0.9),
      leading: Builder(
        builder: (context) => IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            // Scaffold.of(context).openDrawer();
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
