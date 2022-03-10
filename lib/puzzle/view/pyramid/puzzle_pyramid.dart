import 'dart:async';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';

import '../../../helpers/helpers.dart';
import '../../../layout/layout.dart';
import '../../../models/models.dart';
import '../../../widgets/widgets.dart';
import '../../puzzle.dart';

class PuzzlePyramid extends StatefulWidget {
  PuzzlePyramid({
    Key? key,
    this.spacing = 5.0,
    AudioPlayerFactory? audioPlayer,
  })  : _audioPlayerFactory = audioPlayer ?? getAudioPlayer,
        super(key: key);

  final double spacing;
  final AudioPlayerFactory _audioPlayerFactory;
  @override
  _PuzzlePyramidState createState() => _PuzzlePyramidState();
}

class _PuzzlePyramidState extends State<PuzzlePyramid> {
  AudioPlayer? _moveAudioPlayer;
  late final Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(seconds: 1), () {
      _moveAudioPlayer = widget._audioPlayerFactory()
        ..setAsset('assets/audio/tile_move.mp3');
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _moveAudioPlayer?.dispose();
    super.dispose();
  }

  int pickedIndex = -1;
  Widget build(BuildContext context) {
    final int currentLevel = context.select((GameModel _) => _.currentLevel);
    final bool sorted = context.select((GameModel _) => _.sorted);
    final List items = context.select((GameModel _) => _.items);
    final _ = context.select((GameModel _) => _.moves);

    final double itemSize = currentLevel < 5 ? 40.0 : 35.0;

    return ClipRRect(
      borderRadius: BorderRadius.circular(16.0),
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            colorFilter: ColorFilter.mode(
              Colors.white.withOpacity(0.8),
              BlendMode.lighten,
            ),
            image: AssetImage("assets/images/puzzle_pyramid_bg.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: ResponsiveLayoutBuilder(
          small: (_, child) => SizedBox(
            width: BoardSize.small,
            child: child!,
          ),
          medium: (_, child) => SizedBox(
            width: BoardSize.medium,
            child: child!,
          ),
          large: (_, child) => SizedBox(
            width: BoardSize.large,
            child: child!,
          ),
          child: (size) {
            double _boardSize = 0;
            if (size == ResponsiveLayoutSize.small) {
              _boardSize = BoardSize.small;
            } else if (size == ResponsiveLayoutSize.medium) {
              _boardSize = BoardSize.medium;
            } else if (size == ResponsiveLayoutSize.large) {
              _boardSize = BoardSize.large;
            }
            double stackHeight = (items.length - 0) * itemSize;
            if (stackHeight < _boardSize) {
              stackHeight = _boardSize;
            }
            return Stack(
              children: [
                SingleChildScrollView(
                  child: StackAnimation(
                    key: UniqueKey(),
                    stackWidth: _boardSize,
                    stackHeight: stackHeight,
                    items: items,
                    itemSize: itemSize,
                    moveAudio: _moveAudioPlayer,
                  ),
                ),
                if (sorted) ...[
                  CompleteView(),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}

class StackAnimation extends StatefulWidget {
  StackAnimation({
    Key? key,
    this.stackHeight,
    this.stackWidth,
    required this.items,
    required this.itemSize,
    this.moveAudio,
  }) : super(key: key);
  final double? stackHeight;
  final double? stackWidth;
  final List items;
  final double itemSize;
  final AudioPlayer? moveAudio;

  @override
  _StackAnimationState createState() => _StackAnimationState();
}

class _StackAnimationState extends State<StackAnimation>
    with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;
  late List items = widget.items;
  late double itemSize = widget.itemSize;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    animation = Tween<double>(begin: itemSize, end: 0).animate(controller)
      ..addListener(() {
        setState(() {});
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
    final int pickedIndex = context.select((GameModel _) => _.pickedIndex);
    final bool sorted = context.select((GameModel _) => _.sorted);
    final bool hint = context.select((GameModel _) => _.hint);

    return Stack(
      children: [
        Container(
          height: widget.stackHeight,
        ),
        if (sorted == false && items.length > 0) ...[
          Positioned(
            bottom: 0,
            child: WaterAnimation(
              width: widget.stackWidth,
              height: items.length * itemSize,
              itemSize: itemSize,
            ),
          ),
        ],
        ...List.generate(items.length, (index) {
          return Positioned(
            bottom: pickedIndex >= index
                ? ((items.length - 1 - index) * itemSize) + animation.value
                : (items.length - 1 - index) * itemSize,
            child: PyramidItem(
              key: UniqueKey(),
              itemWidth: widget.stackWidth,
              itemHeight: widget.itemSize,
              items: items,
              index: index,
              hint: hint,
              onPressed: () {
                Provider.of<GameModel>(context, listen: false)
                    .updateMove(context, index);
                unawaited(widget.moveAudio?.replay());
              },
            ),
          );
        }),
        if (sorted == true) ...[
          Positioned(
            bottom: 0,
            child: WaterCompleteAnimation(
              width: widget.stackWidth,
              height: (items.length) * itemSize,
              child: WaterAnimation(
                width: widget.stackWidth,
                itemSize: itemSize,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class PyramidItem extends StatefulWidget {
  PyramidItem({
    Key? key,
    this.itemWidth,
    this.itemHeight,
    int? item,
    required this.items,
    required this.index,
    this.hint = false,
    this.child,
    this.onPressed,
  })  : item = items[index] ?? 0,
        super(key: key);
  final double? itemWidth;
  final double? itemHeight;
  final int? item;
  final List items;
  final int index;
  final bool? hint;
  final Widget? child;
  final VoidCallback? onPressed;

  @override
  _PyramidItemState createState() => _PyramidItemState();
}

class _PyramidItemState extends State<PyramidItem> {
  double _left = 0;

  @override
  Widget build(BuildContext context) {
    final bool sorted = context.select((GameModel _) => _.sorted);

    return GestureDetector(
      onTap: () {
        if (widget.index > 0) {
          setState(() {
            _left = -(widget.itemWidth ?? 0.0);
          });
        }
      },
      child: Container(
        height: widget.itemHeight,
        width: widget.itemWidth,
        child: Stack(
          children: [
            AnimatedPositioned(
              onEnd: widget.onPressed,
              duration: Duration(milliseconds: 200),
              left: _left,
              child: ClipPath(
                clipper: sorted == true || widget.index == 0
                    ? PyramidItemClipper(
                        totalItem: widget.items.length,
                        value: widget.item ?? 0,
                      )
                    : null,
                child: CustomPaint(
                  painter: PyramidItemPainter(
                    totalItem: widget.items.length,
                    value: widget.item ?? 0,
                    hint: widget.index == 0 ? true : (widget.hint ?? false),
                    sorted: widget.index == 0 || sorted,
                  ),
                  child: Container(
                    height: widget.itemHeight,
                    width: widget.itemWidth,
                    child: widget.child,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
