import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../widgets/admin_widgets/admin_app_bar.dart';

class ConfirmPicture extends StatefulWidget {
  const ConfirmPicture({super.key});

  @override
  State<ConfirmPicture> createState() => _ConfirmPictureState();
}

class _ConfirmPictureState extends State<ConfirmPicture> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String? date = "";
  String? url = "";
  String imgUrl = 'https://s3.ap-northeast-2.amazonaws.com/koinsect.s3.bucket/';

  final List<String> _DropDownMenuItems = <String>[
    '번데기 진화',  //
    '밀웜 진화',
  ];
  String selectedItem = '번데기 진화';

  // 포인트 지급 textField controller
  final TextEditingController pointController = TextEditingController();

  void setData() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      date = prefs.getString('tmpDate');
      url = prefs.getString('tmpUrl');
      url = imgUrl + url!;
    });
  }

  int statusCode = 0;

  Future<void> patchMissionState() async{
    print("patchMissionState start");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String accessToken = prefs.getString('accessToken')!;
    int idx = prefs.getInt('tmpMissionIdx')!;
    final uri = Uri.parse('http://15.164.251.76:8091/admin/api/missions/$idx');
    final headers = {'Authorization': '$accessToken', 'Content-Type': 'application/json'};
    final body = jsonEncode({'status': 'APPROVED'}, );

    try{
      final response = await http.patch(uri, headers: headers, body: body);
      setState(() {
        statusCode = response.statusCode;
      });
      print('MissionStatusCode : ${response.statusCode}');
      print(response.body);

      if(statusCode == 200){
        print('patchMissionState request succeed');
      }
    }catch(e){
      print("patchMissionState error!!");
      print(e.runtimeType);
    }
  }

  int statusCode2 = 0;

  Future<void> postGivePoint() async{
    print("postGivePoint start");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String accessToken = prefs.getString('accessToken')!;
    int idx = prefs.getInt('tmpMissionIdx')!;
    int? pointAmount = int.tryParse(pointController.text);
    final uri = Uri.parse('http://15.164.251.76:8091/admin/api/missions/$idx/points');
    final headers = {'Authorization': '$accessToken', 'Content-Type': 'application/json'};
    final body = jsonEncode({'pointAmount': pointAmount});

    try{
      final response = await http.post(uri, headers: headers, body: body);
      setState(() {
        statusCode2 = response.statusCode;
      });
      print('request Headers : $headers, request Body : $body');
      print('postGivePoint : ${response.statusCode}');
      print(response.body);

      if(statusCode2 == 200){
        print('postGivePoint request succeed');
      }else{
        print('api Error : $statusCode2, ${response.body}');
      }
    }catch(e){
      print("patchMissionState error!!");
      print(e.runtimeType);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setData();
  }

  Color mainColor = const Color.fromRGBO(94, 130, 87, 1.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AdminAppBar(scaffoldKey: _scaffoldKey),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 24.0,),
              Container(
                width: MediaQuery.of(context).size.width - 30.0,
                // height: MediaQuery.of(context).size.height,
                // width: 350,
                height: 450,
                child: AspectRatio(
                  aspectRatio: 16 / 9, // 이미지의 가로:세로 비율에 맞게 조절
                  child: url != null && url!.isNotEmpty
                      ? Image.network(
                    url!,
                    fit: BoxFit.cover,
                  )
                      : CircularProgressIndicator(),
                ),
              ),
              SizedBox(height: 24.0,),
              Text('밀웜 키트 상태 변경', style: TextStyle(fontSize: 20.0),),
              SizedBox(height: 12.0,),
              Container(
                height: 100,
                width: 300,
                decoration: BoxDecoration(
                  border: Border.all(
                      width: 1.5,
                      color: mainColor
                  ),
                  // color: mainColor,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(width: 24,),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: mainColor, // 테두리 색상
                          width: 1.0, // 테두리 두께
                        ),
                      ),
                      child: DropdownButton(
                        value: selectedItem,
                        items: _DropDownMenuItems.map((String item) {
                          return DropdownMenuItem<String>(
                            value: item,
                            child: Text(item, style:TextStyle(
                                fontSize: 24.0,
                                fontFamily: "NotoSansKR",
                                fontWeight: FontWeight.w900),),
                          );
                        }).toList(),
                        onChanged: (dynamic value) {
                          setState(() {
                            selectedItem = value;
                          });
                        },
                        icon: const Icon(Icons.arrow_downward),
                      ),
                    ),
                    const SizedBox(width: 20,),
                    Container(
                      width: 80,
                      // height: 64,
                      child:
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: const Color.fromRGBO(94, 130, 87, 1.0), // 버튼의 배경색
                          onPrimary: Colors.white, // 버튼의 텍스트 및 아이콘 색상
                          textStyle: const TextStyle(
                              fontSize: 16,
                              fontFamily: "NotoSansKR",
                              fontWeight: FontWeight.w900),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        onPressed: () async{
                          await patchMissionState();
                          statusCode == 200
                              ? ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('변경 성공!',
                                      style: TextStyle(color: Colors.white, fontSize: 20, fontFamily: 'NotoSansKR', fontWeight: FontWeight.w900),
                                      textAlign: TextAlign.center
                                  ),
                                  // backgroundColor: Color.fromRGBO(223, 255, 215, 1),
                                  backgroundColor: Color.fromRGBO(94, 130, 87, 1.0),
                                ),
                              )
                              : ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('변경 실패!',
                                      style: TextStyle(color: Colors.white, fontSize: 20, fontFamily: 'NotoSansKR', fontWeight: FontWeight.w900),
                                      textAlign: TextAlign.center
                                  ),
                                  // backgroundColor: Color.fromRGBO(223, 255, 215, 1),
                                  backgroundColor: Colors.redAccent,
                                ),
                              );
                        },
                        child: const Text('변경', style: TextStyle(fontSize: 24),),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16.0,),
              // 포인트 지급 --------------------------------
              const Text('사용자 포인트 지급(상태 변경후 가능)', style: TextStyle(fontSize: 20.0),),
              const SizedBox(height: 12.0,),
              Container(
                width: 300,
                height: 100,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: mainColor, // 테두리 색상
                    width: 1.5, // 테두리 두께
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 150,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: mainColor, // 테두리 색상
                          width: 1.0, // 테두리 두께
                        ),
                      ),
                      child: TextField(
                        controller: pointController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: '지급 포인트 입력',
                          hintStyle: TextStyle(color: Colors.grey),
                        ),

                      ),
                    ),
                    const SizedBox(width: 20,),
                    Container(
                      width: 80,
                      // height: 64,
                      child:
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: const Color.fromRGBO(94, 130, 87, 1.0), // 버튼의 배경색
                          onPrimary: Colors.white, // 버튼의 텍스트 및 아이콘 색상
                          textStyle: const TextStyle(
                              fontSize: 16,
                              fontFamily: "NotoSansKR",
                              fontWeight: FontWeight.w900),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        onPressed: () async{
                          await postGivePoint();
                          statusCode2 == 200
                              ? ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('지급 성공!',
                                  style: TextStyle(color: Colors.white, fontSize: 20, fontFamily: 'NotoSansKR', fontWeight: FontWeight.w900),
                                  textAlign: TextAlign.center
                              ),
                              // backgroundColor: Color.fromRGBO(223, 255, 215, 1),
                              backgroundColor: Color.fromRGBO(94, 130, 87, 1.0),
                            ),
                          )
                              : ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('지급 실패!',
                                  style: TextStyle(color: Colors.white, fontSize: 20, fontFamily: 'NotoSansKR', fontWeight: FontWeight.w900),
                                  textAlign: TextAlign.center
                              ),
                              // backgroundColor: Color.fromRGBO(223, 255, 215, 1),
                              backgroundColor: Colors.redAccent,
                            ),
                          );
                        },
                        child: const Text('지급', style: TextStyle(fontSize: 24),),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24,),
            ]
          )
        )
      )
    );
  }
}
