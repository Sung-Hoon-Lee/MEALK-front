import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;
  final Color buttonColor;
  final Color textColor;
  final double buttonWidth;
  final double buttonHeight;

  CustomButton({
    required this.buttonText,
    required this.onPressed,
    this.buttonColor = Colors.blue,
    this.textColor = Colors.white,
    this.buttonWidth = 50.0, // 기본값은 무제한
    this.buttonHeight = 30.0, // 기본값은 30.0
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: buttonWidth,
      height: buttonHeight,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          primary: buttonColor,
          onPrimary: textColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20), //모서리
              // side: BorderSide(color: Colors.black)
          ), //테두리
        ),
        child: Text(buttonText),
      ),
    );
  }
}
