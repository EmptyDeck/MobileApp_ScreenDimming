import 'package:flutter/material.dart';
import 'dart:async';
import '../widgets/exit_countdown_overlay.dart';

class DimmingPage extends StatefulWidget {
  final int totalTime;
  final Color color;

  DimmingPage({required this.totalTime, required this.color});

  @override
  _DimmingPageState createState() => _DimmingPageState();
}

class _DimmingPageState extends State<DimmingPage> {
  late Timer timer;
  double opacity = 0.0;
  int timeLeft = 0;
  int exitTapCount = 3;

  @override
  void initState() {
    super.initState();
    timeLeft = widget.totalTime;
    startDimming();
  }

  void startDimming() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        timeLeft--;
        if (timeLeft <= 0) {
          timeLeft = 0;
          opacity = 1.0;
          timer.cancel();
        } else {
          opacity = 1.0 - (timeLeft / widget.totalTime);
        }
      });
    });
  }

  void handleExitTap() {
    setState(() {
      exitTapCount--;
    });
    if (exitTapCount == 0) {
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

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  String formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes}m ${secs}s';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: handleExitTap,
      child: Scaffold(
        body: Stack(
          children: [
            // Background Layer: The selected color
            Container(
              color: widget.color,
            ),
            // Middle Layer: Text indicators
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Time Left: ${formatTime(timeLeft)}',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Screen Dimness: ${(opacity * 100).toInt()}%',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                ],
              ),
            ),
            // Top Layer: Black overlay whose opacity increases over time
            Opacity(
              opacity: opacity,
              child: Container(
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
