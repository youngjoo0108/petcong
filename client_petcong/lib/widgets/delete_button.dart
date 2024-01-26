import 'package:flutter/material.dart';
import 'package:petcong/constants/style.dart';

class RoundGradientXButton extends StatelessWidget {
  final VoidCallback onTap;

  const RoundGradientXButton({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _RoundGradientXButtonPainter(),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(5.0),
        child: const Padding(
          padding: EdgeInsets.all(5.0),
          child: Icon(
            Icons.clear_rounded, // "X" 아이콘으로 변경
            size: 20,
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
