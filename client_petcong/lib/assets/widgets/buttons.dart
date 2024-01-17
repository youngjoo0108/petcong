import 'package:flutter/material.dart';
import 'package:petcong/assets/style.dart';

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

class RoundGradientXButton extends StatelessWidget {
  const RoundGradientXButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _RoundGradientXButtonPainter(),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(50.0),
        child: const Padding(
          padding: EdgeInsets.all(5.0),
          child: Icon(
            Icons.clear_rounded, // "X" 아이콘으로 변경
            size: 50,
            color: Colors.red,
            weight: 50,
          ),
        ),
      ),
    );
  }
}

class _RoundGradientXButtonPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..shader = const LinearGradient(
        colors: [
          MyColor.myColor4,
          MyColor.myColor3,
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromCircle(
          center: size.center(Offset.zero), radius: size.width / 2.0));

    const double strokeWidth = 5.0;
    final Rect rect = Rect.fromCircle(
        center: size.center(Offset.zero),
        radius: size.width / 2.0 - strokeWidth / 2.0);
    canvas.drawCircle(rect.center, rect.width / 2.0, paint);

    final Paint innerCirclePaint = Paint()..color = Colors.white;
    final Rect innerCircleRect = Rect.fromCircle(
        center: size.center(Offset.zero),
        radius: size.width / 2.0 - strokeWidth);
    canvas.drawCircle(
        innerCircleRect.center, innerCircleRect.width / 2.0, innerCirclePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
