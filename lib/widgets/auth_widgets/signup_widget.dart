import 'package:flutter/material.dart';
import 'package:eco_mealworm_farm/utils/signup_controller.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SignUpWidget extends StatefulWidget {
  @override
  _SignUpWidgetState createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget> {
  final TextEditingController idController = TextEditingController();
  final TextEditingController idCheckController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordCheckController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController birthController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController serialNumberController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  final SignUpController signInController = SignUpController();

  String? passwordCheckError;

  void _passwordValidate() {
    if (passwordController.text != passwordCheckController.text) {
      setState(() {
        passwordCheckError = '비밀번호가 일치하지 않습니다.';
      });
    }
    if (passwordController.text == passwordCheckController.text) {
      setState(() {
        passwordCheckError = null;
      });
    }
  }

  String? idCheckError;

  void _idValidate() {
    if (idController.text != passwordCheckController.text) {
      setState(() {
        passwordCheckError = '비밀번호가 일치하지 않습니다.';
      });
    }
    if (passwordController.text == passwordCheckController.text) {
      setState(() {
        passwordCheckError = null;
      });
    }
  }

  int statusCode = 0;
  bool idCheck = false;

  // id 중복 확인을 위한 geUserInfo
  Future<void> checkIdExist() async{
    print("checkIdExist start");
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    final uri = Uri.parse('http://15.164.251.76:8091/api/users/id-availability/${idController.text}');

    try{
      final response = await http.post(uri);
      statusCode = response.statusCode;
      print('statusCode : $statusCode');

      // String? responseBody = response.body;
      // Map<String, dynamic> jsonMap = json.decode(responseBody);

      if(statusCode == 200){
        if(response.body == 'true'){
          setState(() {
            idCheck = true;
          });
        }
        if(response.body == 'false'){
          setState(() {
            idCheck = false;
          });
        }
        print('idCheck : $idCheck');
      }
    }catch(e){
      print("error!!");
      print(e.runtimeType);
    }
  }



  FocusNode _phoneNumberFocus = FocusNode();
  String _phoneNumberError = '';

  // 전화번호 입력 유효성 검사
  String validatePhoneNumber(String value) {
    RegExp regex = RegExp(r'^\d{3}-\d{4}-\d{4}$');
    if (regex.hasMatch(value)) {
      return '유효한 형식입니다.';
    } else {
      return '올바른 전화번호 형식이 아닙니다.';
    }
  }

  // 성별 선택
  String? _selectedGender;
  List<String> _genders = ['남자', '여자'];

  Color backgroundColor = const Color.fromRGBO(196, 232, 181, 0.9);
  Color buttonColor = const Color.fromRGBO(94, 130, 87, 1.0);
  TextStyle titleFontStyle = const TextStyle(fontSize: 32, fontFamily: 'NotoSansKR', fontWeight: FontWeight.w900, color: Color.fromRGBO(94, 130, 87, 1.0));
  TextStyle stringFontStyle = const TextStyle(fontSize: 16, fontFamily: 'NotoSansKR', fontWeight: FontWeight.w900, color: Color.fromRGBO(94, 130, 87, 1.0));
  TextStyle buttonFontStyle = const TextStyle(fontSize: 26, fontFamily: 'NotoSansKR', fontWeight: FontWeight.w900, color: Colors.white);
  TextStyle termsTitlesFontStyle = const TextStyle(fontSize: 20, fontFamily: 'NotoSansKR', fontWeight: FontWeight.w900, color: Color.fromRGBO(94, 130, 87, 1.0));
  TextStyle termsContentsFontStyle = const TextStyle(fontSize: 16, fontFamily: 'NotoSansKR', fontWeight: FontWeight.w900, color: Color.fromRGBO(94, 130, 87, 1.0));


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children:[
              // SizedBox(width: 16,),
              Container(
                width: 264.0,
                child:
                TextField(
                  controller: idController,
                  decoration:
                    const InputDecoration(
                      labelText: '아이디',
                      hintText: '8글자 제한',

                    ),
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(8),
                  ],
                ),
              ),
              SizedBox(width: 20,),
              Container(
                width: 60,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor,
                    // foregroundColor: Colors.white,
                  ),
                  onPressed: () async{
                    await checkIdExist();
                    idCheck == true ? idController.clear() : null;
                    idCheck == true
                    ? showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          // backgroundColor: Color.fromRGBO(196, 232, 181, 1.0 ),
                            content: Container(
                              height: 100,
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '이미 존재하는 아이디 입니다.',
                                      style: TextStyle(fontSize: 22, fontFamily: 'NotoSansKR', fontWeight: FontWeight.w900, color: Color.fromRGBO(94, 130, 87, 1.0)),
                                      textAlign: TextAlign.center,
                                    ),
                                  ]
                              ),
                            )
                        );
                      },

                    )
                    : showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          // backgroundColor: Color.fromRGBO(196, 232, 181, 1.0 ),
                            content: Container(
                              height: 100,
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '사용 가능한 아이디 입니다.',
                                      style: TextStyle(fontSize: 22, fontFamily: 'NotoSansKR', fontWeight: FontWeight.w900, color: Color.fromRGBO(94, 130, 87, 1.0)),
                                      textAlign: TextAlign.center,
                                    ),
                                  ]
                              ),
                            )
                        );
                      },
                    );
                  },
                  child: Text('중복\n확인'),
                ),
              ),
            ]
          ),
          const SizedBox(height: 16.0),
          TextField(
            controller: passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: '비밀번호',
              hintText: '10글자 제한',
            ),
            inputFormatters: [
              LengthLimitingTextInputFormatter(10),
            ],
          ),
          const SizedBox(height: 16.0),
          TextField(
            controller: passwordCheckController,
            obscureText: true,
            decoration: InputDecoration(
              labelText: '비밀번호 확인',
              hintText: '10글자 제한',
              errorText: passwordCheckError,
            ),
            inputFormatters: [
              LengthLimitingTextInputFormatter(10),
            ],
            onChanged: (value) => {
              _passwordValidate(),
            },
          ),
          const SizedBox(height: 16.0),
          TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: '이름'),
          ),
          const SizedBox(height: 16.0),
          TextField(
            controller: birthController,
            keyboardType: TextInputType.number,
            decoration:
              const InputDecoration(
                labelText: '생년월일',
                hintText: '2000-01-01',
              ),
          ),
          const SizedBox(height: 16.0),
          // TextField(
          //   controller: genderController,
          //   keyboardType: TextInputType.values[0],
          //   decoration: const InputDecoration(labelText: '성별'),
          // ),
          DropdownButtonFormField(
            value: _selectedGender,
            items: _genders.map((String gender) {
              return DropdownMenuItem(
                value: gender == '남자' ? 'MALE' : 'FEMALE',
                child: Text(gender),
              );
            }).toList(),
            onChanged: (String? value) {
              setState(() {
                _selectedGender = value;
                genderController.text = value!;
              });
            },
            decoration: const InputDecoration(
              labelText: '성별',
              hintText: '성별을 선택하세요',
            ),
          ),
          const SizedBox(height: 16.0),
          TextField(
            controller: phoneNumberController,
            focusNode: _phoneNumberFocus,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: '전화번호',
              hintText: '010-1234-5678',
              // errorText: _phoneNumberError,
            ),
            inputFormatters: [
              LengthLimitingTextInputFormatter(14),
            ],
            // onChanged: (value) {
            //   setState(() {
            //     _phoneNumberError = validatePhoneNumber(value);
            //   });
            // },
          ),
          const SizedBox(height: 16.0),
          TextField(
            controller: serialNumberController,
            decoration: const InputDecoration(labelText: '일련번호', hintText: '0000-0000',),
            inputFormatters: [
              LengthLimitingTextInputFormatter(9),
            ],
          ),
          const SizedBox(height: 16.0),
          TextField(
            controller: addressController,
            maxLines: 2,
            decoration:
              const InputDecoration(
                labelText: '주소',
              ),
          ),
          const SizedBox(height: 24.0),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: buttonColor,
              onPrimary: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ), //테두리
            ),
            onPressed: () {
              signInController.signUp(
                idController.text,
                passwordController.text,
                nameController.text,
                birthController.text,
                genderController.text,
                phoneNumberController.text,
                serialNumberController.text,
                addressController.text,
                onSuccess: () {
                  // 회원가입 성공 시 처리
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('회원가입 성공')),
                  );
                  Navigator.pushNamed(context, 'login');
                },
                onError: (error) {
                  // 회원가입 실패 시 처리
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('회원가입 실패: $error')),
                  );
                },
              );
            },
            child: Text(' 회원가입하기 ', style: buttonFontStyle,),
          ),
          // ElevatedButton(
          //   onPressed: () {
          //     signInController.signUp(
          //       idController.text,
          //       passwordController.text,
          //       nameController.text,
          //       birthController.text,
          //       genderController.text,
          //       phoneNumberController.text,
          //       serialNumberController.text,
          //       addressController.text,
          //       onSuccess: () {
          //         // 회원가입 성공 시 처리
          //         ScaffoldMessenger.of(context).showSnackBar(
          //           const SnackBar(content: Text('회원가입 성공')),
          //         );
          //         Navigator.pushNamed(context, 'login');
          //       },
          //       onError: (error) {
          //         // 회원가입 실패 시 처리
          //         ScaffoldMessenger.of(context).showSnackBar(
          //           SnackBar(content: Text('회원가입 실패: $error')),
          //         );
          //       },
          //     );
          //   },
          //   child: const Text('회원가입'),
          // ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    idController.dispose();
    passwordController.dispose();
    passwordCheckController.dispose();
    nameController.dispose();
    birthController.dispose();
    genderController.dispose();
    phoneNumberController.dispose();
    serialNumberController.dispose();
    addressController.dispose();
    super.dispose();
  }
}



class PhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    if (newValue.text.length > 3 &&
        newValue.text.contains(RegExp(r'^\d{3}$'))) {
      return TextEditingValue(
        text: '${newValue.text}-',
        selection: TextSelection.collapsed(offset: newValue.text.length + 1),
      );
    } else if (newValue.text.length > 8 &&
        newValue.text.contains(RegExp(r'^\d{3}-\d{4}$'))) {
      return TextEditingValue(
        text: '${newValue.text}-',
        selection: TextSelection.collapsed(offset: newValue.text.length + 1),
      );
    }
    return newValue;
  }
}
