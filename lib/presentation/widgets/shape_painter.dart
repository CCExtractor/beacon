import 'package:flutter/cupertino.dart';
import '../../core/utils/constants.dart';

class ShapePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();

    paint.color = kBlue;
    paint.style = PaintingStyle.fill;
    var path = Path();

    path.moveTo(0, size.height * 0.05);
    path.lineTo(size.width * 0.11, size.height * 0.22);
    path.quadraticBezierTo(size.width * 0.13, size.height * 0.25,
        size.width * 0.18, size.height * 0.24);
    path.quadraticBezierTo(size.width * 0.13, size.height * 0.25,
        size.width * 0.18, size.height * 0.24);
    path.lineTo(size.width * 0.95, size.height * 0.07);
    path.quadraticBezierTo(
        size.width, size.height * 0.05, size.width * 0.98, size.height * 0.02);
    path.lineTo(size.width * 0.96, 0);
    path.lineTo(0, 0);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
