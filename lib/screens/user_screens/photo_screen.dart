/*
1. 미션 사진 등록 들어오면
2. 사용자 정보 조회 > 변수 저장
3. 키트 idx 조회 > 변수 저장
4. 사진 타입 지정 setState
5. 사진 촬영
6. api 전송
 */

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../widgets/common_widgets/base_app_bar.dart';
import '../../widgets/common_widgets/drawer.dart';

class PhotoScreen extends StatefulWidget {
  const PhotoScreen({super.key});

  @override
  State<PhotoScreen> createState() => _PhotoScreenState();
}

class _PhotoScreenState extends State<PhotoScreen> {
  int statusCode = 0;

  XFile? _image;  //이미지를 담을 변수 선언
  int? kitIdx;    //kitIdx를 담을 변수 선언

  final ImagePicker picker = ImagePicker(); //ImagePicker 초기화
  //이미지를 가져오는 함수
  Future getImage(ImageSource imageSource) async {
    //pickedFile에 ImagePicker로 가져온 이미지가 담긴다.
    final XFile? pickedFile = await picker.pickImage(source: imageSource);
    if (pickedFile != null) {
      setState(() {
        _image = XFile(pickedFile.path); //가져온 이미지를 _image에 저장
      });
    }
  }

  void getKitIdx() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? tmpIdx = prefs.getInt('kitIdx');
    setState(() {
      kitIdx = tmpIdx;
    });
  }

  void showUploadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // 사용자가 다이얼로그 바깥을 터치하더라도 닫히지 않도록 설정
      builder: (BuildContext context) {
        return const AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              CircularProgressIndicator(),
              SizedBox(height: 20),
              Text('사진 전송중'), // 'Transmitting'
            ],
          ),
        );
      },
    );
  }

  String responseData = "";
  Map responseMap = Map<String, dynamic>();

  void putMissionImg() async{
    showUploadingDialog(context);   // 사진 전송중 CircularProgressIndicator Dialog open
    print("putMissionImg start");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String accessToken = prefs.getString('accessToken')!;
    final uri = Uri.parse('http://15.164.251.76:8091/api/missions');
    // final headers = {'Authorization': '$accessToken'};
    // final body = jsonEncode({'kitIdx': kitIdx, 'type': selectedTheme, 'photoFile': _image});
    String tmpType = '';
    if(selectedTheme == '기록용'){
      tmpType = 'RECORD';
    }
    if(selectedTheme == '진화용'){
      tmpType = 'SUBMISSION';
    }

    // Multipart request 생성
    var request = http.MultipartRequest('PUT', uri)
      ..headers['Authorization'] = accessToken
      ..fields['kitIdx'] = kitIdx.toString()
      ..fields['type'] = tmpType;

    // _image가 null이 아닐 경우에만 이미지를 추가
    if (_image != null) {
      request.files.add(await http.MultipartFile.fromPath('photoFile', _image!.path));
    }

    try{
      // final response = await http.put(uri, headers: headers, body: body);
      final response = await request.send();
      statusCode = response.statusCode;
      print('statusCode : $statusCode');

      if(statusCode == 200){
        print('putMissionImg request succeed');
        // String responseBody = utf8.decode(response.bodyBytes);
        // print('putMissionImg decode : $responseBody');
        final respStr = await response.stream.bytesToString();
        print('putMissionImg decode : $respStr');

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('사진 저장 성공', style: TextStyle(fontSize: 20, fontFamily: "NotoSansKR", fontWeight: FontWeight.w900)), backgroundColor: Color.fromRGBO(94, 130, 87, 1.0)),
        );
      }else{
        print('ERROR! statusCode : $statusCode');
        final respStr = await response.stream.bytesToString();
        print('putMissionImg decode : $respStr');

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('사진 저장 실패!')),
        );
      }
    }catch(e){
      print("error!!");
      print(e.runtimeType);
    }finally {
      Navigator.of(context).pop(); // 다이얼로그 닫기
    }
  }

  final List<String> _DropDownMenuItems = <String>[
    '기록용', '진화용',
  ];
  String selectedTheme = '기록용';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getKitIdx();
  }

  Color fontColor = const Color.fromRGBO(94, 130, 87, 1.0);
  String fontFamily = 'NotoSansKR';
  TextStyle dataFontStyle = const TextStyle(fontSize: 16, fontFamily: 'NotoSansKR', fontWeight: FontWeight.w900, color: Color.fromRGBO(94, 130, 87, 1.0));

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    // return MaterialApp(
    //   home: Scaffold(
    return Scaffold(
        key: _scaffoldKey,
        appBar: BaseAppBar(scaffoldKey: _scaffoldKey),
        // appBar: BaseAppBar(),
        drawer: AppDrawer(),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            const SizedBox(height: 30, width: double.infinity),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                DropdownButton(
                  value: selectedTheme,
                  items: _DropDownMenuItems.map((String item) {
                    return DropdownMenuItem<String>(
                      value: item,
                      child: Text(item),
                    );
                  }).toList(),
                  onChanged: (dynamic value) {
                    setState(() {
                      selectedTheme = value;
                    });
                  },
                  icon: const Icon(Icons.arrow_downward),
                ),
                const SizedBox(width: 50,),
              ],
            ),
            const SizedBox(height: 20),
            _buildPhotoArea(),
            const SizedBox(height: 20),
            _buildButton(),
          ],
        ),
      );
    // );
  }

  Widget _buildPhotoArea() {
    return _image != null
        ? Container(
      width: 320,
      height: 480,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 320,
            height: 430,
            child: Image.file(
              File(_image!.path),
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 15,),
          Container(
            width: 104,
            height: 32,
            decoration: BoxDecoration(
              border: Border.all(
                color: fontColor, // 테두리 색상
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
                putMissionImg();
              },
              child: Text('저장', style: dataFontStyle,),
            ),
          ),

        ],
      ),
    )
        : Container(
      width: 320,
      height: 460,
      color: Colors.grey,
    );
  }

  Widget _buildButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 104,
          height: 32,
          decoration: BoxDecoration(
            border: Border.all(
              color: fontColor, // 테두리 색상
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
              getImage(ImageSource.camera);
            },
            child: Text('카메라', style: dataFontStyle,),
          ),
        ),
      ],
    );
  }
}
