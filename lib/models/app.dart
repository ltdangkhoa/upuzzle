import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum PuzzleMode { simple, book_stack, pyramid }

class AppModel extends ChangeNotifier {
  bool _loading = false;
  bool get loading => _loading;
  Future<void> updateLoading(bool value) async {
    _loading = value;
    notifyListeners();
  }

  String _player = 'upuzzle_player';
  String get player => _player;
  Future<void> updatePlayer(String value) async {
    _player = value;
    notifyListeners();
  }

  bool _modalMenu = false;
  bool get modalMenu => _modalMenu;
  Future<void> updateMenu(bool value) async {
    _modalMenu = value;
    notifyListeners();
  }

  String getPuzzleModeStr(PuzzleMode mode) {
    if (mode == PuzzleMode.simple) {
      return 'simple';
    } else if (mode == PuzzleMode.book_stack) {
      return 'book_stack';
    } else if (mode == PuzzleMode.pyramid) {
      return 'pyramid';
    }
    return '';
  }

  PuzzleMode getPuzzleMode(String modeStr) {
    if (modeStr == 'simple') {
      return PuzzleMode.simple;
    } else if (modeStr == 'book_stack') {
      return PuzzleMode.book_stack;
    } else if (modeStr == 'pyramid') {
      return PuzzleMode.pyramid;
    }
    return PuzzleMode.simple;
  }

  PuzzleMode _puzzleMode = PuzzleMode.simple;
  PuzzleMode get puzzleMode => _puzzleMode;
  String get puzzleModeStr => getPuzzleModeStr(_puzzleMode);
  Future<void> updatePuzzleMode(PuzzleMode value) async {
    _puzzleMode = value;
    _modalMenu = false;

    var prefs = await SharedPreferences.getInstance();
    await prefs.setString('puzzleModeStr', getPuzzleModeStr(_puzzleMode));

    notifyListeners();
  }

  Future<void> fetchSaved() async {
    var prefs = await SharedPreferences.getInstance();

    String puzzleModeStr = prefs.getString('puzzleModeStr') ?? 'simple';
    print('---savedMode: $puzzleModeStr');

    _puzzleMode = getPuzzleMode(puzzleModeStr);
  }
}
