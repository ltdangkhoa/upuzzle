import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

import '../../layout/layout.dart';
import '../../models/models.dart';
import '../../widgets/widgets.dart';
import '../home.dart';

class HomeFooter extends StatelessWidget {
  const HomeFooter({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final bool sorted = context.select((GameModel _) => _.sorted);
    const double bottomSize = 61;
    return ResponsiveLayoutBuilder(
      small: (_, child) => child!,
      medium: (_, child) => child!,
      large: (_, child) => child!,
      child: (currentSize) {
        if (currentSize == ResponsiveLayoutSize.small) {
          return Stack(
            children: [
              Positioned(
                bottom: bottomSize * 0.53,
                right: 0,
                left: 0,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: FloatingActionButton(
                    onPressed: () {
                      Provider.of<AppModel>(context, listen: false)
                          .updateMenu(true);
                      showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return HomeMenu();
                        },
                      );
                    },
                    backgroundColor: Colors.blue,
                    child: Stack(
                      children: [
                        Center(
                          child: Icon(
                            Icons.menu,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: ClipPath(
                  clipper: BottomBarClipper(centerSize: bottomSize),
                  child: Container(
                    height: bottomSize,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                    ),
                    child: Row(
                      children: [
                        Expanded(child: StartButton()),
                        Spacer(),
                        Expanded(
                          child: sorted ? NextLevelButton() : HintButton(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        }
        return Container(
          padding: const EdgeInsets.only(bottom: 10.0),
          alignment: Alignment.bottomCenter,
          child: LanguageSection(),
        );
      },
    );
  }
}
