import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/models.dart';

import '../../layout/layout.dart';
import '../puzzle.dart';

abstract class BoardSize {
  static double small = 332;
  static double medium = 424;
  static double large = 472;
}

class PuzzleBoard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final PuzzleMode puzzleMode = context.select((AppModel _) => _.puzzleMode);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
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
