import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:upuzzle/models/models.dart';

import '../../layout/layout.dart';
import '../../puzzle/puzzle.dart';
import '../home.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white54,
      body: HomeView(
        key: Key('home_view'),
      ),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: Column(
                  children: const [
                    HomeHeader(key: Key('home_header')),
                    HomeSections(key: Key('home_sections')),
                  ],
                ),
              ),
            ),
            HomeFooter(key: Key('home_footer')),
          ],
        );
      },
    );
  }
}

class HomeSections extends StatelessWidget {
  const HomeSections({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    bool puzzleGuide = context.select((GameModel _) => _.puzzleGuide);
    return ResponsiveLayoutBuilder(
      small: (context, child) => Container(
        height: screenHeight,
        width: screenWidth,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                height: 150,
                child: PuzzleStatistic(),
              ),
            ),
            Positioned(
              bottom: 70,
              right: 10,
              child: Container(
                height: 80,
                width: 80,
                child: IconButton(
                  iconSize: 50,
                  onPressed: () {
                    Provider.of<GameModel>(context, listen: false)
                        .updatePuzzleGuide(context);
                  },
                  icon: Icon(
                    Icons.support,
                    color: Colors.blue,
                  ),
                ),
              ),
            ),
            Center(
              child: IndexedStack(
                index: puzzleGuide ? 1 : 0,
                children: [
                  PuzzleBoard(),
                  PuzzleGuide(),
                ],
              ),
            ),
          ],
        ),
      ),
      medium: (context, child) => Stack(
        children: [
          Column(
            children: [
              PuzzleStatistic(),
              Center(
                child: IndexedStack(
                  index: puzzleGuide ? 1 : 0,
                  children: [
                    PuzzleBoard(),
                    PuzzleGuide(),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            right: 10,
            child: Container(
              height: 80,
              width: 80,
              child: IconButton(
                iconSize: 50,
                onPressed: () {
                  Provider.of<GameModel>(context, listen: false)
                      .updatePuzzleGuide(context);
                },
                icon: Icon(
                  Icons.support,
                  color: Colors.blue,
                ),
              ),
            ),
          ),
        ],
      ),
      large: (context, child) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: PuzzleStatistic(),
          ),
          Expanded(
            flex: 3,
            child: PuzzleBoard(),
          ),
          Expanded(
            flex: 2,
            child: PuzzleGuide(),
          ),
        ],
      ),
    );
  }
}
