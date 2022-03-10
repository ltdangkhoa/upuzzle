import 'package:flutter/material.dart';

class PyramidItemClipper extends CustomClipper<Path> {
  PyramidItemClipper({
    required this.value,
    required this.totalItem,
  });
  final int value;
  final int totalItem;

  @override
  getClip(Size size) {
    double haflX = size.width * 0.5;
    double diffStart = value / totalItem * haflX;
    double diffEnd = (value + 1) / totalItem * haflX;
    double startX1 = haflX - diffStart;
    double startX2 = haflX + diffStart;
    double endX1 = haflX - diffEnd;
    double endX2 = haflX + diffEnd;
    Path path = Path()
      ..moveTo(startX1, 0)
      ..lineTo(endX1, size.height)
      ..lineTo(endX2, size.height)
      ..lineTo(startX2, 0);

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper oldClipper) {
    return false;
  }
}

class PyramidItemPainter extends CustomPainter {
  PyramidItemPainter({
    required this.value,
    required this.totalItem,
    this.hint = false,
    this.sorted = false,
  });
  final int value;
  final int totalItem;
  final bool hint;
  final bool sorted;

  @override
  void paint(Canvas canvas, Size size) {
    final paintFill = Paint()
      ..color = sorted
          ? Colors.amberAccent.withOpacity(0.8)
          : Colors.amberAccent.withOpacity(0.5)
      ..style = PaintingStyle.fill;

    final pathFill = Path()
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height);

    final paintLine = Paint()
      ..color = Colors.brown
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final pathLine = Path()
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..lineTo(0, 0);

    final paintLineInner = Paint()
      ..color = Colors.grey
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final pathLineInner = Path()
      ..moveTo(0, size.height * 0.5)
      ..lineTo(size.width, size.height * 0.5)
      ..moveTo(size.width * 0.33, 0)
      ..lineTo(size.width * 0.33, size.height * 0.5)
      ..moveTo(size.width * 0.66, 0)
      ..lineTo(size.width * 0.66, size.height * 0.5)
      ..moveTo(size.width * 0.17, size.height * 0.5)
      ..lineTo(size.width * 0.17, size.height)
      ..moveTo(size.width * 0.5, size.height * 0.5)
      ..lineTo(size.width * 0.5, size.height)
      ..moveTo(size.width * 0.83, size.height * 0.5)
      ..lineTo(size.width * 0.83, size.height);

    canvas.drawPath(pathFill, paintFill);
    canvas.drawPath(pathLine, paintLine);
    canvas.drawPath(pathLineInner, paintLineInner);

    if (hint || sorted) {
      final paintLineHint = Paint()
        ..color = sorted ? Colors.brown : Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = sorted ? 5.0 : 2.0;

      double haflX = size.width * 0.5;
      double diffStart = value / totalItem * haflX;
      double diffEnd = (value + 1) / totalItem * haflX;
      double startX1 = haflX - diffStart;
      double startX2 = haflX + diffStart;
      double endX1 = haflX - diffEnd;
      double endX2 = haflX + diffEnd;

      final pathLineHint = Path()
        ..moveTo(startX1, 0)
        ..lineTo(endX1, size.height)
        ..moveTo(startX2, 0)
        ..lineTo(endX2, size.height);
      canvas.drawPath(pathLineHint, paintLineHint);

      // final paintLineFirst = Paint()
      //   ..color = Colors.brown
      //   ..style = PaintingStyle.stroke
      //   ..strokeWidth = 5.0;
      // final pathLineFirst = Path()
      //   ..moveTo(startX1, 0)
      //   ..lineTo(startX2, 0);
      // canvas.drawPath(pathLineFirst, paintLineFirst);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
