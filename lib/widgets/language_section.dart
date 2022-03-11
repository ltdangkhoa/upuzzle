import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/l10n.dart';
import '../layout/layout.dart';
import '../models/models.dart';
import '../typography/typography.dart';

class LanguageSection extends StatelessWidget {
  const LanguageSection({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var appLangCode = context.select((LanguageModel _) => _.appLangCode);
    return ResponsiveLayoutBuilder(
      small: (_, child) => child!,
      medium: (_, child) => child!,
      large: (_, child) => child!,
      child: (size) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children:
              List.generate(AppLocalizations.supportedLocales.length, (i) {
            String languageCode =
                AppLocalizations.supportedLocales[i].languageCode;
            return GestureDetector(
              onTap: () {
                Provider.of<LanguageModel>(context, listen: false)
                    .updateAppLangCode(languageCode);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: languageCode == 'uk'
                    ? Image.asset('assets/images/uk_flag.png')
                    : Text(
                        languageCode,
                        style: PuzzleTextStyle.label.copyWith(
                          color: appLangCode == languageCode
                              ? Colors.black
                              : Colors.grey,
                          fontWeight: appLangCode == languageCode
                              ? FontWeight.w500
                              : FontWeight.w300,
                          fontSize: appLangCode == languageCode ? 18 : 14,
                        ),
                      ),
              ),
            );
          }),
        );
      },
    );
  }
}
