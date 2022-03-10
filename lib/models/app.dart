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

  bool _modalMenu = false;
  bool get modalMenu => _modalMenu;
  Future<void> updateMenu(bool value) async {
    _modalMenu = value;
    notifyListeners();
  }

  PuzzleMode _puzzleMode = PuzzleMode.simple;
  // PuzzleMode _puzzleMode = PuzzleMode.book_stack;
  // PuzzleMode _puzzleMode = PuzzleMode.pyramid;
  PuzzleMode get puzzleMode => _puzzleMode;
  Future<void> updatePuzzleMode(PuzzleMode value) async {
    _puzzleMode = value;
    _modalMenu = false;

    String puzzleModeStr = '';
    if (value == PuzzleMode.simple) {
      puzzleModeStr = 'simple';
    } else if (value == PuzzleMode.book_stack) {
      puzzleModeStr = 'book_stack';
    } else if (value == PuzzleMode.pyramid) {
      puzzleModeStr = 'pyramid';
    }

    var prefs = await SharedPreferences.getInstance();
    await prefs.setString('puzzleModeStr', puzzleModeStr);

    notifyListeners();
  }

  Future<void> fetchSaved() async {
    var prefs = await SharedPreferences.getInstance();

    String puzzleModeStr = prefs.getString('puzzleModeStr') ?? 'simple';
    print('---savedMode: $puzzleModeStr');
    if (puzzleModeStr == 'simple') {
      _puzzleMode = PuzzleMode.simple;
    } else if (puzzleModeStr == 'book_stack') {
      _puzzleMode = PuzzleMode.book_stack;
    } else if (puzzleModeStr == 'pyramid') {
      _puzzleMode = PuzzleMode.pyramid;
    }
  }
}
