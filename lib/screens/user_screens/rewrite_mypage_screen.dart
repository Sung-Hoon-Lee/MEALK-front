import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../widgets/common_widgets/base_app_bar.dart';
import '../../widgets/common_widgets/drawer.dart';

class RewriteMypageScreen extends StatefulWidget {
  const RewriteMypageScreen({super.key});

  @override
  State<RewriteMypageScreen> createState() => _RewriteMypageScreenState();
}

class _RewriteMypageScreenState extends State<RewriteMypageScreen> {
  // TextEditingController? phoneController;
  // TextEditingController? addressController;
  // TextEditingController? birthController;
  // TextEditingController? genderController;
  TextEditingController? phoneController = TextEditingController();
  TextEditingController? addressController = TextEditingController();
  TextEditingController? birthController = TextEditingController();
  TextEditingController? genderController = TextEditingController();

  String? _selectedGender;
  final List<String> _genders = ['남성', '여성'];

  String? name;
  String? birth;
  String? gender;
  String? phoneNumber;
  String? address;
  int? point;

  int statusCode = 0;
  String accessToken = "";

  String responseData = "";
  Map responseMap = Map<String, dynamic>();

  // Future<void> setUserInfo() async{
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //     birth = prefs.getString('birth');
  //     gender = prefs.getString('gender');
  //     phoneNumber = prefs.getString('phoneNumber');
  //     address = prefs.getString('address');
  //     phoneController?.text = phoneNumber ?? '';
  //     addressController?.text = address ?? '';
  //     birthController?.text = birth ?? '';
  //
  //     if(gender == 'MALE'){
  //       setState(() {
  //         _selectedGender = '남성';
  //         gender = '남성';
  //       });
  //       }else{
  //       setState(() {
  //         _selectedGender = '여성';
  //         gender = '여성';
  //       });
  //     }
  //   print('userInfo $birth $gender $phoneNumber $address');
  // }
  void getUserData() async{
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
          phoneNumber = responseMap["phoneNumber"];
          birth = responseMap["birth"];
          gender = responseMap["gender"];
          address = responseMap["address"];
          point = responseMap["point"];

          phoneController?.text = phoneNumber ?? '';
              addressController?.text = address ?? '';
              birthController?.text = birth ?? '';

              if(gender == 'MALE'){
                setState(() {
                  _selectedGender = '남성';
                  gender = '남성';
                });
                }else {
                setState(() {
                  _selectedGender = '여성';
                  gender = '여성';
                });
              }
        });
      }
    }catch(e){
      print("error!!");
      print(e.runtimeType);
    }
  }
  final FocusNode _phoneNumberFocus = FocusNode();
  String _phoneNumberError = '';
  String? validatePhoneNumber(String value) {
    RegExp regex = RegExp(r'^\d{3}-\d{4}-\d{4}$');
    if (regex.hasMatch(value)) {
      return null;
    } else {
      return '올바른 전화번호 형식이 아닙니다.';
    }
  }

  Future<void> patchUserInfo() async{
    print("patchUserInfo start");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String accessToken = prefs.getString('accessToken')!;
    String id = prefs.getString('id')!;
    final uri = Uri.parse('http://15.164.251.76:8091/api/users/$id');
    final headers = {'Authorization': '$accessToken', 'Content-Type': 'application/json'};
    final body = jsonEncode({'birth': birthController?.text, 'phoneNumber': phoneController?.text, 'address': addressController?.text}, );

    try{
      final response = await http.patch(uri, headers: headers, body: body);
      setState(() {
        statusCode = response.statusCode;
      });
      print('orderStatusCode : ${response.statusCode}');
      print(response.body);

      if(statusCode == 200){
        print('patchUserInfo request succeed');
      }
    }catch(e){
      print("patchUserInfo error!!");
      print(e.runtimeType);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
    // setUserInfo().then((_) {
    //   phoneController = TextEditingController(text: phoneNumber ?? '네트워크 에러');
    //   addressController = TextEditingController(text: address ?? '네트워크 에러');
    //   birthController = TextEditingController(text: birth ?? '네트워크 에러');
    //   genderController = TextEditingController(text: gender ?? '네트워크 에러');

      // _selectedGender = gender;
    // });
  }



  Color fontColor = const Color.fromRGBO(94, 130, 87, 1.0);
  String fontFamily = 'NotoSansKR';
  TextStyle dataFontStyle = const TextStyle(fontSize: 20, fontFamily: 'NotoSansKR', fontWeight: FontWeight.w900, color: Color.fromRGBO(94, 130, 87, 1.0));



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
              const SizedBox(height: 48.0),
              Text('내 정보 수정', style: TextStyle(fontSize: 28, fontFamily: 'NotoSansKR', fontWeight: FontWeight.w900, color: fontColor)),
              const SizedBox(height: 48.0),
              Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(width: 24,),
                    Text('[ 나의 정보 ]', style: TextStyle(fontSize: 20, fontFamily: 'NotoSansKR', fontWeight: FontWeight.w900, color: fontColor),),
                  ]
              ),
              SizedBox(height: 8,),
              Container(
                width: 350,
                height: 440,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 2,
                    color: fontColor,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(5),),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 32,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: 130,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const SizedBox(width: 32,),
                              Text('전화번호  :  ', style: dataFontStyle,),
                            ],
                          ),
                        ),
                        Container(
                          width: 180,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                width: 140,
                                child: TextField(
                                  controller: phoneController,
                                  // focusNode: _phoneNumberFocus,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Color.fromRGBO(94, 130, 87, 1.0),), // 일반 상태에서의 밑줄 색상
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Color.fromRGBO(196, 232, 181, 0.9),), // 포커스 상태에서의 밑줄 색상
                                    ),
                                    // errorText: _phoneNumberError,
                                  ),
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(14),
                                    // PhoneNumberFormatter(),
                                  ],
                                  // onChanged: (value) {
                                  //   setState(() {
                                  //     _phoneNumberError = validatePhoneNumber(value) ?? '';
                                  //   });
                                  // },
                                ),
                              )
                              // Text('$phoneNumber', style: dataFontStyle),
                            ],
                          ),
                        ),
                        // Text(''),
                      ],
                    ),
                    const SizedBox(height: 16,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: 130,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const SizedBox(width: 32,),
                              Text('주소  :  ', style: dataFontStyle,),
                            ],
                          ),
                        ),
                        Container(
                          width: 180,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                width: 140,
                                child: TextField(
                                  controller: addressController,
                                  minLines: 1,
                                  maxLines: 3,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Color.fromRGBO(94, 130, 87, 1.0),), // 일반 상태에서의 밑줄 색상
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Color.fromRGBO(196, 232, 181, 0.9),), // 포커스 상태에서의 밑줄 색상
                                    ),
                                  ),

                                ),
                              )
                            ],
                          ),
                        ),
                        Text(''),
                      ],
                    ),
                    const SizedBox(height: 16,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: 130,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const SizedBox(width: 32,),
                              Text('생년월일  :  ', style: dataFontStyle,),
                            ],
                          ),
                        ),
                        Container(
                          width: 180,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                width: 140,
                                child: TextField(
                                  controller: birthController,
                                  decoration: const InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Color.fromRGBO(94, 130, 87, 1.0),), // 일반 상태에서의 밑줄 색상
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Color.fromRGBO(196, 232, 181, 0.9),), // 포커스 상태에서의 밑줄 색상
                                    ),

                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16,),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.start,
                    //   children: [
                    //     Container(
                    //       width: 130,
                    //       child: Row(
                    //         mainAxisAlignment: MainAxisAlignment.end,
                    //         children: [
                    //           const SizedBox(width: 32,),
                    //           Text('성별  :  ', style: dataFontStyle,),
                    //         ],
                    //       ),
                    //     ),
                    //     Container(
                    //       width: 180,
                    //       child: Row(
                    //         mainAxisAlignment: MainAxisAlignment.start,
                    //         children: [
                    //           Container(
                    //             width: 140,
                    //             // child: TextField(
                    //             //   controller: genderController,
                    //             //   decoration: InputDecoration(
                    //             //     enabledBorder: const UnderlineInputBorder(
                    //             //       borderSide: BorderSide(color: Color.fromRGBO(94, 130, 87, 1.0),), // 일반 상태에서의 밑줄 색상
                    //             //     ),
                    //             //     focusedBorder: const UnderlineInputBorder(
                    //             //       borderSide: BorderSide(color: Color.fromRGBO(196, 232, 181, 0.9),), // 포커스 상태에서의 밑줄 색상
                    //             //     ),
                    //             //     errorText: _genderError,
                    //             //   ),
                    //             //   onChanged: (value){
                    //             //     setState(() {
                    //             //       _selectedGender = value;
                    //             //       genderController?.text = value!;
                    //             //     });
                    //             //   },
                    //             // ),
                    //
                    //             child: DropdownButtonFormField(
                    //               value: _selectedGender,
                    //               items: _genders.map((String gender) {
                    //                 return DropdownMenuItem(
                    //                   // value: gender == '남성' ? 'MALE' : 'FEMALE',
                    //                   value: gender,
                    //                   child: Text(gender),
                    //                 );
                    //               }).toList(),
                    //               onChanged: (String? value) {
                    //                 setState(() {
                    //                   _selectedGender = value;
                    //                   genderController?.text = value!;
                    //                 });
                    //               },
                    //               decoration: const InputDecoration(
                    //                 hintText: '성별을 선택하세요',
                    //               ),
                    //             ),
                    //           )
                    //         ],
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: 130,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SizedBox(width: 32,),
                              Text('성별  :  ', style: dataFontStyle,),
                            ],
                          ),
                        ),
                        Container(
                          width: 180,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text('$gender', style: dataFontStyle),
                            ],
                          ),
                        ),
                        Text(''),
                      ],
                    ),
                    const SizedBox(height: 64,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 112,
                          height: 40,
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
                            onPressed: () async{
                              // Navigator.pushNamed(context,'photo');
                              await patchUserInfo();
                              ScaffoldMessenger.of(context).showSnackBar(
                                  statusCode == 200
                                    ? const SnackBar(
                                      content: Text('저장 성공'),
                                      backgroundColor: Color.fromRGBO(196, 232, 181, 0.9),
                                    )
                                    : const SnackBar(
                                      content: Text('저장 실패!'),
                                      backgroundColor: Colors.red,
                                    ),
                              );
                              Navigator.pop(context);
                            },
                            child: Text('저장하기', style: dataFontStyle,),
                          ),
                        ),
                      ],
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

  // @override
  // void dispose() {
  //   // TODO: implement dispose
  //   phoneController?.dispose();
  //   _phoneNumberFocus.dispose();
  //   super.dispose();
  // }
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
