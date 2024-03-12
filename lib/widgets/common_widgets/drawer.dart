// drawer.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

int statusCode = 0;
class AppDrawer extends StatelessWidget {
  AppDrawer({Key? key}) : super(key: key);

  Future<void> logOut() async{
    print("logOut start");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String accessToken = prefs.getString('accessToken')!;
    final uri = Uri.parse('http://15.164.251.76:8091/api/auth/token');
    final headers = {'Authorization': '$accessToken'};

    try{
      final response = await http.delete(uri, headers: headers);
      statusCode = response.statusCode;
      print('statusCode : $statusCode');

      if(statusCode == 200) {
        print('logOut request succeed');
      }else{

      }

    }catch (e){
      print("error!!");
      print(e.runtimeType);
    }
  }

  Color textColor = Color.fromRGBO(94, 130, 87, 1.0); // Text Color

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: const BoxDecoration(color: Color.fromRGBO(243, 255, 235, 1.0)),
        child: ListView(
        children: [
          // UserAccountsDrawerHeader(
          //   // currentAccountPicture: const CircleAvatar(
          //   //   backgroundImage: AssetImage('assets/PNG/profile.png'),
          //   // ),
          //   // currentAccountPicture: const CircleAvatar(
          //   //   backgroundImage: AssetImage('assets/PNG/profile.png'),
          //   // ),
          //   // accountName: Text('사용자이름'),
          //   // accountEmail: Text('abc12356@naver.com'),
          //   accountName: const Text(''),
          //   accountEmail: const Text(''),
          //   onDetailsPressed: () {},
          //   decoration: const BoxDecoration(
          //     // color: Colors.purple[200],
          //     color: Color.fromRGBO(196, 232, 181, 0.9),
          //     borderRadius: BorderRadius.only(
          //       bottomLeft: Radius.circular(10.0),
          //       bottomRight: Radius.circular(10.0),
          //     ),
          //   ),
          // ),
          Container(
            padding: EdgeInsets.fromLTRB(30, 30, 0, 0),
            child:
            const Text('MEALK', style:
              TextStyle(fontFamily: 'NotoSansKR', fontSize: 30, fontWeight: FontWeight.w900, color: Color.fromRGBO(94, 130, 87, 1.0),),),
          ),
          const SizedBox(height: 100,),
          ListTile(
            leading: const Icon(Icons.photo),
            iconColor: textColor,
            focusColor: const Color.fromRGBO(196, 232, 181, 0.9),
            title: const Text('나의 밀웜 사진 갤러리', style: TextStyle(fontSize: 23, color: Color.fromRGBO(94, 130, 87, 1.0), fontWeight: FontWeight.w300),),
            onTap: () {
              Navigator.pushNamed(context, 'gallery');
            },
            trailing: const Icon(Icons.navigate_next),
          ),
          ListTile(
            leading: const Icon(Icons.monetization_on),
            iconColor: textColor,
            focusColor: const Color.fromRGBO(196, 232, 181, 0.9),
            title: const Text('포인트 확인하기', style: TextStyle(fontSize: 24, color: Color.fromRGBO(94, 130, 87, 1.0), fontWeight: FontWeight.w300),),
            onTap: () {
              Navigator.pushNamed(context, 'point');
            },
            trailing: const Icon(Icons.navigate_next),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            iconColor: textColor,
            focusColor: const Color.fromRGBO(196, 232, 181, 0.9),
            title: const Text('마이 페이지', style: TextStyle(fontSize: 24, color: Color.fromRGBO(94, 130, 87, 1.0), fontWeight: FontWeight.w300),),
            onTap: () {
              Navigator.pushNamed(context, 'mypage');
            },
            trailing: const Icon(Icons.navigate_next),
          ),
          const SizedBox(height: 300), // 버튼과 Drawer 하단 간의 간격
          ListTile(
            leading: const Icon(Icons.logout),
            iconColor: textColor,
            focusColor: const Color.fromRGBO(196, 232, 181, 0.9),
            title: const Text('로그 아웃', style: TextStyle(fontSize: 24, color: Color.fromRGBO(94, 130, 87, 1.0), fontWeight: FontWeight.w300),),
            onTap: () async {
              await logOut(); // logOut 함수 완료를 기다림

              // SnackBar 표시
              ScaffoldMessenger.of(context).showSnackBar(
                statusCode == 200
                    ? const SnackBar(
                  content: Text('로그아웃 성공'),
                  backgroundColor: Color.fromRGBO(196, 232, 181, 0.9),
                )
                    : const SnackBar(
                  content: Text('로그아웃 실패!'),
                  backgroundColor: Colors.red,
                ),
              );

              // 필요한 경우, 다음 화면으로 이동
              Navigator.pushNamedAndRemoveUntil(context, 'login', (_) => false);
            },
            // trailing: Icon(Icons.navigate_next),
          ),
          const SizedBox(height: 20), // 버튼과 Drawer 하단 사이의 여백
        ],
      ),
    ),
    );
  }
}
