import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

import '../../l10n/l10n.dart';
import '../../layout/layout.dart';
import '../../models/models.dart';
import '../../typography/typography.dart';
import '../../widgets/widgets.dart';

class PuzzleStatistic extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final moves = context.select((GameModel _) => _.moves);
    final bool sorted = context.select((GameModel _) => _.sorted);
    final int timer = context.select((TimerModel _) => _.timer);
    final timerDuration = Duration(seconds: timer);

    return Container(
      // color: Colors.lightBlueAccent,
      child: ResponsiveLayoutBuilder(
        small: (_, child) => child!,
        medium: (_, child) => child!,
        large: (_, child) => child!,
        child: (size) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (size == ResponsiveLayoutSize.large ||
                  size == ResponsiveLayoutSize.medium) ...[
                Gap(20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    StartButton(),
                    Gap(20),
                    if (sorted) ...[
                      NextLevelButton(),
                    ] else ...[
                      HintButton(),
                    ],
                  ],
                ),
                Gap(10),
              ] else ...[
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                  child: AnimatedDefaultTextStyle(
                    style: PuzzleTextStyle.headline3.copyWith(
                      color: Colors.black,
                    ),
                    duration: Duration(milliseconds: 500),
                    child: Image.asset(
                      'assets/icon/icon_full.png',
                      height: 40,
                    ),
                  ),
                ),
              ],
              // Gap(10),
              AnimatedDefaultTextStyle(
                key: const Key('total_moves'),
                style: PuzzleTextStyle.headline4.copyWith(
                  color: Colors.grey,
                ),
                duration: Duration(milliseconds: 500),
                child: Text('${context.l10n.totalMoves}: $moves'),
              ),
              Gap(10),
              AnimatedDefaultTextStyle(
                key: const Key('total_duration'),
                style: PuzzleTextStyle.headline4.copyWith(
                  color: Colors.grey,
                ),
                duration: Duration(milliseconds: 500),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('${_formatDuration(timerDuration)}'),
                    Icon(Icons.timer_outlined, color: Colors.grey),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    final twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds';
  }
}
