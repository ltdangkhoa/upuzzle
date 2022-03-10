import 'dart:async';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rive/rive.dart';

import '../helpers/helpers.dart';

class CompleteView extends StatefulWidget {
  CompleteView({
    Key? key,
    AudioPlayerFactory? audioPlayer,
  })  : _audioPlayerFactory = audioPlayer ?? getAudioPlayer,
        super(key: key);

  final AudioPlayerFactory _audioPlayerFactory;

  @override
  _CompleteViewState createState() => _CompleteViewState();
}

class _CompleteViewState extends State<CompleteView> {
  late final AudioPlayer _successAudioPlayer;
  late final Timer _timer;

  @override
  void initState() {
    super.initState();
    _successAudioPlayer = widget._audioPlayerFactory()
      ..setAsset('assets/audio/success.mp3');
    unawaited(_successAudioPlayer.play());
    _timer = Timer(const Duration(seconds: 1), () {});
  }

  @override
  void dispose() {
    _timer.cancel();
    _successAudioPlayer?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RiveAnimation.asset(
        'assets/rive/complete.riv',
        animations: ['run'],
      ),
    );
  }
}
