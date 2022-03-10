import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/models.dart';
import 'package:upuzzle/layout/layout.dart';
import 'package:upuzzle/models/models.dart';
import 'package:upuzzle/typography/text_styles.dart';
import '../../l10n/l10n.dart';

abstract class _BoardSize {
  static double small = 332;
  static double medium = 424;
  static double large = 472;
}

class PuzzleGuide extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Map<PuzzleMode, String> guideDict = {
      PuzzleMode.simple: context.l10n.howToPlaySimple,
      PuzzleMode.book_stack: context.l10n.howToPlayBooksStack,
      PuzzleMode.pyramid: context.l10n.howToPlayPyramid,
    };
    final PuzzleMode puzzleMode = context.select((AppModel _) => _.puzzleMode);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ResponsiveLayoutBuilder(
          small: (_, child) => SizedBox.square(
            dimension: _BoardSize.small,
            child: child!,
          ),
          medium: (_, child) => SizedBox.square(
            dimension: _BoardSize.medium,
            child: child!,
          ),
          large: (_, child) => SizedBox.square(
            dimension: _BoardSize.large,
            child: child!,
          ),
          child: (size) {
            return Container(
              decoration: BoxDecoration(
                // border: Border.all(width: 2, color: Colors.blue),
                borderRadius: BorderRadius.circular(16.0),
              ),
              padding: EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(
                      guideDict[puzzleMode] ?? '',
                      style: PuzzleTextStyle.label.copyWith(
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
