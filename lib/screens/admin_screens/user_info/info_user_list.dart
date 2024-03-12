import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../widgets/admin_widgets/admin_app_bar.dart';

class InfoUserList extends StatefulWidget {
  const InfoUserList({super.key});

  @override
  State<InfoUserList> createState() => _InfoUserListState();
}

class _InfoUserListState extends State<InfoUserList> {
  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocus = FocusNode();
  Color mainColor = const Color.fromRGBO(94, 130, 87, 1.0);

  // getUserList
  int statusCode = 0;
  // response decode를 위한 준비물
  String responseData = "";
  Map responseMap = Map<String, dynamic>();
  //response에서 id와 name 뽑아오기 준비
  var nameset = [];
  var idset = [];

  void getUserList() async{
    print("getUserList start");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String accessToken = prefs.getString('accessToken')!;
    final uri = Uri.parse('http://15.164.251.76:8091/admin/api/users?'
        'page=0&size=1000&sort=string&id=&name=${searchController.text}&role=');
    final headers = {'Authorization': '$accessToken'};

    try{
      final response = await http.get(uri, headers: headers);
      print('uri : $uri');
      statusCode = response.statusCode;
      print('statusCode : $statusCode');

      if(statusCode == 200){
        print('getUserInfo request succeed');
        String responseBody = utf8.decode(response.bodyBytes);
        print('getUserInfo decode : $responseBody');

        idset.clear();
        nameset.clear();

        // JSON 문자열을 Dart 객체로 변환
        var decodedResponse = jsonDecode(responseBody);

        // 'content' 키의 값을 가져옴
        List<dynamic> contents = decodedResponse['content'];

        // 각 사용자 정보에서 id와 name 추출하여 리스트에 추가
        for (var user in contents) {
          idset.add(user['id']);
          nameset.add(user['name']);
        }

        setState(() { });
        print('IDs: $idset');
        print('Names: $nameset');
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
    getUserList();
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: _scaffoldKey,
      appBar: AdminAppBar(scaffoldKey: _scaffoldKey),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 32.0,),
              Container(
                height: 40,
                width: 400,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('회원 정보', style: TextStyle(fontSize: 24, color: Color.fromRGBO(94, 130, 87, 1.0))),
                    const SizedBox(width: 80.0,),
                    Container(
                      height: 38,
                      width: 160.0,
                      // decoration: BoxDecoration(
                      //   shape: BoxShape.rectangle,
                      //   border: Border.all(color: mainColor),
                      // ),
                      child: TextField(
                        controller: searchController,
                        focusNode: searchFocus,
                        decoration: InputDecoration(
                          labelText: '이름 검색',
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.search),
                            onPressed: (){
                              // searchController.text 에 아무값도 입력하지 않으면 null 이 아닌 '' 처리됨
                              print('search clicked : ${searchController.text}');
                              getUserList();
                            },
                          ), // 시작 부분에 아이콘 추가
                          // suffixIcon: Icon(Icons.clear), // 끝 부분에 아이콘 추가 (필요한 경우)
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20,),
              Container(
                  height: 50,
                  width: 350,
                  decoration: const BoxDecoration(
                    color: Colors.white70,
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          "I D",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          "이 름",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          "관 리",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  )
              ),
              Container(
                //600이하로는 안줄어듦. 자동 min 효과.
                width : 350,
                height: 600,
                decoration: BoxDecoration(
                  border: Border.all(
                      width: 1,
                      color: Colors.black
                  ),
                ),
                child: Material(
                  child : ListView.builder(
                      itemCount: nameset.length,
                      shrinkWrap: true,
                      itemBuilder: (context,index){
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          tileColor: index % 2 == 0 ? Color.fromRGBO(196, 232, 181, 0.9) : Colors.white54,
                          horizontalTitleGap: -40,
                          // contentPadding: EdgeInsets.symmetric( horizontal: 10),
                          leading : Container(
                            width: 140.0,
                            alignment: Alignment.center,
                            child: Text(
                              idset[index],
                              style: const TextStyle(fontSize: 20, color: Color.fromRGBO(94, 130, 87, 1.0)),
                            ),
                          ),
                          title : Container(
                            width: 160.0,
                            alignment: Alignment.center,
                            child: Text(
                              nameset[index],
                              style: const TextStyle(fontSize: 20, color: Color.fromRGBO(94, 130, 87, 1.0)),
                            ),
                          ),
                          trailing: Container(
                            child :
                            IconButton(
                              icon: const Icon(Icons.transit_enterexit),
                              color: mainColor,
                              onPressed: () async{
                                SharedPreferences prefs = await SharedPreferences.getInstance();
                                prefs.remove('tmpId');
                                prefs.setString('tmpId', idset[index]);
                                print("tmpId : ${prefs.getString('tmpId')}");
                                Navigator.pushNamed(
                                    context, 'userDetail', arguments: idset[index]);
                              },
                            ),
                          ),
                        );
                      }
                  ),
                ),
              ),
              SizedBox(height: 24.0,),
            ],
          ),
        ),
      )
    );
  }
}
