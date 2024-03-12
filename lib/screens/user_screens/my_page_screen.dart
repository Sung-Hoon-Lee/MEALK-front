
import 'dart:convert';

import 'package:eco_mealworm_farm/screens/user_screens/rewrite_mypage_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../widgets/common_widgets/base_app_bar.dart';
import '../../widgets/common_widgets/drawer.dart';
class MyPageScreen extends StatefulWidget {
  const MyPageScreen({super.key});

  @override
  State<MyPageScreen> createState() => _MyPageScreenState();
}

class _MyPageScreenState extends State<MyPageScreen> {
  String? id;
  String? name;
  String? birth;
  String? gender;
  String? phoneNumber;
  String? address;
  int? point;

  int statusCode = 0;
  String accessToken = "";

  String responseData = "";
  Map responseMap = Map<String, dynamic>();

  void getUserData() async{
    print("getUserData start");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String id = prefs.getString('id')!;
    String accessToken = prefs.getString('accessToken')!;
    final uri = Uri.parse('http://15.164.251.76:8091/api/users/$id');
    final headers = {'Authorization': '$accessToken'};

    try{
      final response = await http.get(uri, headers: headers);
      statusCode = response.statusCode;
      print('statusCode : $statusCode');

      if(statusCode == 200){
        print('getUserData request succeed');
        String responseBody = utf8.decode(response.bodyBytes);
        print('getUserData decode : $responseBody');

        responseData = responseBody;
        responseMap = json.decode(responseData);

        setState(() {
          name = responseMap["name"];
          phoneNumber = responseMap["phoneNumber"];
          birth = responseMap["birth"];
          gender = responseMap["gender"];
          address = responseMap["address"];
          point = responseMap["point"];

          if(gender == 'MALE'){
              gender = '남성';
          }else {
              gender = '여성';
          }
        });
      }
    }catch(e){
      print("error!!");
      print(e.runtimeType);
    }
  }

  void deleteUser() async{
    print("deleteUser start");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String id = prefs.getString('id')!;
    String accessToken = prefs.getString('accessToken')!;
    final uri = Uri.parse('http://15.164.251.76:8091/api/users/$id');
    final headers = {'Authorization': '$accessToken'};

    try{
      final response = await http.delete(uri, headers: headers);
      statusCode = response.statusCode;
      print('statusCode : $statusCode');

      if(statusCode == 200){
        print('deleteUser request succeed');
        String responseBody = utf8.decode(response.bodyBytes);
        print('deleteUser decode : $responseBody');
      }else{
        print('request : $uri, $headers');
        print('deleteUser Error : ${response.body}');
      }
    }catch(e){
      print("error!!");
      print(e.runtimeType);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getUserInfo();
    // setUserInfo();
    getUserData();
  }

  Color mainColor = Color.fromRGBO(94, 130, 87, 1.0);
  String fontFamily = 'NotoSansKR';
  TextStyle dataFontStyle = TextStyle(fontSize: 20, fontFamily: 'NotoSansKR', fontWeight: FontWeight.w900, color: Color.fromRGBO(94, 130, 87, 1.0));
  TextStyle titleFontStyle = TextStyle(fontSize: 28, fontFamily: 'NotoSansKR', fontWeight: FontWeight.w900, color: Color.fromRGBO(94, 130, 87, 1.0));

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: _scaffoldKey,
      appBar: BaseAppBar(scaffoldKey: _scaffoldKey),
      // appBar: BaseAppBar(),
      drawer: AppDrawer(),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 다른 내용을 추가하거나 수정할 수 있습니다.
              const SizedBox(height: 48.0),
              Text('$name님 환영합니다.', style: TextStyle(fontSize: 28, fontFamily: 'NotoSansKR', fontWeight: FontWeight.w900, color: mainColor)),
              const SizedBox(height: 48.0),
              // Text('회원님의 포인트는 $point점 입니다.', style: TextStyle(fontSize: 20)),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: 24,),
                  Text('[ 나의 정보 ]', style: TextStyle(fontSize: 20, fontFamily: 'NotoSansKR', fontWeight: FontWeight.w900, color: mainColor),),
                ]
              ),
              SizedBox(height: 8,),
              Container(
                width: 350,
                height: 360,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 2,
                    color: mainColor,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(5),),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 32,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: 130,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SizedBox(width: 32,),
                              Text('전화번호  :  ', style: dataFontStyle,),
                            ],
                          ),
                        ),
                        Container(
                          width: 180,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text('$phoneNumber', style: dataFontStyle),
                            ],
                          ),
                        ),
                        Text(''),
                      ],
                    ),
                    SizedBox(height: 16,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: 130,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SizedBox(width: 32,),
                              Text('주소  :  ', style: dataFontStyle,),
                            ],
                          ),
                        ),
                        Container(
                          width: 180,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                width:180,
                                child:
                                  Text('$address', style: dataFontStyle, maxLines: 3, softWrap: true, overflow: TextOverflow.clip,),
                              ),
                            ],
                          ),
                        ),
                        Text(''),
                      ],
                    ),
                    SizedBox(height: 16,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: 130,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SizedBox(width: 32,),
                              Text('생년월일  :  ', style: dataFontStyle,),
                            ],
                          ),
                        ),
                        Container(
                          width: 180,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text('$birth', style: dataFontStyle),
                            ],
                          ),
                        ),
                        Text(''),
                      ],
                    ),
                    SizedBox(height: 16,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: 130,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SizedBox(width: 32,),
                              Text('성별  :  ', style: dataFontStyle,),
                            ],
                          ),
                        ),
                        Container(
                          width: 180,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text('$gender', style: dataFontStyle),
                            ],
                          ),
                        ),
                        Text(''),
                      ],
                    ),
                    SizedBox(height: 48,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 112,
                          height: 40,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: mainColor, // 테두리 색상
                              width: 1.5, // 테두리 두께
                            ),
                            borderRadius: BorderRadius.circular(10.0), // 테두리 둥근 모서리
                          ),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            onPressed: () async{
                              // await Navigator.pushNamed(context,'rMypage');
                              await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const RewriteMypageScreen()),
                              );
                              setState(() {
                                getUserData();
                              });
                            },
                            child: Text('수정하기', style: dataFontStyle,),
                          ),
                        ),
                        SizedBox(width: 12,),
                        Container(
                          width: 112,
                          height: 40,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: mainColor, // 테두리 색상
                              width: 1.5, // 테두리 두께
                            ),
                            borderRadius: BorderRadius.circular(10.0), // 테두리 둥근 모서리
                          ),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            onPressed: (){
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    // backgroundColor: Color.fromRGBO(196, 232, 181, 1.0 ),
                                      content: Container(
                                        height: 280,
                                        child: Column(
                                            children: [
                                              Container(
                                                width: 160,
                                                height: 80,
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: mainColor, // 테두리 색상
                                                    width: 1.5, // 테두리 두께
                                                  ),
                                                  borderRadius: BorderRadius.circular(10.0), // 테두리 둥근 모서리
                                                ),
                                                child: Text('회원탈퇴', style: titleFontStyle,),
                                              ),
                                              SizedBox(height: 20,),
                                              Text('지금 탈퇴하시면', style: dataFontStyle),
                                              Text('$point 포인트가 소멸됩니다', style: dataFontStyle,),
                                              SizedBox(height: 20,),
                                              Text('정말 탈퇴 하시겠습니까?', style: dataFontStyle,),
                                              SizedBox(height: 20,),
                                              Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      width: 104,
                                                      height: 48,
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                          color: mainColor, // 테두리 색상
                                                          width: 1.5, // 테두리 두께
                                                        ),
                                                        borderRadius: BorderRadius.circular(10.0), // 테두리 둥근 모서리
                                                      ),
                                                      child: ElevatedButton(
                                                        style: ElevatedButton.styleFrom(
                                                          primary: Colors.white,
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(10.0),
                                                          ),
                                                        ),
                                                        onPressed: () {
                                                          deleteUser();
                                                          Navigator.pushNamedAndRemoveUntil(context, 'login', (_) => false);
                                                        },
                                                        child: Text('회원탈퇴', style: dataFontStyle,),
                                                      ),

                                                    ),
                                                    SizedBox(width: 12,),
                                                    Container(
                                                      width: 104,
                                                      height: 48,
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                          color: mainColor, // 테두리 색상
                                                          width: 1.5, // 테두리 두께
                                                        ),
                                                        borderRadius: BorderRadius.circular(10.0), // 테두리 둥근 모서리
                                                      ),
                                                      child: ElevatedButton(
                                                        style: ElevatedButton.styleFrom(
                                                          primary: Colors.white,
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(10.0),
                                                          ),
                                                        ),
                                                        onPressed: () {
                                                          Navigator.pop(context);
                                                        },
                                                        child: Text('돌아가기', style: dataFontStyle,),
                                                      ),

                                                    ),
                                                  ]
                                              ),
                                          ]
                                        ),
                                      )
                                  );
                                },
                              );
                            },
                            child: Text('탈퇴하기', style: dataFontStyle,),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
