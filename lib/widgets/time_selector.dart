import 'package:flutter/material.dart';

class TimeSelectorWidget extends StatelessWidget {
  final ValueChanged<int> onTimeAdded;
  final VoidCallback onClear;

  TimeSelectorWidget({required this.onTimeAdded, required this.onClear});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Select Time:', style: TextStyle(fontSize: 18)),
        SizedBox(height: 10),
        Wrap(
          spacing: 10,
          children: [
            ElevatedButton(
              onPressed: () => onTimeAdded(60),
              child: Text('1 min'),
            ),
            ElevatedButton(
              onPressed: () => onTimeAdded(300),
              child: Text('5 mins'),
            ),
            ElevatedButton(
              onPressed: () => onTimeAdded(900),
              child: Text('15 mins'),
            ),
            ElevatedButton(
              onPressed: () => onTimeAdded(1800),
              child: Text('30 mins'),
            ),
            ElevatedButton(
              onPressed: () => onTimeAdded(3600),
              child: Text('1 hour'),
            ),
            ElevatedButton(
              onPressed: onClear,
              child: Text('Clear'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            ),
          ],
        ),
      ],
    );
  }
}
