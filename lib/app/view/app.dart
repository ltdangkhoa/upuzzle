import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import '../../helpers/platform_helper.dart';
import '../../home/home.dart';
import '../../l10n/l10n.dart';
import '../../models/models.dart';

class App extends StatefulWidget {
  const App({Key? key, ValueGetter<PlatformHelper>? platformHelperFactory})
      : _platformHelperFactory = platformHelperFactory ?? getPlatformHelper,
        super(key: key);

  final ValueGetter<PlatformHelper> _platformHelperFactory;

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final PlatformHelper _platformHelper;
  late final Timer _timer;

  static const localAssetsPrefix = 'assets/';
  static final audioAssets = [
    'assets/audio/click.mp3',
    'assets/audio/success.mp3',
    'assets/audio/tile_move.mp3',
  ];

  @override
  void initState() {
    super.initState();

    _platformHelper = widget._platformHelperFactory();
    for (final audioAsset in audioAssets) {
      prefetchToMemory(audioAsset);
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  /// Prefetches the given [filePath] to memory.
  Future<void> prefetchToMemory(String filePath) async {
    if (_platformHelper.isWeb) {
      // We rely on browser caching here. Once the browser downloads the file,
      // the native implementation should be able to access it from cache.
      await http.get(Uri.parse('$localAssetsPrefix$filePath'));
      return;
    }
    throw UnimplementedError(
      'The function `prefetchToMemory` is not implemented '
      'for platforms other than Web.',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageModel>(builder: (_, data, child) {
      return MaterialApp(
        theme: ThemeData(
          appBarTheme: const AppBarTheme(color: Color(0xFF13B9FF)),
          colorScheme: ColorScheme.fromSwatch(
            accentColor: const Color(0xFF13B9FF),
          ),
        ),
        locale: data.appLocale,
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: HomePage(),
      );
    });
  }
}
