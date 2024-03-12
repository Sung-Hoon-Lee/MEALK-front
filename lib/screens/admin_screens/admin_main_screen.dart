import 'package:eco_mealworm_farm/widgets/admin_widgets/admin_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../widgets/common_widgets/base_app_bar.dart';
import '../../widgets/common_widgets/drawer.dart';

class AdminMainScreen extends StatelessWidget {
  const AdminMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _adminScaffoldKey = GlobalKey<ScaffoldState>();

    final String font = 'NotoSansKR';

    return Scaffold(
      key: _adminScaffoldKey,
      appBar: AdminAppBar(scaffoldKey: _adminScaffoldKey),
      // appBar: BaseAppBar(),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 다른 내용을 추가하거나 수정할 수 있습니다.
              const SizedBox(height: 80),
              Container(
                width: 370,
                height: 550,
                // decoration: BoxDecoration(
                //   border: Border.all(
                //     width: 2,
                //     color: Colors.black,
                //   ),
                //   borderRadius: BorderRadius.all(Radius.circular(5),),
                // ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 32,),
                    Container(
                      width: 240,
                      height: 64,
                      child:
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: const Color.fromRGBO(94, 130, 87, 1.0), // 버튼의 배경색
                          onPrimary: Colors.white, // 버튼의 텍스트 및 아이콘 색상
                          textStyle: TextStyle(
                            fontSize: 16,
                            fontFamily: font,
                            fontWeight: FontWeight.w900),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        onPressed: (){
                          Navigator.pushNamed(context, 'infoUserList');
                        },
                        child: const Text('회원정보', style: TextStyle(fontSize: 24),),
                      ),
                    ),
                    const SizedBox(height: 32,),
                    Container(
                      width: 240,
                      height: 64,
                      child:
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: const Color.fromRGBO(94, 130, 87, 1.0), // 버튼의 배경색
                          onPrimary: Colors.white, // 버튼의 텍스트 및 아이콘 색상
                          textStyle: TextStyle(
                              fontSize: 16,
                              fontFamily: font,
                              fontWeight: FontWeight.w900),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        onPressed: (){
                          Navigator.pushNamed(context, 'pictureUserList');
                        },
                        child: const Text('사진 확인 및 포인트 지급', style: TextStyle(fontSize: 20),),
                      ),
                    ),
                    const SizedBox(height: 32,),
                    Container(
                      width: 240,
                      height: 64,
                      child:
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: const Color.fromRGBO(94, 130, 87, 1.0), // 버튼의 배경색
                          onPrimary: Colors.white, // 버튼의 텍스트 및 아이콘 색상
                          textStyle: TextStyle(
                              fontSize: 16,
                              fontFamily: font,
                              fontWeight: FontWeight.w900),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        onPressed: (){
                          Navigator.pushNamed(context, 'statusUserList');
                        },
                        child: const Text('포인트 상태 확인', style: TextStyle(fontSize: 24),),
                      ),
                    ),
                    const SizedBox(height: 32,),
                    Container(
                      width: 240,
                      height: 64,
                      child:
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: const Color.fromRGBO(94, 130, 87, 1.0), // 버튼의 배경색
                          onPrimary: Colors.white, // 버튼의 텍스트 및 아이콘 색상
                          textStyle: TextStyle(
                              fontSize: 16,
                              fontFamily: font,
                              fontWeight: FontWeight.w900),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        onPressed: (){
                          Navigator.pushNamed(context, 'orderUserList');
                        },
                        child: const Text('리워드 주문 관리', style: TextStyle(fontSize: 24),),
                      ),
                    ),
                    const SizedBox(height: 32,),
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
