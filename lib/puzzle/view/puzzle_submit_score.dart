import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/models.dart';

class SubmitScore extends StatefulWidget {
  @override
  _SubmitScoreState createState() => _SubmitScoreState();
}

class _SubmitScoreState extends State<SubmitScore> {
  final CollectionReference leaderboard =
      FirebaseFirestore.instance.collection('leaderboard');
  TextEditingController _textFieldController = TextEditingController();
  bool submitted = false;
  bool submitting = false;
  @override
  Widget build(BuildContext context) {
    String player = context.select((AppModel _) => _.player);
    final String mode = context.select((AppModel _) => _.puzzleModeStr);
    final int level = context.select((GameModel _) => _.currentLevel);
    final int move = context.select((GameModel _) => _.moves);
    final int time = context.select((TimerModel _) => _.timer);

    return submitting
        ? CircularProgressIndicator.adaptive()
        : TextButton(
            onPressed: submitted == false
                ? () async {
                    if (player == 'upuzzle_player') {
                      await showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text('Choose a player name'),
                          content: TextField(
                            onChanged: (value) {},
                            controller: _textFieldController,
                            decoration: InputDecoration(
                              hintText: "player_123456",
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                player = _textFieldController.text;
                                Provider.of<AppModel>(context, listen: false)
                                    .updatePlayer(player);
                                Navigator.pop(context, 'OK');
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                    }

                    setState(() {
                      submitting = true;
                    });
                    leaderboard.add({
                      'player': player,
                      'mode': mode,
                      'level': level,
                      'move': move,
                      'time': time,
                    }).then((value) {
                      setState(() {
                        submitted = true;
                        submitting = false;
                      });
                      print("Submitted $value");
                    }).catchError((error) {
                      setState(() {
                        submitting = false;
                      });
                      print("Failed to add data: $error");
                    });
                  }
                : null,
            child: Text(
              submitted == true ? "Submitted" : "Submit score",
            ),
          );
  }
}
