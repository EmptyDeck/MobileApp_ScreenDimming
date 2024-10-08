import 'package:flutter/material.dart';

class ExitCountdownOverlay extends StatelessWidget {
  final int tapsLeft;

  ExitCountdownOverlay({required this.tapsLeft});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Text('Click $tapsLeft more times to exit.'),
      actions: [
        TextButton(
          child: Text('Continue'),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}
