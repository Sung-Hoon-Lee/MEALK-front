// user_main_screen.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:eco_mealworm_farm/widgets/common_widgets/base_app_bar.dart';
import 'package:eco_mealworm_farm/widgets/common_widgets/drawer.dart';
import 'package:eco_mealworm_farm/widgets/user_widgets/carousel_slider.dart' as carousel;

class UserMainScreen extends StatelessWidget {
  const UserMainScreen({Key? key});

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
              const SizedBox(height: 0),
              const carousel.CarouselSliderWidget(),
              const SizedBox(height: 10),

              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 200,
                    height: 72,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color.fromRGBO(96, 178, 64, 0.9), // 테두리 색상
                        width: 1.5, // 테두리 두께
                      ),
                      borderRadius: BorderRadius.circular(10.0), // 테두리 둥근 모서리
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: const Color.fromRGBO(243, 255, 235, 0.9), // 버튼의 배경색
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      onPressed: (){
                        Navigator.pushNamed(context,'photo');
                      },
                      child: const Text('밀웜 키우기', style: TextStyle(fontSize: 17, color: Color.fromRGBO(96, 178, 64, 0.9))),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 12,),
              // 포인트 확인하기 버튼
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 200,
                    height: 72,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color.fromRGBO(96, 178, 64, 0.9), // 테두리 색상
                        width: 1.5, // 테두리 두께
                      ),
                      borderRadius: BorderRadius.circular(10.0), // 테두리 둥근 모서리
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: const Color.fromRGBO(243, 255, 235, 0.9), // 버튼의 배경색
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      onPressed: (){
                        Navigator.pushNamed(context,'point');
                      },
                      child: const Text('포인트 확인하기', style: TextStyle(fontSize: 17, color: Color.fromRGBO(96, 178, 64, 0.9))),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12,),

              // 리워드 신청하기 버튼
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 200,
                    height: 72,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color.fromRGBO(96, 178, 64, 0.9), // 테두리 색상
                        width: 1.5, // 테두리 두께
                      ),
                      borderRadius: BorderRadius.circular(10.0), // 테두리 둥근 모서리
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: const Color.fromRGBO(243, 255, 235, 0.9), // 버튼의 배경색
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      onPressed: (){
                        Navigator.pushNamed(context,'reward');
                      },
                      child: const Text('리워드 신청하기', style: TextStyle(fontSize: 17, color: Color.fromRGBO(96, 178, 64, 0.9))),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
