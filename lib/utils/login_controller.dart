import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

int statusCode = 0;

class LoginController {
  Future<void> login(String id, String password,
      {Function()? onSuccess, Function(String)? onError}) async {
    // 여기에 실제 로그인 로직을 구현
    // 예를 들어 Firebase, 서버 호출 등을 사용할 수 있습니다.

    // 간단한 예제로 'test@test.com'과 'password'가 일치하면 성공으로 가정합니다.
    // if (id == 'test@test.com' && password == 'password') {
    //   onSuccess?.call();
    // }else if (id == password) {
    //   onSuccess?.call();
    // }
    // else {
    //   onError?.call('이메일 또는 비밀번호가 올바르지 않습니다.');
    // }


    print("login start");
    final uri = Uri.parse('http://15.164.251.76:8091/api/auth/token');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({'id': id, 'password': password});

    try{
      final response = await http.post(uri, headers: headers, body: body);
      statusCode = response.statusCode;
      print('statusCode : $statusCode');
      if (response.statusCode == 200) {
        print('LogIn request succeeded');

        String? responseBody = response.body;
        Map<String, dynamic> jsonMap = json.decode(responseBody);
        String refreshToken = jsonMap['refreshToken'];
        String admin = jsonMap['role'];
        Map<String, String> headers = response.headers;
        String? accessToken = headers["authorization"].toString();  // accessToken (with Bearer)
        // print('accessToken : $accessToken, refreshToken : $refreshToken');

        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.remove('accessToken');
        prefs.remove('refreshToken');
        prefs.remove('id');
        prefs.remove('role');
        await prefs.setString('accessToken', accessToken);
        await prefs.setString('refreshToken', refreshToken);
        await prefs.setString('id', id);
        await prefs.setString('role', admin);

        // // 자동 로그인을 위한 id, pw 저장
        // await _secureStorage.write(key: 'userID', value: id);
        // await _secureStorage.write(key: 'password', value: pw);
        // setState(() {
        //   _isLoggedIn = true;
        //   _userID = id;
        //   _password = pw;
        // });
        onSuccess?.call();

      } else if(response.statusCode == 500){
        print('ID : $id, PW : $password');
        print('Login Failed');
        onError?.call('이메일 또는 비밀번호가 올바르지 않습니다.');
      }
    }catch(e){
      // print(response.body);
      print("LogIn error!!");
      print(e.runtimeType);
    }
  }

  String infoData = "";
  Map infoMap = Map<String, dynamic>();

  void getUserInfo() async{
    print("getUserInfo start");
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
        print('getUserInfo request succeed');
        String responseBody = utf8.decode(response.bodyBytes);
        print('getUserInfo decode : $responseBody');

        infoData = responseBody;
        Map<String, dynamic> map = json.decode(infoData);

        // 'kitList' 추출 및 'idx' 값 추출
        var jsonResponse = json.decode(response.body);
        List<dynamic> kitList = jsonResponse['kitList'];

        print('kit list : !!!! $kitList');

        prefs.remove('name');
        prefs.remove('birth');
        prefs.remove('gender');
        prefs.remove('phoneNumber');
        prefs.remove('address');
        prefs.remove('role');
        prefs.remove('point');
        prefs.remove('kitIdx');

        await prefs.setString('name', map["name"]);
        await prefs.setString('birth', map["birth"]);
        await prefs.setString('gender', map["gender"]);
        await prefs.setString('phoneNumber', map["phoneNumber"]);
        await prefs.setString('address', map["address"]);
        await prefs.setString('role', map["role"]);
        await prefs.setInt('point', map["point"]);
        // 현재는 1인당 1kit로 제한하였지만 나중에 1대 n으로 변경시 로직 변경
        await prefs.setInt('kitIdx', kitList[0]["idx"]);
        await prefs.setString('serialNumber', kitList[0]["serialNumber"]);

      }
    }catch(e){
      print("error!!");
      print(e.runtimeType);
    }
  }
}