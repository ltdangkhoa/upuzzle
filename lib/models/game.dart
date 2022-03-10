import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helpers/helpers.dart';
import 'models.dart';

class GameModel extends ChangeNotifier {
  int _currentLevel = 1;
  int get currentLevel => _currentLevel;

  Future<void> updateLevel(BuildContext context, {bool reset = false}) async {
    _pickedIndex = -1;
    _currentLevel = reset ? 1 : _currentLevel + 1;
    if (reset) {
      _items = [];
      _hint = false;
      _hintAvailable = false;
      _sorted = false;
      _moves = 0;
      _movesHint = 0;
      Provider.of<TimerModel>(context, listen: false).stopTimer();
      Provider.of<TimerModel>(context, listen: false).resetTimer();

      notifyListeners();
    } else {
      await initItems(context);
    }
  }

  List _items = [];
  List get items => _items;

  bool _sorted = false;
  bool get sorted => _sorted;

  int _movesHint = 0;
  int _moves = 0;
  int get moves => _moves;

  Future<void> initItems(BuildContext context) async {
    _items = [];
    for (int i = 0; i < (currentLevel + 3); i++) {
      _items.add(i);
    }
    while (isSorted(_items)) {
      _items.shuffle();
    }
    _hint = false;
    _hintAvailable = false;
    _sorted = false;
    _moves = 0;
    _movesHint = 0;

    Provider.of<TimerModel>(context, listen: false).resetTimer();
    Provider.of<TimerModel>(context, listen: false).startTimer();

    notifyListeners();
  }

  int _pickedIndex = -1;
  int get pickedIndex => _pickedIndex;
  int _pickedItem = -1;

  Future<void> updateMove(BuildContext context, int index) async {
    _pickedIndex = index;
    _pickedItem = _items[index];
    _items.removeAt(index);
    _items.insert(0, _pickedItem);
    _hint = false;
    _sorted = isSorted(_items);
    _moves += 1;
    _movesHint += 1;

    if (_movesHint > 4) {
      _hintAvailable = true;
    }

    if (_sorted) {
      _pickedIndex = -1;
      Provider.of<TimerModel>(context, listen: false).stopTimer();
    }

    notifyListeners();
  }

  bool _puzzleGuide = false;
  bool get puzzleGuide => _puzzleGuide;

  Future<void> updatePuzzleGuide(BuildContext context) async {
    _pickedIndex = -1;
    _puzzleGuide = !_puzzleGuide;
    notifyListeners();
  }

  bool _hintAvailable = false;
  bool get hintAvailable => _hintAvailable;

  bool _hint = false;
  bool get hint => _hint;

  Future<void> showHint(BuildContext context) async {
    _pickedIndex = -1;
    _hint = true;
    _movesHint = 0;
    _hintAvailable = false;
    notifyListeners();
  }
}
