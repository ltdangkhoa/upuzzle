import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:upuzzle/typography/typography.dart';

import '../../helpers/helpers.dart';
import '../../models/models.dart';

class PuzzleLeaderboard extends StatefulWidget {
  @override
  _PuzzleLeaderboardState createState() => _PuzzleLeaderboardState();
}

class _PuzzleLeaderboardState extends State<PuzzleLeaderboard> {
  @override
  Widget build(BuildContext context) {
    final String modeStr = context.select((AppModel _) => _.puzzleModeStr);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        image: DecorationImage(
          colorFilter: ColorFilter.mode(
            Colors.white.withOpacity(0.8),
            BlendMode.lighten,
          ),
          image: AssetImage("assets/images/puzzle_leaderboard.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('leaderboard')
            .where('mode', isEqualTo: modeStr)
            .orderBy('level', descending: true)
            .orderBy('move')
            .orderBy('time')
            .limit(10)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            print(snapshot.error);
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator.adaptive());
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;

              final timerDuration = Duration(seconds: data['time']);
              return ListTile(
                leading: Icon(
                  Icons.supervised_user_circle_sharp,
                  color: Colors.blue,
                ),
                title: AnimatedDefaultTextStyle(
                  key: const Key('leaderboard_title'),
                  style: PuzzleTextStyle.label.copyWith(
                    color: Colors.black,
                  ),
                  duration: Duration(milliseconds: 500),
                  child: Text(data['player']),
                ),
                subtitle: AnimatedDefaultTextStyle(
                  key: const Key('leaderboard_subtitle'),
                  style: PuzzleTextStyle.label.copyWith(
                    color: Colors.grey,
                  ),
                  duration: Duration(milliseconds: 500),
                  child: Text(
                    'Level: ${data['level']} (${data['move']} moves - ${formatDuration(timerDuration)})',
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
