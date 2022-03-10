import 'dart:async';

import 'package:flutter/material.dart';

import 'models.dart';

class TimerModel extends ChangeNotifier {
  int _timer = 0;
  int get timer => _timer;

  Ticker _ticker = Ticker();
  StreamSubscription<int>? _tickerSubscription;

  void resetTimer() {
    _timer = 0;
    notifyListeners();
  }

  void startTimer() {
    _tickerSubscription?.cancel();
    _tickerSubscription = _ticker.tick().listen((timer) {
      _timer = timer;
      notifyListeners();
    });
  }

  void stopTimer() {
    _tickerSubscription?.pause();
  }
}
