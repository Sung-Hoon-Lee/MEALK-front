import 'package:eco_mealworm_farm/screens/user_screens/user_main_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AdminAppBar extends StatelessWidget implements PreferredSizeWidget {
  final GlobalKey<ScaffoldState> _adminScaffoldKey;

  AdminAppBar({Key? key, required GlobalKey<ScaffoldState> scaffoldKey})
      : _adminScaffoldKey = scaffoldKey,
        super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  int statusCode = 0;

  // Future<void> logOut() async{
  //   print("logOut start");
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String accessToken = prefs.getString('accessToken')!;
  //   final uri = Uri.parse('http://15.164.251.76:8091/api/auth/token');
  //   final headers = {'Authorization': '$accessToken'};
  //
  //   try{
  //     final response = await http.delete(uri, headers: headers);
  //     statusCode = response.statusCode;
  //     print('statusCode : $statusCode');
  //
  //     if(statusCode == 200) {
  //       print('logOut request succeed');
  //     }else{
  //
  //     }
  //
  //   }catch (e){
  //     print("error!!");
  //     print(e.runtimeType);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return
      AppBar(
        title: InkWell(
          onTap: () {
            Navigator.pushNamedAndRemoveUntil(context, 'adminMain', (_) => false);
          },
          // child: Image.asset(
          //   'assets/PNG/logo.png',
          //   height: 30,
          // ),
          child: const Text('MEALK', style:
          TextStyle(fontFamily: 'NotoSansKR', fontSize: 30, fontWeight: FontWeight.w900, color: Color.fromRGBO(94, 130, 87, 1.0),),),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(196, 232, 181, 0.9),
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              // await logOut();

              // ScaffoldMessenger.of(context).showSnackBar(
              //   statusCode == 200
              //       ? const SnackBar(
              //     content: Text('로그아웃 성공'),
              //     backgroundColor: Color.fromRGBO(196, 232, 181, 0.9),
              //   )
              //       : const SnackBar(
              //     content: Text('로그아웃 실패!'),
              //     backgroundColor: Colors.red,
              //   ),
              // );
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('로그아웃 성공'),
                    backgroundColor: Color.fromRGBO(196, 232, 181, 0.9),
                ),
              );
              Navigator.pushNamedAndRemoveUntil(context, 'login', (_) => false);
            },
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      );
  }
}
