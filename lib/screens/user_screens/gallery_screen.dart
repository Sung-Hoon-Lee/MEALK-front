import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../widgets/common_widgets/base_app_bar.dart';
import '../../widgets/common_widgets/drawer.dart';

class GalleryScreen extends StatefulWidget {
const GalleryScreen({super.key});

@override
State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {

  int statusCode = 0;
  String responseData = "";
  Map responseMap = Map<String, dynamic>();
  List<dynamic>? content;

  String imgUrl = 'https://s3.ap-northeast-2.amazonaws.com/koinsect.s3.bucket/';

  void getUserPhotos() async{
    print("getProductsData start");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String accessToken = prefs.getString('accessToken')!;
    int kitIdx = prefs.getInt('kitIdx')!;
    print('kitIdx : $kitIdx');
    final uri = Uri.parse('http://15.164.251.76:8091/api/missions?kitIdx=$kitIdx&type=RECORD&status=SUBMITTED&page=0&size=10&sort=');
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
          print('registeredDate: ${content['registeredDate']}');
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
    getUserPhotos();
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 다른 내용을 추가하거나 수정할 수 있습니다.
              const SizedBox(height: 32),
              const Text('나의 밀웜 갤러리', style: TextStyle(fontSize: 32)),
              const SizedBox(height: 32),
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
                          child: Image.network(
                            // 'https://via.placeholder.com/150',
                            '$imgUrl${content?[index]['url']}',
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(height: 4,),
                        Text('${content?[index]['registeredDate']}' ?? ''),
                      ],
                    ),
                  );
                },
              )
                  : CircularProgressIndicator(), // 데이터가 로드 중이거나 널일 때 로딩 인디케이터 표시
            ],
          ),
        ),
      ),
    );
  }
}

// http://15.164.251.76:8091/mealwormFarm/2024-02-15/084255_b279de5f-6c31-4437-92bd-9d49cb927d317781393752758723822.jpg