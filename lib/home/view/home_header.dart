import 'package:flutter/material.dart';

import '../../layout/layout.dart';
import '../home.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ResponsiveLayoutBuilder(
      small: (context, child) => child!,
      medium: (context, child) => child!,
      large: (context, child) => child!,
      child: (currentSize) {
        if (currentSize == ResponsiveLayoutSize.large ||
            currentSize == ResponsiveLayoutSize.medium) {
          return SizedBox(
            height: 96,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 50,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  AppLogo(),
                  HomeMenu(),
                ],
              ),
            ),
          );
        }
        return const SizedBox();
      },
    );
  }
}

class AppLogo extends StatelessWidget {
  const AppLogo({
    Key? key,
    this.height,
  }) : super(key: key);

  final double? height;

  @override
  Widget build(BuildContext context) {
    final assetName = 'assets/icon/icon_full.png';

    return AnimatedSwitcher(
      duration: Duration(milliseconds: 500),
      child: height != null
          ? Image.asset(
              assetName,
              height: height,
            )
          : ResponsiveLayoutBuilder(
              key: Key(assetName),
              small: (_, __) => Image.asset(
                assetName,
                height: 24,
              ),
              medium: (_, __) => Image.asset(
                assetName,
                height: 29,
              ),
              large: (_, __) => Image.asset(
                assetName,
                height: 32,
              ),
            ),
    );
  }
}
