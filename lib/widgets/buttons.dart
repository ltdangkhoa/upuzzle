import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/l10n.dart';
import '../layout/layout.dart';
import '../models/models.dart';
import '../typography/typography.dart';

class GameButton extends StatelessWidget {
  const GameButton({
    Key? key,
    required this.child,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
  }) : super(key: key);

  final Color? backgroundColor;
  final Color? textColor;

  final VoidCallback? onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final buttonTextColor = textColor ?? Colors.white;
    final buttonBackgroundColor = backgroundColor ?? Colors.blue;
    return ResponsiveLayoutBuilder(
      small: (_, child) => child!,
      medium: (_, child) => child!,
      large: (_, child) => child!,
      child: (size) {
        if (size == ResponsiveLayoutSize.small) {
          return CupertinoButton(
            onPressed: onPressed,
            child: child,
          );
        }
        return SizedBox(
          width: 145,
          height: 44,
          child: TextButton(
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              textStyle: PuzzleTextStyle.headline5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ).copyWith(
              backgroundColor: MaterialStateProperty.all(buttonBackgroundColor),
              foregroundColor: MaterialStateProperty.all(buttonTextColor),
            ),
            onPressed: onPressed,
            child: child,
          ),
        );
      },
    );
  }
}

class StartButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GameButton(
      onPressed: () {
        Provider.of<GameModel>(context, listen: false).initItems(context);
      },
      child: Text(
        context.l10n.startGame,
        style: PuzzleTextStyle.label.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w500,
          fontSize: 18,
        ),
      ),
    );
  }
}

class NextLevelButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GameButton(
      onPressed: () {
        Provider.of<GameModel>(context, listen: false).updateLevel(context);
      },
      child: Text(
        context.l10n.nextLevel,
        style: PuzzleTextStyle.label.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w500,
          fontSize: 18,
        ),
      ),
    );
  }
}

class HintButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bool hintAvailable = context.select((GameModel _) => _.hintAvailable);
    return GameButton(
      onPressed: hintAvailable
          ? () {
              Provider.of<GameModel>(context, listen: false).showHint(context);
            }
          : null,
      child: Text(
        context.l10n.hint,
        style: PuzzleTextStyle.label.copyWith(
          color: hintAvailable ? Colors.white : Colors.white54,
          fontWeight: FontWeight.w500,
          fontSize: 18,
        ),
      ),
    );
  }
}
