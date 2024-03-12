import 'dart:convert';

import 'package:eco_mealworm_farm/widgets/common_widgets/drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../widgets/common_widgets/base_app_bar.dart';

class RewardScreen extends StatefulWidget {
  const RewardScreen({super.key});

  @override
  State<RewardScreen> createState() => _RewardScreenState();
}

class _RewardScreenState extends State<RewardScreen> {

  String? name;
  int? point;

  int statusCode = 0;
  String responseData = "";
  Map responseMap = Map<String, dynamic>();
  List<dynamic>? content;

  void setUserData() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('name');
      point = prefs.getInt('point');
      // point = 0;
    });
  }

  void getProductsData() async{
    print("getProductsData start");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String accessToken = prefs.getString('accessToken')!;
    final uri = Uri.parse('http://15.164.251.76:8091/api/products?page=0&size=10&sort=');
    final headers = {'Authorization': '$accessToken'};

    try{
      final response = await http.get(uri, headers: headers);
      statusCode = response.statusCode;
      print('statusCode : $statusCode');

      if(statusCode == 200){
        print('getProductsData request succeed');
        String responseBody = utf8.decode(response.bodyBytes);
        // print('getProductsData decode : $responseBody');

        responseData = responseBody;
        responseMap = json.decode(responseData);
        print('getProductsData Map decode : $responseMap');

        setState(() {
          content = responseMap['content'];
        });

        for (var content in content!) {
          print('Name: ${content['name']}, Price: ${content['price']}');
        }
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
    setUserData();
    getProductsData();
  }

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
            // crossAxisAlignment: CrossAxisAlignment.center,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 다른 내용을 추가하거나 수정할 수 있습니다.
              const SizedBox(height: 60),
              // Container(
              //   height: 80,
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       Container(
              //         height: 70,
              //         child: Column(
              //           children: [
              //             Text('$name님의', style: const TextStyle(fontSize: 20, color: Color.fromRGBO(96, 178, 64, 1),),),
              //             const SizedBox(height: 3,),
              //             const Text('현재 포인트', style: TextStyle(fontSize: 20, color: Color.fromRGBO(96, 178, 64, 1),),),
              //           ],
              //         ),
              //       ),
              //       Container(
              //         height: 80,
              //         child: Column(
              //           children: [
              //             Container(
              //               height: 75,
              //               child: Row(
              //                 mainAxisAlignment: MainAxisAlignment.end,
              //                 children: [
              //                   Text('$point', style: TextStyle(color: Color.fromRGBO(96, 178, 64, 1), fontSize: 34),),
              //                   Text(' 밀', style: TextStyle(color: Color.fromRGBO(96, 178, 64, 1), fontSize: 34),),
              //                 ],
              //               ),
              //             ),
              //             Container(
              //               height: 5,
              //               child: Row(
              //                 mainAxisAlignment: MainAxisAlignment.end,
              //                 children: [
              //                   Container(
              //                     height: 1.0,
              //                     width: 70,
              //                     color: Color.fromRGBO(96, 178, 64, 1),
              //                   ),
              //                   SizedBox(width: 20,),
              //                 ],
              //               ),
              //             ),
              //           ],
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              //-----------------------------------------------
              Container(
                height: 70,
                child:
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(width: 0), // 전체 Text의 왼쪽 여백 관리
                    Container(
                      width: 90,
                      child:
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('$name님의', style: const TextStyle(fontSize: 20, color: Color.fromRGBO(96, 178, 64, 1),),),
                          const SizedBox(height: 3,),
                          const Text('현재 포인트', style: TextStyle(fontSize: 20, color: Color.fromRGBO(96, 178, 64, 1),),),
                        ],
                      ),
                    ),
                    SizedBox(width: 20),
                    Container(
                      width: 150,
                      height: 70,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text('$point 밀', style: TextStyle(color: Color.fromRGBO(96, 178, 64, 1), fontSize: 37),),
                          ),

                          Container(
                            height: 1.0,
                            width: 120,
                            color: Color.fromRGBO(96, 178, 64, 1),
                          ),
                        ],
                      ),
                    ),


                  ],
                ),
              ),
              SizedBox(height: 30,),
              content != null
                  ? GridView.builder(
                shrinkWrap: true, // GridView의 높이를 내부 내용에 맞춤
                physics: NeverScrollableScrollPhysics(), // 내부 스크롤 비활성화
                itemCount: content!.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemBuilder: (context, index) {
                  return GridTile(
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          //   child: Image.network(
                          //     'https://via.placeholder.com/150',
                          //     fit: BoxFit.cover,
                          //   ),
                          // ),
                          child: GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    // backgroundColor: Color.fromRGBO(196, 232, 181, 1.0 ),
                                      content: Container(
                                        height: 280,
                                        child: Column(
                                            children: [
                                              Image.network(
                                                'https://via.placeholder.com/150',
                                                fit: BoxFit.cover,
                                              ),
                                              const SizedBox(height: 12,),
                                              Container(
                                                width: 160,
                                                child:
                                                Text('${content?[index]['name']}' ?? ''
                                                  , textAlign: TextAlign.center, softWrap: true,), // Null 처리
                                              ),
                                              Text('${content?[index]['price']}밀' ?? ''
                                                , textAlign: TextAlign.center, style: TextStyle(color: Colors.green),),
                                            ]
                                        ),
                                      )
                                  );
                                },
                              );
                            },
                            child: Image.network(
                              'https://via.placeholder.com/150',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Container(
                          width: 140,
                          child:
                          Text('${content?[index]['name']}' ?? ''
                            , textAlign: TextAlign.center, softWrap: true,), // Null 처리
                        ),
                        Text('${content?[index]['price']}밀' ?? ''
                          , textAlign: TextAlign.center, style: TextStyle(color: Colors.green),),
                        const SizedBox(height: 10,),
                      ],
                    ),
                  );
                },
              )
                  : CircularProgressIndicator(), // 데이터가 로드 중이거나 널일 때 로딩 인디케이터 표시
              const SizedBox(height: 10,),
            ],
          ),
        ),
      ),
    );
  }
}
