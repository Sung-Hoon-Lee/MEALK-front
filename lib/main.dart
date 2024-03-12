
import 'package:eco_mealworm_farm/screens/admin_screens/admin_main_screen.dart';
import 'package:flutter/material.dart';
import 'package:eco_mealworm_farm/screens/splash_screen.dart';
import 'package:eco_mealworm_farm/screens/terms_of_service_screen.dart';
import 'package:eco_mealworm_farm/screens/login_screen.dart';
import 'package:eco_mealworm_farm/screens/signup_screen.dart';
import 'package:eco_mealworm_farm/screens/user_screens/user_main_screen.dart';
import 'package:eco_mealworm_farm/screens/user_screens/CarouselScreen/carousel_img_screen_1.dart';
import 'package:eco_mealworm_farm/screens/user_screens/CarouselScreen/carousel_img_screen_2.dart';
import 'package:eco_mealworm_farm/screens/user_screens/CarouselScreen/carousel_img_screen_3.dart';
import 'package:eco_mealworm_farm/screens/user_screens/CarouselScreen/carousel_img_screen_4.dart';
import 'package:eco_mealworm_farm/screens/user_screens/CarouselScreen/carousel_img_screen_5.dart';
import 'package:eco_mealworm_farm/screens/user_screens/photo_screen.dart';
import 'package:eco_mealworm_farm/screens/user_screens/reward_screen.dart';
import 'package:eco_mealworm_farm/screens/user_screens/my_page_screen.dart';
import 'package:eco_mealworm_farm/screens/user_screens/gallery_screen.dart';
import 'package:eco_mealworm_farm/screens/user_screens/point_exchange_state.dart';
import 'package:eco_mealworm_farm/screens/user_screens/rewrite_mypage_screen.dart';
import 'package:eco_mealworm_farm/screens/admin_screens/user_info/info_user_list.dart';
import 'package:eco_mealworm_farm/screens/admin_screens/user_info/user_detail.dart';
import 'package:eco_mealworm_farm/screens/admin_screens/user_info/modify_user_detail.dart';
import 'package:eco_mealworm_farm/screens/admin_screens/confirm_picture_and_give_point/picture_user_list.dart';
import 'package:eco_mealworm_farm/screens/admin_screens/confirm_picture_and_give_point/picture_list.dart';
import 'package:eco_mealworm_farm/screens/admin_screens/confirm_picture_and_give_point/confirm_picture.dart';
import 'package:eco_mealworm_farm/screens/admin_screens/manage_reward_order/order_user_list.dart';
import 'package:eco_mealworm_farm/screens/admin_screens/manage_reward_order/change_order_status.dart';
import 'package:eco_mealworm_farm/screens/admin_screens/user_point_status/status_user_list.dart';
import 'package:eco_mealworm_farm/screens/admin_screens/user_point_status/status_detail.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: SplashScreen(),
    routes: {
      // -------------------- user screens --------------------
      'terms': (context) => TermsOfServiceScreen(),
      'login': (context) => LoginScreen(),
      'signup': (context) => SignUpScreen(),
      'userMain' : (context) => UserMainScreen(),
      'carousel1' : (context) => CarouselImgScreen1(),
      'carousel2' : (context) => CarouselImgScreen2(),
      'carousel3' : (context) => CarouselImgScreen3(),
      'carousel4' : (context) => CarouselImgScreen4(),
      'carousel5' : (context) => CarouselImgScreen5(),
      'photo' : (context) => PhotoScreen(),
      'reward' : (context) => RewardScreen(),
      'mypage' : (context) => MyPageScreen(),
      'rMypage' : (context) => RewriteMypageScreen(),
      'gallery' : (context) => GalleryScreen(),
      'point' : (context) => PointExchangeState(),

      // -------------------- admin screens --------------------
      'adminMain' : (context) => AdminMainScreen(),

      // 회원정보
      'infoUserList' : (context) => InfoUserList(),
      'userDetail': (context) => UserDetail(),
      'modify' : (context) => ModifyUserDetail(),

      // 사진 확인 및 포인트 지급
      'pictureUserList' : (context) => PointUserList(),
      'pictureList' : (context) => PictureList(),
      'confirm' : (context) => ConfirmPicture(),

      // 리워드 주문 관리
      'orderUserList' : (context) => OrderUserList(),
      'changeOrderStatus' : (context) => ChangeOrderStatus(),

      // 포인트 상태 확인
      'statusUserList' : (context) => StatusUserList(),
      'statusDetail' : (context) => StatusDetail(),
    },
  ));
}

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: const MyHomePage(title: 'Flutter Demo Home Page'),
//     );
//   }
// }
//
// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});
//
//   final String title;
//
//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   int _counter = 0;
//
//   void _incrementCounter() {
//     setState(() {
//       _counter++;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         title: Text(widget.title),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             const Text(
//               'You have pushed the button this many times:',
//             ),
//             Text(
//               '$_counter',
//               style: Theme.of(context).textTheme.headlineMedium,
//             ),
//             IconButton(
//               onPressed: () {
//                 const confirmPopup().myDialog(context);
//               },
//               icon: const Icon(Icons.bubble_chart_outlined),
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _incrementCounter,
//         tooltip: 'Increment',
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }
