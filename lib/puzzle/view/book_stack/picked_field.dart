import 'dart:async';

import 'package:flutter/material.dart';

import '../../../typography/typography.dart';
import '../../puzzle.dart';

class PickedField extends StatefulWidget {
  PickedField({
    Key? key,
    required this.title,
  }) : super(key: key);
  final String title;

  static const double fieldHeight = 300.0;
  static const double fieldWidth = 40.0;

  @override
  _PickedFieldState createState() => _PickedFieldState();
}

class _PickedFieldState extends State<PickedField> {
  double _leftPosition = -40;
  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 50), () {
      setState(() {
        _leftPosition = 0;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedPositioned(
          curve: Curves.easeOutCubic,
          duration: Duration(milliseconds: 300),
          left: _leftPosition,
          bottom: 0,
          child: CustomPaint(
            painter: BookSideTitlePainter(coverColor: Colors.amberAccent),
            child: Container(
              height: PickedField.fieldHeight,
              width: PickedField.fieldWidth,
              child: Stack(
                children: [
                  Container(
                    height: PickedField.fieldHeight,
                    width: PickedField.fieldWidth,
                    alignment: Alignment(0, -0.9),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      height: PickedField.fieldWidth * 0.8,
                      width: PickedField.fieldWidth * 0.8,
                      child: Center(
                        child: Text(
                          widget.title,
                          style: PuzzleTextStyle.label.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
