import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../widgets/common_widgets/base_app_bar.dart';
import '../../../widgets/common_widgets/drawer.dart';

class CarouselImgScreen5 extends StatefulWidget {
  const CarouselImgScreen5({super.key});

  @override
  State<CarouselImgScreen5> createState() => _CarouselImgScreen5State();
}

class _CarouselImgScreen5State extends State<CarouselImgScreen5> {
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
              Text('carousel 5'),
              Container(
                width: MediaQuery.of(context).size.width - 30.0,
                // width: 300,
                child: Image.asset(
                  'assets/PNG/Test_img_1.png',
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
