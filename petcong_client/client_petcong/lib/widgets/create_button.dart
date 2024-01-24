import 'package:flutter/material.dart';
import 'package:petcong/constants/style.dart';

class RoundGradientPlusButton extends StatelessWidget {
  const RoundGradientPlusButton({Key? key}) : super(key: key);

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
        onTap: () {},
        borderRadius: BorderRadius.circular(50.0), // 반지름을 절반으로 설정
        child: const Padding(
          padding: EdgeInsets.all(5.0),
          child: Icon(
            Icons.add_rounded,
            size: 50,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
