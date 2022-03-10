import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app/view/app.dart';
import 'models/models.dart';

// void main() {
//   runApp(const App());
// }
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  print('---fetchAppModel---');
  AppModel appModel = AppModel();
  await appModel.fetchSaved();

  print('---fetchLanguageModel---');
  LanguageModel languageModel = LanguageModel();
  await languageModel.fetchLocale();

  final GameModel gameModel = GameModel();
  final TimerModel timerModel = TimerModel();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AppModel>(create: (_) => appModel),
        ChangeNotifierProvider<LanguageModel>(create: (_) => languageModel),
        ChangeNotifierProvider<GameModel>(create: (_) => gameModel),
        ChangeNotifierProvider<TimerModel>(create: (_) => timerModel),
      ],
      child: const App(),
    ),
  );
}
