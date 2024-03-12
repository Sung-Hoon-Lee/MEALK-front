import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class confirmPopup extends StatelessWidget {
  const confirmPopup({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: IconButton(
          onPressed: () {
            myDialog(context);
          },
          icon: const Icon(Icons.bubble_chart_outlined),
        ),
      ),
    );
  }

  void myDialog(context) {
    showDialog(
      context: context,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(),
          child:
            Dialog(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(

                  child: Column(
                    children: [
                      Container(
                        width: double.maxFinite,
                        height: 80,
                        alignment: Alignment.center,
                        child: Text("상품 구매", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
                      ),
                      Container(
                        width: double.maxFinite,
                        height: 70,
                        alignment: Alignment.center,
                        child: Text("따뜻한 핫팩 \n 상품 구매 완료", style: TextStyle(fontSize: 20), textAlign: TextAlign.center),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            height: 80,

                            child: TextButton(
                              child: Text("상품 구매", style: TextStyle(fontSize: 20)),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ),
                          Container(
                            child: TextButton(
                              child: Text("취 소", style: TextStyle(fontSize: 20)),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ),
                        ],
                      ),
                      // const Text("팝업이다."),
                      // IconButton(
                      //   onPressed: () {
                      //     Navigator.of(context).pop();
                      //   },
                      //   icon: const Icon(Icons.close),
                      // )
                    ],
                  ),
                ),

              ],
            ),
          ),
        );
      },
    );
  }
}
