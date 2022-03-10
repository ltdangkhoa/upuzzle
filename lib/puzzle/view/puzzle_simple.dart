import 'dart:async';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:upuzzle/typography/typography.dart';

import '../../helpers/helpers.dart';
import '../../models/models.dart';
import '../../widgets/widgets.dart';

class PuzzleSimple extends StatefulWidget {
  PuzzleSimple({
    Key? key,
    this.spacing = 5.0,
    AudioPlayerFactory? audioPlayer,
  })  : _audioPlayerFactory = audioPlayer ?? getAudioPlayer,
        super(key: key);

  final double spacing;
  final AudioPlayerFactory _audioPlayerFactory;

  @override
  _PuzzleSimpleState createState() => _PuzzleSimpleState();
}

class _PuzzleSimpleState extends State<PuzzleSimple> {
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
    final int pickedIndex = context.select((GameModel _) => _.pickedIndex);
    final List items = context.select((GameModel _) => _.items);
    final bool hint = context.select((GameModel _) => _.hint);
    final _ = context.select((GameModel _) => _.moves);

    return Container(
      decoration: BoxDecoration(
        // border: Border.all(width: 2, color: Colors.blue),
        borderRadius: BorderRadius.circular(16.0),
        image: DecorationImage(
          colorFilter: ColorFilter.mode(
            Colors.white.withOpacity(0.8),
            BlendMode.lighten,
          ),
          image: AssetImage("assets/images/puzzle_bg.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Stack(
        children: [
          LayoutBuilder(builder: (context, constraint) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraint.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: List.generate(items.length, (index) {
                      double itemSize = currentLevel < 5 ? 40.0 : 35.0;
                      bool showLabel = false;
                      if (hint || sorted || index == 0) {
                        showLabel = true;
                      }
                      return Padding(
                        padding: EdgeInsets.only(top: widget.spacing),
                        child: PuzzleItem(
                          key: UniqueKey(),
                          backgroundColor: !sorted
                              ? Colors.amber.withOpacity(0.7)
                              : Colors.greenAccent.withOpacity(0.8),
                          hoverColor: Colors.blue,
                          size: itemSize,
                          sorted: sorted,
                          scaleOn: !hint && pickedIndex > 0 && index == 0,
                          topItem: index == 0,
                          onPressed: () {
                            if (index > 0 && !sorted) {
                              Provider.of<GameModel>(context, listen: false)
                                  .updateMove(context, index);
                              unawaited(_moveAudioPlayer?.replay());
                            }
                          },
                          child: showLabel
                              ? Stack(
                                  children: [
                                    Center(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white,
                                        ),
                                        height: itemSize * 0.8,
                                        width: itemSize * 0.8,
                                        child: Center(
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
                                  ],
                                )
                              : null,
                        ),
                      );
                    }),
                  ),
                ),
              ),
            );
          }),
          if (sorted) ...[
            CompleteView(),
          ],
        ],
      ),
    );
  }
}

class PuzzleItem extends StatefulWidget {
  PuzzleItem({
    Key? key,
    this.backgroundColor,
    this.hoverColor,
    this.size = 30.0,
    required this.sorted,
    this.child,
    required this.onPressed,
    this.scaleOn = false,
    this.topItem = false,
  }) : super(key: key);

  final Color? backgroundColor;
  final Color? hoverColor;
  final double? size;
  final bool sorted;
  final Widget? child;
  final VoidCallback? onPressed;
  final bool? scaleOn;
  final bool? topItem;

  @override
  _PuzzleItemState createState() => _PuzzleItemState();
}

class _PuzzleItemState extends State<PuzzleItem> {
  late Color? _backgroundColor = widget.backgroundColor;
  double _scale = 1.0;
  //
  @override
  void initState() {
    super.initState();
    if (widget.scaleOn == true) {
      _scale = widget.scaleOn == true ? 0.0 : 1.0;
      Timer(const Duration(milliseconds: 50), () {
        updateScale();
      });
    }
  }

  Future<void> updateScale() async {
    setState(() {
      _scale = widget.scaleOn == true ? 1.0 : 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onExit: (e) {
        setState(() {
          _backgroundColor = widget.backgroundColor;
        });
      },
      onEnter: (e) {
        if (!widget.sorted) {
          setState(() {
            _backgroundColor = widget.hoverColor;
          });
        }
      },
      child: GestureDetector(
        onTap: () {
          if (widget.topItem == false) {
            setState(() {
              _scale = 0.0;
            });
          } else {
            widget.onPressed?.call();
          }
        },
        child: AnimatedScale(
          duration: const Duration(milliseconds: 200),
          scale: _scale,
          onEnd: widget.onPressed,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Container(
              decoration: BoxDecoration(
                color: _backgroundColor,
                gradient: LinearGradient(
                  colors: [
                    _backgroundColor ?? Colors.blue,
                    Colors.white,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              height: widget.size,
              width: double.infinity,
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }
}
