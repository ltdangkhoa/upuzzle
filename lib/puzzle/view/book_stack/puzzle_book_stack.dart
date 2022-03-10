import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';

import '../../../helpers/helpers.dart';
import '../../../layout/layout.dart';
import '../../../models/models.dart';
import '../../../typography/typography.dart';
import '../../../widgets/widgets.dart';
import '../../puzzle.dart';

const double pickedFieldSize = 40.0;

class PuzzleBookStack extends StatefulWidget {
  PuzzleBookStack({
    Key? key,
    this.spacing = 5.0,
    AudioPlayerFactory? audioPlayer,
  })  : _audioPlayerFactory = audioPlayer ?? getAudioPlayer,
        super(key: key);

  final double spacing;
  final AudioPlayerFactory _audioPlayerFactory;

  @override
  _PuzzleBookStackState createState() => _PuzzleBookStackState();
}

class _PuzzleBookStackState extends State<PuzzleBookStack> {
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

  @override
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
            image: AssetImage("assets/images/puzzle_book_bg.jpg"),
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
            double stackHeight = (items.length - 1) * itemSize;
            if (stackHeight < _boardSize) {
              stackHeight = _boardSize;
            }
            double stackHeightCompleted = (items.length) * itemSize;
            if (stackHeightCompleted < _boardSize) {
              stackHeightCompleted = _boardSize;
            }
            double stackWidth = _boardSize;

            double ratio = 354 / 552;
            double h1 = stackWidth * 0.55 * ratio;
            double h2 = itemSize * (items.length);
            double totalAlign = 2 * h2 / h1;
            double step = totalAlign / (items.length - 1);
            return Stack(
              children: [
                if (sorted == false) ...[
                  if (items.isNotEmpty) ...[
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Container(
                        width: pickedFieldSize,
                        height: _boardSize,
                        child: PickedField(
                          key: UniqueKey(),
                          title: (items[0] + 1).toString(),
                        ),
                      ),
                    ),
                  ],
                  SingleChildScrollView(
                    child: BooksStackAnimation(
                      key: UniqueKey(),
                      stackWidth: stackWidth,
                      stackHeight: stackHeight,
                      items: items,
                      itemSize: itemSize,
                      moveAudio: _moveAudioPlayer,
                      step: step,
                      totalAlign: totalAlign,
                    ),
                  ),
                ] else ...[
                  SingleChildScrollView(
                    child: Stack(
                      children: [
                        Container(
                          height: stackHeightCompleted,
                        ),
                        ...List.generate(items.length, (index) {
                          return Positioned(
                            bottom: (items.length - index - 1) * itemSize,
                            child: PuzzleBookItem(
                              key: UniqueKey(),
                              backgroundColor: Colors.greenAccent,
                              bottomColor: Colors.green,
                              height: itemSize,
                              width: stackWidth,
                              sorted: sorted,
                              hint: true,
                              onPressed: () {},
                              child: Stack(
                                children: [
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    width: (stackWidth) * 0.55,
                                    child: Container(
                                      height: itemSize * 0.7,
                                      width: itemSize * 0.7,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Transform.rotate(
                                          angle: -math.pi / 2,
                                          child: Text(
                                            (items[index] + 1).toString(),
                                            style:
                                                PuzzleTextStyle.label.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(1),
                                    child: Container(
                                      alignment: Alignment.center,
                                      width: stackWidth * 0.55,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage(
                                            'assets/images/bird_medium.png',
                                          ),
                                          fit: BoxFit.fitWidth,
                                          alignment: Alignment(
                                            -1,
                                            -(totalAlign / 2) +
                                                (step * items[index]),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
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

class BooksStackAnimation extends StatefulWidget {
  BooksStackAnimation({
    Key? key,
    this.stackHeight,
    this.stackWidth,
    required this.items,
    required this.itemSize,
    required this.step,
    required this.totalAlign,
    this.moveAudio,
  }) : super(key: key);

  final double? stackHeight;
  final double? stackWidth;
  final List items;
  final double itemSize;
  final AudioPlayer? moveAudio;
  final double step;
  final double totalAlign;

  @override
  _BooksStackAnimationState createState() => _BooksStackAnimationState();
}

class _BooksStackAnimationState extends State<BooksStackAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;
  late double animationValue = 0;
  late List items = widget.items;
  late double itemSize = widget.itemSize;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    animation = CurvedAnimation(parent: controller, curve: Curves.easeInCubic)
      ..addListener(() {
        setState(() {
          animationValue = itemSize - (itemSize * animation.value);
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
    final int pickedIndex = context.select((GameModel _) => _.pickedIndex);
    final bool hint = context.select((GameModel _) => _.hint);
    final bool sorted = context.select((GameModel _) => _.sorted);

    return Stack(
      children: [
        Container(
          height: widget.stackHeight,
        ),
        ...List.generate(items.length, (index) {
          if (index == 0) {
            return SizedBox();
          }
          return Positioned(
            bottom: pickedIndex >= index
                ? ((items.length - 1 - index) * itemSize) + animationValue
                : (items.length - 1 - index) * itemSize,
            child: PuzzleBookItem(
              key: UniqueKey(),
              backgroundColor: Colors.amberAccent,
              bottomColor: Colors.amber,
              height: itemSize,
              width: widget.stackWidth,
              sorted: sorted,
              hint: hint,
              onPressed: () {
                if (index > 0 && !sorted) {
                  Provider.of<GameModel>(context, listen: false)
                      .updateMove(context, index);
                  unawaited(widget.moveAudio?.replay());
                }
              },
              child: hint == true
                  ? Stack(
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          width: (widget.stackWidth!) * 0.55,
                          child: Container(
                            height: itemSize * 0.7,
                            width: itemSize * 0.7,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                (items[index] + 1).toString(),
                                style: PuzzleTextStyle.label.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: Container(
                            alignment: Alignment.center,
                            width: (widget.stackWidth!) * 0.55,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(
                                  'assets/images/bird_medium.png',
                                ),
                                fit: BoxFit.fitWidth,
                                alignment: Alignment(
                                  -1,
                                  -(widget.totalAlign / 2) +
                                      (widget.step * items[index]),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : null,
            ),
          );
        }),
      ],
    );
  }
}

class PuzzleBookItem extends StatefulWidget {
  PuzzleBookItem({
    Key? key,
    this.backgroundColor,
    this.bottomColor,
    this.height = 30.0,
    this.width = 100,
    required this.sorted,
    this.child,
    required this.onPressed,
    this.hint = false,
  }) : super(key: key);

  final Color? backgroundColor;
  final Color? bottomColor;
  final double? height;
  final double? width;
  final bool sorted;
  final Widget? child;
  final VoidCallback? onPressed;
  final bool? hint;

  @override
  _PuzzleBookItemState createState() => _PuzzleBookItemState();
}

class _PuzzleBookItemState extends State<PuzzleBookItem> {
  late double _leftSpace;
  bool _isTapped = false;

  @override
  void initState() {
    _leftSpace = widget.sorted == true ? 10 : 40;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onExit: (e) {
        if (widget.sorted == false) {
          setState(() {
            _leftSpace = 40;
          });
        }
      },
      onEnter: (e) {
        if (widget.sorted == false) {
          setState(() {
            _leftSpace = 20;
          });
        }
      },
      child: GestureDetector(
        onTap: () {
          setState(() {
            _isTapped = true;
            _leftSpace = -widget.width!;
          });
        },
        // onHorizontalDragStart: (e) {
        //   print(e.localPosition);
        // },
        // onHorizontalDragUpdate: (e) {
        //   print(e.localPosition);
        // },
        child: Container(
          height: widget.height,
          width: widget.width,
          child: Stack(
            children: [
              AnimatedPositioned(
                duration: Duration(milliseconds: 200),
                left: _leftSpace,
                onEnd: () {
                  if (_isTapped == true) {
                    widget.onPressed?.call();
                    _isTapped = false;
                  }
                },
                child: CustomPaint(
                  painter: widget.hint == false
                      ? BookSideBottomPainter(
                          coverColor: widget.backgroundColor,
                        )
                      : BookSideMixPainter(
                          bottomColor: widget.bottomColor,
                          coverColor: widget.backgroundColor,
                        ),
                  child: Container(
                    height: widget.height,
                    width: widget.width! -
                        (widget.sorted == false ? pickedFieldSize : 10),
                    child: widget.child,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
