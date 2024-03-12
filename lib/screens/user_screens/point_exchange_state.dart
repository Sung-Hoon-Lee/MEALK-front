import 'dart:convert';
import 'package:eco_mealworm_farm/widgets/common_widgets/drawer.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../widgets/common_widgets/drawer.dart';

import '../../widgets/common_widgets/base_app_bar.dart';

class PointExchangeState extends StatefulWidget {
  const PointExchangeState({super.key});

  @override
  State<PointExchangeState> createState() => _PointExchangeStateState();
}

class _PointExchangeStateState extends State<PointExchangeState> {
  String? name; // user name
  int? point;   // user point

  int statusCode = 0;   // getProductsData statusCode
  String? errorMsg;
  String responseData = "";

  Map responseMap = Map<String, dynamic>();   // setUserData 용 Map

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

  Map responseMap2 = Map<String, dynamic>();  // getUserPointExchangeState 용 Map
  List<dynamic> content = [];

  void getUserPointExchangeState() async{
    print("getUserPointExchangeState start");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String accessToken = prefs.getString('accessToken')!;
    final uri = Uri.parse('http://15.164.251.76:8091/api/points?page=0&size=100&sort=');
    final headers = {'Authorization': '$accessToken'};

    try{
      final response = await http.get(uri, headers: headers);
      statusCode = response.statusCode;
      print('statusCode : $statusCode');

      if(statusCode == 200){
        print('getUserPointExchangeState request succeed');
        String responseBody = utf8.decode(response.bodyBytes);
        print('getUserPointExchangeState decode : $responseBody');

        responseData = responseBody;
        responseMap2 = json.decode(responseData);

        setState(() {
          content = responseMap2['content'];
          if (content != null) {
            List<dynamic> convertedList = List.from(content as Iterable);
            // 또는 List<dynamic> convertedList = content!;
          }
        });

        for (var content in content!) {
          if(content['type'] == "EARNED"){
            print('Type: ${content['type']}, Price: ${content['amount']}, createdDate: ${content['createdDate']}, missionType: ${content['missionType']}, missionUrl: ${content['missionUrl']}');
          }else {
            print('Type: ${content['type']}, Price: ${content['amount']}, createdDate: ${content['createdDate']}, productName: ${content['productName']}');
          }
          content['createdDate'] = content['createdDate'].toString().substring(0, 10);
        }

      }
    }catch(e){
      print("getUserPointExchangeState error!!");
      print(e.runtimeType);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setUserData();
    getUserPointExchangeState();
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    // 'productName'과 'usedPoint'만 추출
    // List<Map<String, dynamic>>? rows = content
    //     ?.map((item) => {
    //   "productName": item["productName"],
    //   "usedPoint": item["usedPoint"]
    // })
    //     .toList() ?? [];

    // 'content'가 8행 미만일 경우 빈행 추가
    while (content!.length < 8) {
      content?.add({"idx": " ","userId":" ","type":" ","amount":" ","createdDate":" ","missionType":" ","missionStatus":" ","missionUrl":" ","productName":" ","productPrice": " "});

    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: BaseAppBar(scaffoldKey: _scaffoldKey),
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
                          Text('$name님의', style: const TextStyle(fontSize: 20, color: Color.fromRGBO(94, 130, 87, 1.0),),),
                          const SizedBox(height: 3,),
                          const Text('현재 포인트', style: TextStyle(fontSize: 20, color: Color.fromRGBO(94, 130, 87, 1.0),),),
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
                                  child: Text('$point', style: TextStyle(color: Color.fromRGBO(94, 130, 87, 1.0), fontSize: 30),),
                                ),
                                const SizedBox(width: 20,),
                                const Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text('밀', style: TextStyle(color: Color.fromRGBO(94, 130, 87, 1.0), fontSize: 37),),
                                ),
                              ]
                          ),

                          Container(
                            height: 1.0,
                            width: 150,
                            color: Color.fromRGBO(94, 130, 87, 1.0),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16,),
              Text('포인트 사용 내역을 확인해 보세요', style: TextStyle(color: Color.fromRGBO(94, 130, 87, 1.0), fontSize: 24),),
              SizedBox(height: 24,),
              DataTable(
                columns: const [
                  DataColumn(label: Text('날    짜', style: TextStyle(color: Color.fromRGBO(94, 130, 87, 1.0), fontSize: 20),)),
                  DataColumn(label: Text('포 인 트', style: TextStyle(color: Color.fromRGBO(94, 130, 87, 1.0), fontSize: 20),)),
                ],
                rows: content!.map((row) {
                  return DataRow(cells: [
                    // DataCell(Text(row['productName'].toString())),
                    DataCell(Text(
                      row['createdDate'].toString(),
                      style: TextStyle(fontSize: 16), // usedPoint 텍스트를 파란색으로 설정
                    )),
                    DataCell(Text(
                      row['amount'].toString(),
                      // style: TextStyle(color: Colors.blue, fontSize: 16), // usedPoint 텍스트를 파란색으로 설정
                      style: row['type']=="EARNED" ? TextStyle(color: Colors.red, fontSize: 16) : TextStyle(color: Colors.blue, fontSize: 16),
                    )),
                  ]);
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
