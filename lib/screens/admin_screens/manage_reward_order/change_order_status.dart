import 'dart:convert';
import '../../../widgets/admin_widgets/admin_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class ChangeOrderStatus extends StatefulWidget {
  const ChangeOrderStatus({super.key});

  @override
  State<ChangeOrderStatus> createState() => _ChangeOrderStatusState();
}

class _ChangeOrderStatusState extends State<ChangeOrderStatus> {

  String? name;
  String? phoneNumber;
  String? orderProductName;
  String? orderUserId;
  int? orderUsedPoint;
  int? orderIdx;

  int getUserDataStatusCode = 0;
  String getUserDataResponseData = "";
  Map getUserDataResponseMap = Map<String, dynamic>();

  void getUserData() async{
    print("getUserData start");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String id = prefs.getString('orderUserId')!;
    String accessToken = prefs.getString('accessToken')!;
    final uri = Uri.parse('http://15.164.251.76:8091/admin/api/users/$id');
    final headers = {'Authorization': '$accessToken'};

    try{
      final response = await http.get(uri, headers: headers);
      getUserDataStatusCode = response.statusCode;
      print('statusCode : $getUserDataStatusCode');

      if(getUserDataStatusCode == 200){
        print('getUserData request succeed');
        String responseBody = utf8.decode(response.bodyBytes);
        print('getUserData decode : $responseBody');

        getUserDataResponseData = responseBody;
        getUserDataResponseMap = json.decode(getUserDataResponseData);

        setState(() {
          name = getUserDataResponseMap["name"];
          phoneNumber = getUserDataResponseMap["phoneNumber"];
          orderUserId = prefs.getString('orderUserId');
          orderProductName = prefs.getString('orderProductName');
          orderUsedPoint = prefs.getInt('orderUsedPoint');
          orderIdx = prefs.getInt('orderIdx');
        });
      }
    }catch(e){
      print("error!!");
      print(e.runtimeType);
    }
  }

  int patchStatusCode = 0;

  Future<void> patchOrderState() async{
    print("patchOrderState start");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String accessToken = prefs.getString('accessToken')!;
    int idx = prefs.getInt('orderIdx')!;
    final uri = Uri.parse('http://15.164.251.76:8091/admin/api/orders/$idx');
    final headers = {'Authorization': '$accessToken', 'Content-Type': 'application/json'};
    final body = jsonEncode({'status': 'DELIVERED'}, );

    try{
      final response = await http.patch(uri, headers: headers, body: body);
      setState(() {
        patchStatusCode = response.statusCode;
      });
      print('orderStatusCode : ${response.statusCode}');
      print(response.body);

      if(patchStatusCode == 200){
        print('patchUserInfo request succeed');
      }
    }catch(e){
      print("patchUserInfo error!!");
      print(e.runtimeType);
    }
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      throw '발신 불가! $launchUri';
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
  }

  Color mainColor = const Color.fromRGBO(94, 130, 87, 1.0);
  String fontFamily = 'NotoSansKR';
  TextStyle dataFontStyle = const TextStyle(fontSize: 20, fontFamily: 'NotoSansKR', fontWeight: FontWeight.w900, color: Color.fromRGBO(94, 130, 87, 1.0));
  TextStyle titleFontStyle = const TextStyle(fontSize: 40, fontFamily: 'NotoSansKR', fontWeight: FontWeight.w900, color: Color.fromRGBO(94, 130, 87, 1.0));


  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _adminScaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: _adminScaffoldKey,
      appBar: AdminAppBar(scaffoldKey: _adminScaffoldKey),
      // appBar: BaseAppBar(),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 370,
                height: 550,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 32,),
                    Text('$name님 리워드 지급', style: titleFontStyle,),
                    const SizedBox(height: 16,),
                    Text('요청 상품 : $orderProductName', style: dataFontStyle,),
                    const SizedBox(height: 8,),
                    Text('사용 포인트 : $orderUsedPoint 밀', style: dataFontStyle,),
                    // Text('전화걸기', style: titleFontStyle,),
                    // const SizedBox(height: 8,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.call_rounded, color: mainColor),
                        SizedBox(width: 8,),
                        TextButton(
                          onPressed: () {
                            _makePhoneCall(phoneNumber!);
                          },
                          child: Text('$phoneNumber', style: dataFontStyle,),
                        ),
                        SizedBox(width: 16,),
                      ],
                    ),

                    const SizedBox(height: 64,),
                    Container(
                      width: 160,
                      height: 64,
                      child:
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: const Color.fromRGBO(94, 130, 87, 1.0), // 버튼의 배경색
                          onPrimary: Colors.white, // 버튼의 텍스트 및 아이콘 색상
                          textStyle: dataFontStyle,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        onPressed: () async{
                          await patchOrderState();
                          ScaffoldMessenger.of(context).showSnackBar(
                            patchStatusCode == 200
                                ? const SnackBar(
                              content: Text('리워드 지급 완료'),
                              backgroundColor: Color.fromRGBO(196, 232, 181, 0.9),
                            )
                                : const SnackBar(
                              content: Text('리워드 지급 요청 실패!'),
                              backgroundColor: Colors.red,
                            ),
                          );
                          patchStatusCode == 200
                          ? Navigator.pushNamedAndRemoveUntil(context, 'orderUserList', (_) => false)
                          : print('patch failed');
                        },
                        child: const Text('지급완료', style: TextStyle(fontSize: 24),),
                      ),
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
