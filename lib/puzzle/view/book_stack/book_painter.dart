import 'package:flutter/material.dart';

class BookSideTitlePainter extends CustomPainter {
  BookSideTitlePainter({this.coverColor});
  final Color? coverColor;

  @override
  void paint(Canvas canvas, Size size) {
    final paintCover = Paint()
      ..color = coverColor ?? Colors.blue
      ..style = PaintingStyle.fill;

    final pathCover = Path()
      ..arcToPoint(
        Offset(size.width, 0),
        clockwise: true,
        radius: Radius.circular(size.height * 0.2),
      )
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..arcToPoint(
        Offset(0, size.height),
        clockwise: true,
        radius: Radius.circular(size.height * 0.3),
      )
      ..lineTo(0, 0);

    final paintInner = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final pathInner = Path()
      ..moveTo(0, size.height * 0.2)
      ..lineTo(size.width, size.height * 0.2)
      ..lineTo(size.width, size.height * 0.25)
      ..lineTo(0, size.height * 0.25)
      ..moveTo(0, size.height * 0.75)
      ..lineTo(size.width, size.height * 0.75)
      ..lineTo(size.width, size.height * 0.8)
      ..lineTo(0, size.height * 0.8);

    canvas.drawPath(pathCover, paintCover);
    canvas.drawPath(pathInner, paintInner);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class BookSideBottomPainter extends CustomPainter {
  BookSideBottomPainter({this.coverColor});
  final Color? coverColor;

  @override
  void paint(Canvas canvas, Size size) {
    final double _coverWidth = 4;
    final double _leftSpace = size.width * 0.04;

    final paintCover = Paint()
      ..color = coverColor ?? Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = _coverWidth;

    final pathCover = Path()
      ..moveTo(size.width, 0)
      ..lineTo(_leftSpace, 0)
      ..arcToPoint(
        Offset(_leftSpace, size.height),
        clockwise: false,
        radius: Radius.circular(size.height * 0.6),
      )
      ..lineTo(size.width, size.height);

    final paintInner = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final pathInner = Path()
      ..moveTo(size.width - _coverWidth, _coverWidth * 0.5)
      ..lineTo(_leftSpace, _coverWidth * 0.5)
      ..arcToPoint(
        Offset(_leftSpace, size.height - _coverWidth * 0.5),
        clockwise: false,
        radius: Radius.circular(size.height * 0.6),
      )
      ..lineTo(size.width - 5, size.height - _coverWidth * 0.5)
      ..arcToPoint(
        Offset(size.width - 5, _coverWidth * 0.5),
        clockwise: true,
        radius: Radius.circular(40),
      );

    final paintLine = Paint()
      ..color = Colors.grey.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final pathLine = Path()
      ..moveTo(size.width * 0.05, size.height * 0.3)
      ..lineTo(size.width * 0.95, size.height * 0.3)
      ..moveTo(size.width * 0.05, size.height * 0.4)
      ..lineTo(size.width * 0.95, size.height * 0.4)
      ..moveTo(size.width * 0.05, size.height * 0.5)
      ..lineTo(size.width * 0.95, size.height * 0.5)
      ..moveTo(size.width * 0.05, size.height * 0.6)
      ..lineTo(size.width * 0.95, size.height * 0.6)
      ..moveTo(size.width * 0.05, size.height * 0.7)
      ..lineTo(size.width * 0.95, size.height * 0.7);

    canvas.drawPath(pathCover, paintCover);
    canvas.drawPath(pathInner, paintInner);
    canvas.drawPath(pathLine, paintLine);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class BookSideMixPainter extends CustomPainter {
  BookSideMixPainter({
    this.coverColor,
    this.bottomColor,
  });
  final Color? coverColor;
  final Color? bottomColor;

  @override
  void paint(Canvas canvas, Size size) {
    final double _coverWidth = 4;
    final double _sideRatio = 0.6;

    final paintBottomCover = Paint()
      ..color = bottomColor ?? Colors.blueAccent
      ..style = PaintingStyle.stroke
      ..strokeWidth = _coverWidth;

    final pathBottomCover = Path()
      ..moveTo(size.width, 0)
      ..lineTo(size.width * _sideRatio, 0)
      ..arcToPoint(
        Offset(size.width * _sideRatio, size.height),
        clockwise: false,
        radius: Radius.circular(size.height * 0.6),
      )
      ..lineTo(size.width, size.height)
      ..moveTo(size.width * _sideRatio, 0)
      ..lineTo(0, 0)
      ..arcToPoint(
        Offset(0, size.height),
        clockwise: false,
        radius: Radius.circular(size.height * 0.6),
      )
      ..lineTo(size.width * _sideRatio, size.height);

    final paintInner = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final pathInner = Path()
      ..moveTo(size.width - _coverWidth, _coverWidth * 0.5)
      ..lineTo(size.width * _sideRatio, _coverWidth * 0.5)
      ..arcToPoint(
        Offset(size.width * _sideRatio, size.height - _coverWidth * 0.5),
        clockwise: false,
        radius: Radius.circular(size.height * 0.6),
      )
      ..lineTo(size.width - 5, size.height - _coverWidth * 0.5)
      ..arcToPoint(
        Offset(size.width - 5, _coverWidth * 0.5),
        clockwise: true,
        radius: Radius.circular(40),
      );

    final paintSideCover = Paint()
      ..color = coverColor ?? Colors.blue
      ..style = PaintingStyle.fill;

    final pathSideCover = Path()
      ..arcToPoint(
        Offset(0, size.height),
        clockwise: false,
        radius: Radius.circular(size.height * 0.6),
      )
      ..lineTo(size.width * _sideRatio, size.height)
      ..arcToPoint(
        Offset(size.width * _sideRatio, 0),
        clockwise: true,
        radius: Radius.circular(size.height * 0.6),
      )
      ..lineTo(size.width * _sideRatio, 0);

    final paintSideLine = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final pathSideLine = Path()
      ..moveTo(size.width * _sideRatio * 0.2, 0)
      ..arcToPoint(
        Offset(size.width * _sideRatio * 0.2, size.height),
        clockwise: false,
        radius: Radius.circular(size.height * 0.6),
      )
      ..lineTo(size.width * _sideRatio * 0.25, size.height)
      ..arcToPoint(
        Offset(size.width * _sideRatio * 0.25, 0),
        clockwise: true,
        radius: Radius.circular(size.height * 0.6),
      )
      ..lineTo(size.width * _sideRatio, 0)
      ..moveTo(size.width * _sideRatio * 0.75, 0)
      ..arcToPoint(
        Offset(size.width * _sideRatio * 0.75, size.height),
        clockwise: false,
        radius: Radius.circular(size.height * 0.6),
      )
      ..lineTo(size.width * _sideRatio * 0.8, size.height)
      ..arcToPoint(
        Offset(size.width * _sideRatio * 0.8, 0),
        clockwise: true,
        radius: Radius.circular(size.height * 0.6),
      )
      ..lineTo(size.width * _sideRatio, 0);

    final paintBottomCoverShadow = Paint()
      ..color = Colors.grey.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    final pathBottomCoverShadow = Path()
      ..moveTo(size.width * _sideRatio, 0)
      ..quadraticBezierTo(
        size.width * 0.7,
        size.height * 1.0,
        size.width,
        size.height,
      )
      ..lineTo(size.width * _sideRatio, size.height)
      ..arcToPoint(
        Offset(size.width * _sideRatio, 0),
        clockwise: true,
        radius: Radius.circular(size.height * 0.6),
      );

    canvas.drawPath(pathInner, paintInner);
    canvas.drawPath(pathBottomCoverShadow, paintBottomCoverShadow);
    canvas.drawPath(pathSideCover, paintSideCover);
    canvas.drawPath(pathSideLine, paintSideLine);
    canvas.drawPath(pathBottomCover, paintBottomCover);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
