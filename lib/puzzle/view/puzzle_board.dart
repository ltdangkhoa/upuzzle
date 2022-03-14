import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:upuzzle/puzzle/view/puzzle_leaderboard.dart';
import 'package:upuzzle/typography/typography.dart';
import '../../models/models.dart';

import '../../layout/layout.dart';
import '../puzzle.dart';
import '../../l10n/l10n.dart';

abstract class BoardSize {
  static double small = 332;
  static double medium = 424;
  static double large = 472;
}

class PuzzleBoard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final PuzzleMode puzzleMode = context.select((AppModel _) => _.puzzleMode);
    final bool leaderboard = context.select((AppModel _) => _.leaderboard);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            Provider.of<AppModel>(context, listen: false)
                .updateLeaderboard(!leaderboard);
          },
          child: Container(
            padding: const EdgeInsets.fromLTRB(32.0, 4.0, 32.0, 4.0),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.8),
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(8.0),
                topRight: const Radius.circular(8.0),
              ),
            ),
            child: AnimatedDefaultTextStyle(
              key: const Key('leaderboard_button'),
              style: PuzzleTextStyle.label.copyWith(
                color: Colors.white,
              ),
              duration: Duration(milliseconds: 500),
              child: Text(leaderboard == true
                  ? context.l10n.back
                  : context.l10n.leaderboard),
            ),
          ),
        ),
        ResponsiveLayoutBuilder(
          small: (_, child) => SizedBox.square(
            dimension: BoardSize.small,
            child: child!,
          ),
          medium: (_, child) => SizedBox.square(
            dimension: BoardSize.medium,
            child: child!,
          ),
          large: (_, child) => SizedBox.square(
            dimension: BoardSize.large,
            child: child!,
          ),
          child: (size) {
            if (leaderboard == true) {
              return PuzzleLeaderboard();
            }
            if (puzzleMode == PuzzleMode.book_stack) {
              return PuzzleBookStack();
            } else if (puzzleMode == PuzzleMode.pyramid) {
              return PuzzlePyramid();
            }
            return PuzzleSimple();
          },
        ),
      ],
    );
  }
}
