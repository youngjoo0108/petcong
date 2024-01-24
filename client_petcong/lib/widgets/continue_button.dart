import 'package:flutter/material.dart';
import 'package:petcong/constants/style.dart';

class ContinueButton extends StatelessWidget {
  const ContinueButton({Key? key, required this.isFilled}) : super(key: key);

  final bool isFilled;

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
          minimumSize: const Size(500.0, 30.0), // 가로 길이와 세로 길이를 조절
        ),
        onPressed: () {},
        child: const Padding(
          padding: EdgeInsets.only(
            top: 6,
            bottom: 6,
          ),
          child: Text(
            "Continue",
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
            ),
          ),
        ),
      ),
    );
  }
}
