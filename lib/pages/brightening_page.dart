// brightening_page.dart

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import '../widgets/exit_countdown_overlay.dart';

class BrighteningPage extends StatefulWidget {
  final TimeOfDay wakeUpTime;
  final int brightenDuration; // in seconds
  final Color color;

  BrighteningPage({
    required this.wakeUpTime,
    required this.brightenDuration,
    required this.color,
  });

  @override
  _BrighteningPageState createState() => _BrighteningPageState();
}

class _BrighteningPageState extends State<BrighteningPage> {
  Timer? timer; // Timer for brightening
  Timer? timeLeftTimer; // Timer for updating time left until alarm
  double opacity = 0.0; // Start from 0.0
  int timeElapsed = 0;
  bool alarmPlayed = false;
  late AudioPlayer player;
  int actualBrightenDuration = 0;
  int exitTapCount = 3; // For exit confirmation
  late DateTime wakeUpDateTime;
  late int totalTime; // Total time from now until wake-up
  int timeLeftUntilAlarm = 0; // Total time left until alarm rings

  @override
  void initState() {
    super.initState();
    player = AudioPlayer();
    calculateTimes();
    startTimers();
  }

  void calculateTimes() {
    final now = DateTime.now();
    wakeUpDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      widget.wakeUpTime.hour,
      widget.wakeUpTime.minute,
    );

    if (wakeUpDateTime.isBefore(now)) {
      // If the time has already passed today, set it for tomorrow
      wakeUpDateTime = wakeUpDateTime.add(Duration(days: 1));
    }

    Duration timeUntilWakeUp = wakeUpDateTime.difference(now);
    int secondsUntilWakeUp = timeUntilWakeUp.inSeconds;

    // Adjust brighten duration if it's longer than time until wake-up
    actualBrightenDuration = widget.brightenDuration;
    if (actualBrightenDuration > secondsUntilWakeUp) {
      actualBrightenDuration = secondsUntilWakeUp;
    }

    // Calculate when to start brightening
    Duration delayBeforeBrighteningStarts =
        Duration(seconds: secondsUntilWakeUp - actualBrightenDuration);
    if (delayBeforeBrighteningStarts.isNegative) {
      // Start immediately if there's not enough time
      delayBeforeBrighteningStarts = Duration.zero;
      actualBrightenDuration = secondsUntilWakeUp;
    }

    totalTime = secondsUntilWakeUp;
    timeLeftUntilAlarm = secondsUntilWakeUp;

    // Start the brightening timer after the delay
    Future.delayed(delayBeforeBrighteningStarts, () {
      startBrighteningTimer();
    });
  }

  void startTimers() {
    // Timer to update time left until alarm every second
    timeLeftTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        timeLeftUntilAlarm--;
        if (timeLeftUntilAlarm <= 0) {
          timeLeftUntilAlarm = 0;
          timeLeftTimer?.cancel();
        }
      });
    });
  }

  void startBrighteningTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        timeElapsed++;
        if (timeElapsed >= actualBrightenDuration) {
          opacity = 1.0;
          timer.cancel();
          playAlarm();
        } else {
          opacity = timeElapsed / actualBrightenDuration;
        }
      });
    });
  }

  void playAlarm() async {
    if (!alarmPlayed) {
      await player.play(AssetSource('alarmsound.wav'));
      player.setReleaseMode(ReleaseMode.loop);
      alarmPlayed = true;
      // Show dialog to stop the alarm
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: Text('Alarm'),
          content: Text('Wake up!'),
          actions: [
            TextButton(
              onPressed: () {
                player.stop();
                Navigator.of(context).pop(); // Close the dialog
                Navigator.of(context).pop(); // Return to the previous screen
              },
              child: Text('Stop Alarm'),
            ),
          ],
        ),
      );
    }
  }

  void handleExitTap() {
    setState(() {
      exitTapCount--;
    });
    if (exitTapCount == 0) {
      timer?.cancel();
      timeLeftTimer?.cancel();
      Navigator.pop(context);
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return ExitCountdownOverlay(tapsLeft: exitTapCount);
        },
      );
    }
  }

  String formatTime(int seconds) {
    if (seconds < 0) seconds = 0;
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final secs = seconds % 60;
    if (hours > 0) {
      return '${hours}h ${minutes}m ${secs}s';
    } else if (minutes > 0) {
      return '${minutes}m ${secs}s';
    } else {
      return '${secs}s';
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    timeLeftTimer?.cancel();
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: handleExitTap,
      child: Scaffold(
        body: Stack(
          children: [
            // Background Layer: Black
            Container(
              color: Colors.black,
            ),
            // Top Layer: Selected color with increasing opacity
            Opacity(
              opacity: opacity,
              child: Container(
                color: widget.color,
              ),
            ),
            // Indicators
            Center(
              child: Opacity(
                opacity: 0.5, // 50% transparency
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Time Left: ${formatTime(timeLeftUntilAlarm)}',
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Brightness: ${(opacity * 100).toInt()}%',
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
