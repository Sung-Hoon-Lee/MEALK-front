import 'dart:convert';
import 'package:http/http.dart' as http;

class SignUpController {
  Future<void> signUp(
      String id,
      String password,
      String name,
      String birth,
      String gender,
      String phoneNumber,
      String serialNumber,
      String address, {
        Function()? onSuccess,
        Function(String)? onError,
      }) async {

    print("signup start");
    final uri = Uri.parse('http://15.164.251.76:8091/api/users');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({'id': id, 'password': password, 'name' : name, 'birth' : birth, 'gender' : gender, 'phoneNumber': phoneNumber, 'address': address, 'serialNumber' : serialNumber}, );

    try{
      final response = await http.post(uri, headers: headers, body: body);
      if (response.statusCode == 200) {
        onSuccess?.call();
        print('SignUp request succeeded');
        print(response.body);
      }else if(response.statusCode == 400){
        onError?.call('이미 등록된 키트 입니다.');
      }else if(response.statusCode == 404) {
        onError?.call('해당 시리얼 넘버의 키트가 없습니다.');
      }else {
        onError?.call('회원가입 실패! 다시 시도해 주세요');
        print(response.statusCode);
        print('sign up fail!!!');
      }
    }catch(e){
      print(body);
      print("error!!");
      print(e.runtimeType);
    }
  }
}
