/// {@category backend}
///
/// The [Ticker] State-Model — provides State information coupled with a
/// functional and dynamic backend

// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:audioplayers/audioplayers.dart';

/// A State-Model that plays ticks at even intervals
class Ticker extends ChangeNotifier {
  /// Internally used [Timer]
  late final Timer _timer;

  /// Total duration for which the Ticker plays ticking sounds
  late final Duration totalDuration;

  /// Time between the playback of each ticking sound
  late final Duration timeBetweenTicks;

  /// Current tick
  int get tick => _timer.tick;

  /// Total number of tick's that will be played over [totalDuration]
  late final int totalTicks;

  /// Internally used audioplayers
  late AudioPlayer _tickPlayer, _tockPlayer;

  /// Create a [Ticker]
  Ticker({
    required this.totalDuration,
    required this.timeBetweenTicks,
  }) : totalTicks = totalDuration.inSeconds ~/ timeBetweenTicks.inSeconds;

  /// Start playing ticking sounds
  ///
  /// ### Args
  /// - `customDone`: Path to custom audio file to play when [totalDuration] has elapsed
  /// - `customTick`: Path to custom audio file to play on even ticks
  /// - `customTock`: Path to custom audio file to play on odd ticks (for the whole tick-tock effect)
  Future<void> startPlayback({
    String? customDone,
    String? customTick,
    String? customTock,
  }) async {
    // create audio players

    // 1. Player for the 'tick' sound
    _tickPlayer = AudioPlayer(playerId: 'playback-tick');
    await _tickPlayer.setReleaseMode(ReleaseMode.stop);

    customTick == null
        ? await _tickPlayer.setSourceAsset('tick.wav')
        : await _tickPlayer.setSourceDeviceFile(customTick);

    // 2. Player for the 'tock' sound
    _tockPlayer = AudioPlayer(playerId: 'playback-tock');
    await _tockPlayer.setReleaseMode(ReleaseMode.stop);

    customTock == null
        ? await _tockPlayer.setSourceAsset('tock.wav')
        : await _tockPlayer.setSourceDeviceFile(customTock);

    // Periodically play audio
    _timer = Timer.periodic(timeBetweenTicks, (timer) async {
      timer.tick % 2 == 0 ? await _tickPlayer.resume() : await _tockPlayer.resume();

      if (timer.tick - 1 == totalTicks) {
        customDone == null
            ? await _tickPlayer.play(AssetSource('alert.wav'))
            : await _tickPlayer.play(DeviceFileSource(customDone));

        timer.cancel();

        await _tockPlayer.dispose();

        await Future.delayed(
          const Duration(seconds: 5),
          () => _tickPlayer.dispose(),
        );
      }

      // trigger rebuild
      notifyListeners();
    });
  }

  /// Stop playing ticking sounds
  Future<void> stopPlayback() async {
    await _tickPlayer.dispose();
    await _tockPlayer.dispose();
    _timer.cancel();

    // trigger rebuild
    notifyListeners();
  }
}
