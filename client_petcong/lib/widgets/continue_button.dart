import 'package:flutter/material.dart';
import 'package:petcong/constants/style.dart';

class ContinueButton extends StatelessWidget {
  const ContinueButton({
    Key? key,
    required this.isFilled,
    required this.buttonText,
    this.onPressed,
    this.width = 240.0, // width 속성 추가
    this.height = 30.0, // height 속성 추가
  }) : super(key: key);

  final bool isFilled;
  final String buttonText;
  final VoidCallback? onPressed;
  final double width; // width 속성 추가
  final double height; // height 속성 추가

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: isFilled
            ? const LinearGradient(
                colors: [
                  MyColor.myColor4,
                  MyColor.myColor3,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : const LinearGradient(
                colors: [
                  Colors.grey,
                  Colors.grey,
                ],
              ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: isFilled
            ? [
                const BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.57),
                  blurRadius: 5,
                )
              ]
            : null,
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          disabledForegroundColor: Colors.transparent.withOpacity(0.38),
          disabledBackgroundColor: Colors.transparent.withOpacity(0.12),
          shadowColor: Colors.transparent,
          minimumSize: Size(width, height), // minimumSize 수정
        ),
        onPressed: onPressed,
        child: Padding(
          padding: const EdgeInsets.only(
            top: 6,
            bottom: 6,
          ),
          child: Text(
            buttonText,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
