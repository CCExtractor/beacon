import 'package:beacon/core/utils/constants.dart';
import 'package:flutter/material.dart';

class CustomMarker extends CustomPainter {
  final String text;
  CustomMarker({required this.text});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = kYellow
      ..style = PaintingStyle.fill;

    // Draw the bottom part (triangle)
    final path = Path()
      ..moveTo(size.width / 2, size.height)
      ..lineTo(size.width / 2 - 10, size.height - 10)
      ..lineTo(size.width / 2 + 10, size.height - 10)
      ..close();
    canvas.drawPath(path, paint);

    // Draw the top part (rounded rectangle)
    final rect = Rect.fromLTWH(
        0, size.height * 0.5 + 10, size.width, size.height * .5 - 20);
    final rRect = RRect.fromRectAndRadius(rect, Radius.circular(8));
    canvas.drawRRect(rRect, paint);

    // Draw the text
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
            color: Colors.white, fontSize: 14, fontWeight: FontWeight.w800),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(minWidth: 0, maxWidth: size.width);
    final offset = Offset(
      (size.width - textPainter.width) / 2,
      (size.height * 0.55 + 10),
    );
    textPainter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
