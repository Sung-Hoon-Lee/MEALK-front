import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../widgets/admin_widgets/admin_app_bar.dart';

class PictureList extends StatefulWidget {
  const PictureList({super.key});

  @override
  State<PictureList> createState() => _PictureListState();
}

class _PictureListState extends State<PictureList> {

  String imgUrl = 'https://s3.ap-northeast-2.amazonaws.com/koinsect.s3.bucket/';

  int statusCode = 0;
  // response decode를 위한 준비물
  String responseData = "";
  Map responseMap = Map<String, dynamic>();

  int? kitIdx;

  Future<void> getKitIdx() async{
    print("getKitIdx start");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? id = prefs.getString('tmpId');
    String accessToken = prefs.getString('accessToken')!;
    final uri = Uri.parse('http://15.164.251.76:8091/admin/api/users/$id');
    final headers = {'Authorization': '$accessToken'};
    try{
      final response = await http.get(uri, headers: headers);
      statusCode = response.statusCode;
      print('statusCode : $statusCode');

      if(statusCode == 200){
        print('getKitIdx request succeed');
        String responseBody = utf8.decode(response.bodyBytes);
        print('getKitIdx decode : $responseBody');

        responseData = responseBody;
        responseMap = json.decode(responseData);

        setState(() {
          kitIdx = responseMap["kitList"][0]["idx"];
        });
        print('kitIdx : $kitIdx');
      }
    }catch(e){
      print("error!!");
      print(e.runtimeType);
    }
  }

  int statusCode2 = 0;
  // response decode를 위한 준비물
  String responseData2 = "";
  Map responseMap2 = Map<String, dynamic>();

  var dateSet = [];
  var typeSet = [];
  var urlSet = [];
  var missionIdx = [];

  Future<void> getMissionList() async{
    print("getMissionList start");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? id = prefs.getString('tmpId');
    String accessToken = prefs.getString('accessToken')!;
    final uri = Uri.parse('http://15.164.251.76:8091/admin/api/missions?kitIdx=$kitIdx&achieverId=$id&status=SUBMITTED&page=0&size=100&sort=');
    final headers = {'Authorization': '$accessToken'};
    try{
      final response = await http.get(uri, headers: headers);
      statusCode2 = response.statusCode;
      print('statusCode2 : $statusCode2');
      print('!!!!! $id, $kitIdx');

      if(statusCode2 == 200){
        print('getMissionList request succeed');
        String responseBody = utf8.decode(response.bodyBytes);
        print('getMissionList decode : $responseBody');

        dateSet.clear();
        typeSet.clear();
        urlSet.clear();
        missionIdx.clear();

        // JSON 문자열을 Dart 객체로 변환
        var decodedResponse = jsonDecode(responseBody);

        // 'content' 키의 값을 가져옴
        List<dynamic> contents = decodedResponse['content'];

        // 각 사용자 정보에서 id와 name 추출하여 리스트에 추가
        for (var user in contents) {
          dateSet.add(user['createdDate'].toString().substring(0, 10));
          typeSet.add(user['type']);
          urlSet.add(user['url']);
          missionIdx.add(user['idx']);
        }

        setState(() { });
        print('date: $dateSet');
        print('type: $typeSet');
        print('url: $urlSet');
        print('idx : $missionIdx');

        setState(() {
          
        });
      }
    }catch(e){
      print("error!!");
      print(e.runtimeType);
    }
  }

  void initFunc() async{
   await getKitIdx();
   await getMissionList();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getKitIdx();
    // getMissionList();
    initFunc();
  }

  Color mainColor = const Color.fromRGBO(94, 130, 87, 1.0);

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
                  child: const Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('사진 리스트', style: TextStyle(fontSize: 24, color: Color.fromRGBO(94, 130, 87, 1.0))),
                      SizedBox(width: 180.0,),
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
                            "제출일자",
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            "사진타입",
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
                        itemCount: dateSet.length,
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
                                dateSet[index],
                                style: const TextStyle(fontSize: 20, color: Color.fromRGBO(94, 130, 87, 1.0)),
                              ),
                            ),
                            title : Container(
                              width: 160.0,
                              alignment: Alignment.center,
                              child: Text(
                                typeSet[index] == "SUBMISSION" ? "제출용" : "기록용",
                                // style: const TextStyle(fontSize: 20, color: Color.fromRGBO(94, 130, 87, 1.0)),
                                style: typeSet[index] == "SUBMISSION"
                                    ? TextStyle(fontSize: 20,  color: Colors.red)
                                    : const TextStyle(fontSize: 20, color: Color.fromRGBO(94, 130, 87, 1.0)
                                    ,
                                )
                              ),
                            ),
                            trailing: Container(
                              child :
                              IconButton(
                                icon: const Icon(Icons.transit_enterexit),
                                color: mainColor,
                                onPressed: () async{
                                  SharedPreferences prefs = await SharedPreferences.getInstance();
                                  prefs.remove('tmpDate');
                                  prefs.setString('tmpDate', dateSet[index]);
                                  prefs.remove('tmpUrl');
                                  prefs.setString('tmpUrl', urlSet[index]);
                                  prefs.remove('tmpMissionIdx');
                                  prefs.setInt('tmpMissionIdx', missionIdx[index]);

                                  typeSet[index] == "SUBMISSION"
                                      ?
                                        Navigator.pushNamed(context, 'confirm')
                                      : showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        // backgroundColor: Color.fromRGBO(196, 232, 181, 1.0 ),
                                          content:
                                          Container(
                                            width: MediaQuery.of(context).size.width,
                                            // height: MediaQuery.of(context).size.height,
                                            height: 500,
                                            child: AspectRatio(
                                              aspectRatio: 16 / 9, // 이미지의 가로:세로 비율에 맞게 조절
                                              child: Image.network(
                                                '$imgUrl${urlSet?[index]}',
                                                fit: BoxFit.cover, // 또는 BoxFit.contain
                                              ),
                                            ),
                                          )
                                      );
                                    },
                                  );
                                  ;

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

