import 'package:flutter/material.dart';
import 'package:eco_mealworm_farm/utils/login_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginWidget extends StatefulWidget {
  @override
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {

  final String font = 'NotoSansKR';

  void roleCheck() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? role = prefs.getString('role');

    if(role == "USER"){
      Navigator.pushNamed(context, 'userMain');
    }
    if(role == "ADMIN"){
      Navigator.pushNamed(context, 'adminMain');
    }
  }

  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw '링크 열기 실패! $url';
    }
  }

  final TextEditingController idController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final LoginController loginController = LoginController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      // padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: double.infinity,
            height: 112.0,
          ),
          Text(
            '밀웜으로 재테크하는 시대',
            style: TextStyle(fontSize: 20,fontFamily: font, fontWeight: FontWeight.w900, color: Color.fromRGBO(94, 130, 87, 1.0)),
          ),
          Text(
            'MEALK',
            style: TextStyle(fontSize: 72,fontFamily: font, fontWeight: FontWeight.w900, color: Color.fromRGBO(94, 130, 87, 1.0)),
          ),
          SizedBox(height: 32.0,),
          Container(
            width: 280,
            child: TextField(
              controller: idController,
              decoration: const InputDecoration(
                hintText: '아이디를 입력해 주세요',
                hintStyle: TextStyle(color: Colors.grey),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color.fromRGBO(94, 130, 87, 1.0),), // 일반 상태에서의 밑줄 색상
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color.fromRGBO(196, 232, 181, 0.9),), // 포커스 상태에서의 밑줄 색상
                ),
              ),

            ),
          ),
          const SizedBox(height: 16.0),
          Container(
            width: 280,
            child: TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                hintText: '비밀번호를 입력해 주세요',
                hintStyle: TextStyle(color: Colors.grey),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color.fromRGBO(94, 130, 87, 1.0),), // 일반 상태에서의 밑줄 색상
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color.fromRGBO(196, 232, 181, 0.9),), // 포커스 상태에서의 밑줄 색상
                ),
              ),
            ),
          ),
          const SizedBox(height: 24.0),
          Container(
            width: 160.0,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: const Color.fromRGBO(94, 130, 87, 1.0), // 버튼의 배경색
                onPrimary: Colors.white, // 버튼의 텍스트 및 아이콘 색상
                textStyle: TextStyle(
                  fontSize: 16,
                  fontFamily: font,
                  fontWeight: FontWeight.w900,
                ),
              ),
              onPressed: () {
                loginController.login(
                  idController.text,
                  passwordController.text,
                  onSuccess: (){
                    // 로그인 성공 시 처리
                    loginController.getUserInfo();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('로그인 성공',
                            style: TextStyle(color: Color.fromRGBO(94, 130, 87, 1.0), fontSize: 20, fontFamily: 'NotoSansKR', fontWeight: FontWeight.w900),
                            textAlign: TextAlign.center
                        ),
                        // backgroundColor: Color.fromRGBO(223, 255, 215, 1),
                        backgroundColor: Color.fromRGBO(196, 232, 181, 0.9),
                      ),
                    );
                    // Navigator.pushNamed(context, 'userMain');
                    roleCheck();
                  },
                  onError: (error) {
                    // 로그인 실패 시 처리
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('로그인 실패: $error', style: const TextStyle(color: Colors.white, fontSize: 20), textAlign: TextAlign.center),
                        // backgroundColor: const Color.fromRGBO(223, 255, 215, 1),
                        backgroundColor: Colors.redAccent,
                      ),
                    );
                  },
                );
              },
              child: const Text('로그인'),
            ),
          ),
          SizedBox(height: 120.0,),
          Container(
            width: 160.0,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: const Color.fromRGBO(94, 130, 87, 1.0), // 버튼의 배경색
                onPrimary: Colors.white, // 버튼의 텍스트 및 아이콘 색상
                textStyle: TextStyle(
                  fontSize: 16,
                  fontFamily: font,
                  fontWeight: FontWeight.w900,
                ),
              ),
              onPressed: () {
                Navigator.pushNamed(context, 'terms');
              },
              child: const Text('회원가입하기'),
            ),
          ),
          SizedBox(height: 16,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                child:
                  Text(
                    '  아이디 찾기  ',
                    style: TextStyle(fontSize: 20,fontFamily: font, fontWeight: FontWeight.w900, color: Color.fromRGBO(94, 130, 87, 1.0)),
                  ),
                onPressed: (){
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        // backgroundColor: Color.fromRGBO(196, 232, 181, 1.0 ),
                          content: Container(
                            height: 200,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '죄송합니다. \n현재 서비스 점검중 입니다. \n 카카오톡 문의 부탁드립니다.',
                                    style: TextStyle(fontSize: 22,fontFamily: font, fontWeight: FontWeight.w900, color: Color.fromRGBO(94, 130, 87, 1.0)),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 24,),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: const Color.fromRGBO(94, 130, 87, 1.0), // 버튼의 배경색
                                      onPrimary: Colors.white, // 버튼의 텍스트 및 아이콘 색상
                                      textStyle: TextStyle(
                                          fontSize: 16,
                                          fontFamily: font,
                                          fontWeight: FontWeight.w900),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                      ),
                                    ),
                                    onPressed: (){
                                      _launchUrl('http://pf.kakao.com/_RwarG');
                                    },
                                    child: Text(
                                      '카카오톡으로 문의 하기',
                                      style: TextStyle(fontSize: 18,fontFamily: font, fontWeight: FontWeight.w900, color: Colors.white),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  // TextButton(
                                  //   onPressed: (){
                                  //
                                  //   },

                                  // ),
                                ]
                            ),
                          )
                      );
                    },
                  );
                },
              ),
              SizedBox(width: 16,),
              Container(
                height: 16.0,
                width: 1.0,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(94, 130, 87, 1.0),
                ),

              ),
              SizedBox(width: 16,),
              TextButton(
                child:
                Text(
                  ' 비밀번호 찾기',
                  style: TextStyle(fontSize: 20,fontFamily: font, fontWeight: FontWeight.w900, color: Color.fromRGBO(94, 130, 87, 1.0)),
                ),
                onPressed: (){
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        // backgroundColor: Color.fromRGBO(196, 232, 181, 1.0 ),
                          content: Container(
                            height: 200,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '죄송합니다. \n현재 서비스 점검중 입니다. \n 카카오톡 문의 부탁드립니다.',
                                    style: TextStyle(fontSize: 22,fontFamily: font, fontWeight: FontWeight.w900, color: Color.fromRGBO(94, 130, 87, 1.0)),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 24,),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: const Color.fromRGBO(94, 130, 87, 1.0), // 버튼의 배경색
                                      onPrimary: Colors.white, // 버튼의 텍스트 및 아이콘 색상
                                      textStyle: TextStyle(
                                          fontSize: 16,
                                          fontFamily: font,
                                          fontWeight: FontWeight.w900),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                      ),
                                    ),
                                    onPressed: (){
                                      _launchUrl('http://pf.kakao.com/_RwarG');
                                    },
                                    child: Text(
                                      '카카오톡으로 문의 하기',
                                      style: TextStyle(fontSize: 18,fontFamily: font, fontWeight: FontWeight.w900, color: Colors.white),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  // TextButton(
                                  //   onPressed: (){
                                  //
                                  //   },

                                  // ),
                                ]
                            ),
                          )
                      );
                    },
                  );
                },
              ),
            ],
          ),

        ],
      ),
    );
  }
}
