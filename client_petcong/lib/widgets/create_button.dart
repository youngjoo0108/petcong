import 'package:flutter/material.dart';
import 'package:petcong/constants/style.dart';

class RoundGradientPlusButton extends StatelessWidget {
  final VoidCallback onTap; // onTap 콜백을 추가하였습니다.

  const RoundGradientPlusButton({Key? key, required this.onTap})
      : super(key: key); // onTap 콜백을 받아옵니다.

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            MyColor.myColor4,
            MyColor.myColor3,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle, // 동그라미 모양 설정
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.57),
            blurRadius: 5,
          )
        ],
      ),
      child: InkWell(
        onTap: onTap, // onTap 콜백을 InkWell의 onTap으로 설정하였습니다.
        borderRadius: BorderRadius.circular(5.0), // 반지름을 절반으로 설정
        child: const Padding(
          padding: EdgeInsets.all(5.0),
          child: Icon(
            Icons.add_rounded,
            size: 20,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
