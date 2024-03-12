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

  String? name; // user name
  int? point;   // user point

  int statusCode = 0;   // getProductsData statusCode
  int orderStatusCode = 0;  // postOrder statusCode
  String? errorMsg;
  String responseData = "";
  Map responseMap = Map<String, dynamic>();
  List<dynamic>? content;

  // h2 서버용 url
  String imgUrl = 'https://s3.ap-northeast-2.amazonaws.com/koinsect.s3.bucket/';

  void setUserData() async{
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
          point = responseMap["point"];
        });
      }
    }catch(e){
      print("error!!");
      print(e.runtimeType);
    }
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

  Future<void> postOrder(int productId) async{
    print("postOrder start");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String accessToken = prefs.getString('accessToken')!;
    final uri = Uri.parse('http://15.164.251.76:8091/api/orders');
    final headers = {'Authorization': '$accessToken', 'Content-Type': 'application/json'};
    final body = jsonEncode({'productId': productId,}, );

    try{
      final response = await http.post(uri, headers: headers, body: body);
      setState(() {
        orderStatusCode = response.statusCode;
      });
      print('orderStatusCode : $orderStatusCode');
      print(response.body);

      if(orderStatusCode == 200){
        print('postOrder request succeed');
      }else if(orderStatusCode==400){
        print('error : $orderStatusCode');
        setState(() {
          if(response.body!= null) {
            errorMsg = response.body.toString();
          }
        });
      }else if(orderStatusCode==404){
        print('error : $orderStatusCode');
        setState(() {
          if(response.body!= null) {
            errorMsg = response.body.toString();
          }
        });
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
              Container(
                height: 70,
                child:
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(width: 0), // 전체 Text의 왼쪽 여백 관리
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
                      const SizedBox(width: 20),
                      Container(
                        width: 190,
                        height: 70,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children:[
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Text('$point', style: TextStyle(color: Color.fromRGBO(96, 178, 64, 1), fontSize: 30),),
                                ),
                                const SizedBox(width: 20,),
                                const Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text('밀', style: TextStyle(color: Color.fromRGBO(96, 178, 64, 1), fontSize: 37),),
                                ),
                              ]
                            ),

                            Container(
                              height: 1.0,
                              width: 150,
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
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                        child: GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    // backgroundColor: Color.fromRGBO(196, 232, 181, 1.0 ),
                                    content: Container(
                                      height: 400,
                                      child: Column(
                                        children: [
                                          content?[index]['url'] == null
                                          ? Image.network(
                                            'https://via.placeholder.com/150?text=No+Image',
                                            fit: BoxFit.cover,
                                          )
                                          : Image.network(
                                            '$imgUrl${content?[index]['url']}',
                                            fit: BoxFit.cover,
                                          ),
                                          const SizedBox(height: 12,),
                                          Container(
                                              width: 160,
                                              child:
                                              Text('${content?[index]['name']}' ?? ''
                                                , textAlign: TextAlign.center, softWrap: true,),
                                          ),
                                          Text('${content?[index]['price']}밀' ?? ''
                                            , textAlign: TextAlign.center, style: TextStyle(color: Colors.green),
                                          ),
                                          ElevatedButton(
                                            onPressed:() async{
                                              await postOrder(content?[index]['idx']);
                                              Navigator.pushNamed(context, 'reward');
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                orderStatusCode == 200
                                                    ? const SnackBar(
                                                  content: Text('구매 성공!'),
                                                  backgroundColor: Color.fromRGBO(196, 232, 181, 0.9),
                                                )
                                                    : const SnackBar(
                                                  content: Text('구매 실패!'),
                                                  backgroundColor: Colors.red,
                                                ),
                                              );
                                            } ,
                                            child: Text('구매하기'),
                                          ),
                                        ]
                                      ),
                                    )
                                  );
                                },
                              );
                            },
                            child:
                            content?[index]['url'] == null
                                ? Image.network(
                              'https://via.placeholder.com/150?text=No+Image',
                              fit: BoxFit.cover,
                            )
                                : Image.network(
                              '$imgUrl${content?[index]['url']}',
                              fit: BoxFit.fitHeight,
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
