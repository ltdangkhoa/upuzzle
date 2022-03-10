import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:upuzzle/typography/typography.dart';
import 'package:upuzzle/widgets/widgets.dart';

import '../../l10n/l10n.dart';
import '../../layout/layout.dart';
import '../../models/models.dart';

class HomeMenu extends StatelessWidget {
  const HomeMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PuzzleMode puzzleMode = context.select((AppModel _) => _.puzzleMode);
    final bool modalMenu = context.select((AppModel _) => _.modalMenu);

    final List<Map<String, dynamic>> _appMenu = [
      {
        'id': 'simple',
        'mode': PuzzleMode.simple,
        'name': context.l10n.simple,
      },
      {
        'id': 'book_stack',
        'mode': PuzzleMode.book_stack,
        'name': context.l10n.booksStack,
      },
      {
        'id': 'pyramid',
        'mode': PuzzleMode.pyramid,
        'name': context.l10n.pyramidSaving,
      }
    ];
    return ResponsiveLayoutBuilder(
        small: (_, child) => child!,
        medium: (_, child) => child!,
        large: (_, child) => child!,
        child: (currentSize) {
          return Flex(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            direction: currentSize == ResponsiveLayoutSize.small
                ? Axis.vertical
                : Axis.horizontal,
            children: [
              ...List.generate(
                _appMenu.length,
                (index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CupertinoButton(
                      onPressed: () {
                        if (modalMenu) {
                          Navigator.pop(context);
                        }
                        Provider.of<AppModel>(context, listen: false)
                            .updatePuzzleMode(_appMenu[index]['mode']);
                        Provider.of<GameModel>(context, listen: false)
                            .updateLevel(context, reset: true);
                      },
                      child: Text(
                        '${_appMenu[index]['name']}',
                        style: PuzzleTextStyle.label.copyWith(
                          color: puzzleMode == _appMenu[index]['mode']
                              ? Colors.blue
                              : Colors.grey,
                          fontWeight: puzzleMode == _appMenu[index]['mode']
                              ? FontWeight.bold
                              : FontWeight.w400,
                          fontSize:
                              puzzleMode == _appMenu[index]['mode'] ? 18 : 16,
                        ),
                      ),
                    ),
                  );
                },
              ),
              if (currentSize == ResponsiveLayoutSize.small) ...[
                Container(
                  color: Colors.blue,
                  height: 2,
                ),
                LanguageSection(),
              ],
            ],
          );
        });
  }
}
