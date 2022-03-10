import 'dart:math' as math;

import 'package:flutter/material.dart';

class WaterAnimation extends StatefulWidget {
  WaterAnimation({
    Key? key,
    this.width,
    this.height,
    this.itemSize,
  }) : super(key: key);

  final double? width;
  final double? height;
  final double? itemSize;
  @override
  _WaterAnimationState createState() => _WaterAnimationState();
}

class _WaterAnimationState extends State<WaterAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      value: 0.0,
      duration: Duration(seconds: 5),
      upperBound: 1,
      lowerBound: -1,
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          children: [
            ClipPath(
              clipper: WaveClipper(
                move: _controller.value,
                height: widget.itemSize ?? 0,
                range: 30,
              ),
              child: Container(
                height: widget.height,
                width: widget.width,
                color: Colors.lightBlue.shade900.withOpacity(0.3),
              ),
            ),
            ClipPath(
              clipper: WaveClipper(
                move: (_controller.value + 0.5) > 1
                    ? (_controller.value + 0.5 - 2)
                    : (_controller.value + 0.5),
                height: widget.itemSize ?? 0,
                range: 30,
              ),
              child: Container(
                height: widget.height,
                width: widget.width,
                color: Colors.lightBlue.shade800.withOpacity(0.3),
              ),
            ),
            ClipPath(
              clipper: WaveClipper(
                move: (_controller.value + 1.5) > 1
                    ? (_controller.value + 1.5 - 2)
                    : (_controller.value + 1.5),
                height: widget.itemSize ?? 0,
                range: 30,
              ),
              child: Container(
                height: widget.height,
                width: widget.width,
                color: Colors.lightBlue.shade700.withOpacity(0.3),
              ),
            ),
          ],
        );
      },
    );
  }
}

class WaveClipper extends CustomClipper<Path> {
  double move = 0;
  double slice = math.pi;
  double height = 0;
  double range = 30;
  WaveClipper({
    required this.move,
    required this.height,
    required this.range,
  });
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(0, size.height);
    path.lineTo(0, height);
    double xCenter =
        size.width * 0.5 + (size.width * 0.6 + 1) * math.sin(move * slice);
    double yCenter = height + range * math.cos(move * slice);

    path.quadraticBezierTo(xCenter, yCenter, size.width, height);
    path.lineTo(size.width, size.height);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

class WaterCompleteAnimation extends StatefulWidget {
  WaterCompleteAnimation({
    Key? key,
    this.width,
    this.height,
    this.child,
  }) : super(key: key);

  final double? width;
  final double? height;
  final Widget? child;

  @override
  _WaterCompleteAnimationState createState() => _WaterCompleteAnimationState();
}

class _WaterCompleteAnimationState extends State<WaterCompleteAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation animation;
  late double animationValue = 0;
  late double height = widget.height ?? 0;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    animation = CurvedAnimation(parent: controller, curve: Curves.easeInCubic)
      ..addListener(() {
        setState(() {
          animationValue = height - (animation.value * height);
        });
      });
    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: animationValue,
      width: widget.width,
      child: animationValue > 0 ? widget.child : null,
    );
  }
}
